# **************************************************************************
# *
# Copyright (c) 2015 * 
# Ling Ma <bitly.com/cvlingma> * 
# *
# This program is free software; you can redistribute it and/or modify *
# it under the terms of the GNU Lesser General Public License (LGPL) *
# as published by the Free Software Foundation; either version 2 of *
# the License, or (at your option) any later version. *
# for detail see the LICENCE text file. *
# *
# This program is distributed in the hope that it will be useful, *
# but WITHOUT ANY WARRANTY; without even the implied warranty of *
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the *
# GNU Library General Public License for more details. *
# *
# You should have received a copy of the GNU Library General Public *
# License along with this program; if not, write to the Free Software *
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 *
# USA *
# *
# **************************************************************************
__author__ = 'Ling Ma'

import pandas as pd
import numpy as np
from sqlalchemy import *
import json
from rdoclient import RandomOrgClient
import time


class Project:
    def __init__(self, engine, id, meeting_cycle, design_change_cycle, design_change_variation, production_rate_change,
                 quality_check, priority_change, task_selection_function):
        self.engine = engine
        self.meeting_cycle = meeting_cycle
        self.design_change_cycle = design_change_cycle
        self.design_change_variation = design_change_variation
        self.production_rate_change = production_rate_change
        self.quality_check = quality_check
        self.priority_change = priority_change
        self.task_selection_function = task_selection_function
        self.id = id
        json_key = json.load(open('OAuth2Credentials.json'))
        self.random_key = json_key['random_org_key']

    def run(self):
        day = 1
        while not self.all_done():
            print "day", day
            self.a_day(day)
            day += 1
        project = Table('Fact_Project', MetaData(), autoload=True, autoload_with=self.engine)
        self.engine.execute(project.update().where(project.c.ID == self.id).values(Done=1))

    def all_done(self):
        ids = list()
        if self.quality_check == 0:
            ids = pd.read_sql_query("SELECT WorkPackageID FROM True_WorkPackageLatestStatus WHERE ProjectID=" + str(
                self.id) + " and RemainingQty>0", self.engine)['WorkPackageID'].tolist()
        else:
            ids = pd.read_sql_query("SELECT WorkPackageID FROM True_WorkPackageQualityUncheck WHERE ProjectID=" + str(
                self.id), self.engine)['WorkPackageID'].tolist()
        if len(ids) > 0:
            return False
        else:
            return True

    def a_day(self, day):
        self.meeting(day)
        self.work(day)
        self.collision(day)
        self.design_change(day)
        self.check(day)
        self.infer(day)

    def meeting(self, day):
        if self.meeting_cycle == 0 or day == 1 or (day - 1) % self.meeting_cycle != 0:
            return 0
        subs = pd.read_sql_query("SELECT SubName FROM Fact_Sub", self.engine)
        self.sync(subs)
        meeting_table = Table('Event_Meeting', MetaData(), autoload=True, autoload_with=self.engine)
        self.engine.execute(meeting_table.insert().values({"Day": day, "ProjectID": self.id}))

    def sync(self, subs):
        self.sync_work_package(subs)
        self.sync_production_rate(subs)
        self.sync_priority_space(subs)

    def sync_work_package(self, subs):
        status = pd.read_sql_query("SELECT * FROM True_WorkPackageLatestStatus WHERE ProjectID=" + str(
            self.id), self.engine)
        subs_status = subs.merge(status, on=['SubName'], how='inner')
        for sub in subs['SubName'].tolist():
            subs_status['KnowledgeOwner'] = sub
            self.log_wp(subs_status[subs_status.KnowledgeOwner != subs_status.SubName])

    def log_wp(self, data):
        data[['ProjectID', 'KnowledgeOwner', 'WorkPackageID', 'RemainingQty', 'TotalQty', 'Day']].to_sql(
            name="Log_WorkPackage", con=self.engine, if_exists='append', index=False)

    def sync_production_rate(self, subs):
        status = pd.read_sql_query("SELECT * FROM True_ProductionRate WHERE ProjectID=" + str(
            self.id), self.engine)
        subs_status = subs.merge(status, on=['SubName'], how='inner')
        for sub in subs['SubName'].tolist():
            subs_status['KnowledgeOwner'] = sub
            self.log_production_rate(subs_status[subs_status.KnowledgeOwner != subs_status.SubName])

    def log_production_rate(self, data):
        data[['ProjectID', 'KnowledgeOwner', 'WorkProcedure', 'ProductionRate', 'Day']].to_sql(
            name="Log_ProductionRate", con=self.engine, if_exists='append', index=False)

    def sync_priority_space(self, subs):
        status = pd.read_sql_query("SELECT * FROM True_WorkSpacePriority WHERE ProjectID=" + str(
            self.id), self.engine)
        subs_status = subs.merge(status, on=['SubName'], how='inner')
        for sub in subs['SubName'].tolist():
            subs_status['KnowledgeOwner'] = sub
            self.log_priority_space(subs_status[subs_status.KnowledgeOwner != subs_status.SubName])

    def log_priority_space(self, data):
        data[['ProjectID', 'KnowledgeOwner', 'Floor', 'Priority', 'SubName', 'Day']].to_sql(
            name="Log_WorkSpacePriority", con=self.engine, if_exists='append', index=False)

    def work(self, day):
        wps = pd.DataFrame()
        if self.task_selection_function == 0:
            wps = pd.read_sql_query("SELECT * FROM View_WorkPackageSelectedRandom WHERE ProjectID=" + str(self.id),
                                    self.engine)
        else:
            wps = pd.read_sql_query("SELECT * FROM View_WorkPackageSelected WHERE ProjectID=" + str(self.id),
                                    self.engine)
        wps['Day'] = day

        # production rate change
        if self.production_rate_change > 0:
            rates = list()
            for i in xrange(len(wps['WorkPackageID'])):
                rate = max(self.norm_random(wps['ProductionRate'][i], wps['PerformanceStd'][i]), 0)
                rates.append(rate)
            wps['ProductionRate'] = rates
            self.log_production_rate(wps)

        # check the maturity
        backlog = pd.read_sql_query(
            "SELECT WorkPackageID,ProjectID FROM True_WorkPackageBacklog WHERE ProjectID=" + str(self.id),
            self.engine)
        workable = wps.merge(backlog, on=['WorkPackageID', 'ProjectID'], how='inner').reset_index(drop=True)
        workable['RemainingQty'] = workable['RemainingQty'] - workable['ProductionRate']
        workable.loc[workable['RemainingQty'] < 0, 'RemainingQty'] = 0
        self.log_wp(workable)

        # upload retrace
        wps[~wps.WorkPackageID.isin(workable.WorkPackageID)][['ProjectID', 'WorkPackageID', 'Day']].to_sql(
            name="Event_Retrace", con=self.engine, if_exists='append', index=False)

    def norm_random(self, mean, std):
        try:
            r = RandomOrgClient(self.random_key)
            # mean = v, std = std, last para is the extreme digit
            # see https://github.com/RandomOrg/JSON-RPC-Python/blob/master/rdoclient/rdoclient.py
            ran = r.generate_gaussians(1, mean, std, 5)[0]
        except:
            ran = np.random.normal(mean, std, 1)[0]
        return ran

    def collision(self, day):
        col = pd.read_sql_query(
            "SELECT * FROM True_SubCollision WHERE ProjectID=" + str(self.id) + " and Day=" + str(day), self.engine)
        if len(col['Floor']) == 0:
            return 0
        floors = col['Floor'].unique()
        for floor in floors:
            self.sync(col[col.Floor == floor][['SubName']])

    def design_change(self, day):
        if self.design_change_cycle == 0 or day == 1 or (
                    day - 1) % self.design_change_cycle != 0 or self.design_change_variation == 0:
            return 0
        wp = pd.read_sql_query("SELECT * FROM True_WorkPackageQualityUncheckRandom WHERE ProjectID=" + str(self.id),
                               self.engine)
        if len(wp['WorkPackageID']) == 0:
            return 0
        qty = 0
        wp['Day'] = day
        while not qty > 0:
            qty = self.norm_random(wp['TotalQty'][0], wp['PerformanceStd'][0])
        wp['TotalQty'] = qty
        self.log_wp(wp)
        wp[['ProjectID', 'WorkPackageID', 'TotalQty', 'Day']].to_sql(name="Event_DesignChange", con=self.engine,
                                                                     if_exists='append', index=False)

    def check(self, day):
        if self.quality_check == 0:
            return 0
        wps = pd.read_sql_query("SELECT * FROM True_WorkPackageFinishedQualityUncheck WHERE ProjectID=" + str(self.id),
                                self.engine)
        if len(wps['WorkPackageID']) == 0:
            return 0
        passed = list()
        for i in xrange(len(wps['WorkPackageID'])):
            passed.append(np.random.binomial(1, wps['QualityPassRate'][i], 1)[0])
        wps['Pass'] = passed
        wps[['ProjectID', 'WorkPackageID', 'Day', 'Pass']].to_sql(name="Event_QualityCheck", con=self.engine,
                                                                  if_exists='append', index=False)

    def infer(self, day):
        wps = pd.DataFrame()
        if self.task_selection_function == 0:
            wps = pd.read_sql_query("SELECT * FROM View_WorkPackageInferenceRandom WHERE ProjectID=" + str(self.id),
                                    self.engine)
        else:
            wps = pd.read_sql_query("SELECT * FROM View_WorkPackageInference WHERE ProjectID=" + str(self.id),
                                    self.engine)
        wps['Day'] = day
        wps['RemainingQty'] = wps['RemainingQty'] - wps['ProductionRate']
        wps.loc[wps['RemainingQty'] < 0, 'RemainingQty'] = 0
        self.log_wp(wps)


class Simulation:
    def __init__(self):
        engine = create_engine("sqlite:///simcon")
        runs = pd.read_sql_query("SELECT * FROM Fact_Project", engine)
        self.projects = list()
        for i in xrange(len(runs['ID'])):
            self.projects.append(
                Project(engine, runs['ID'][i], runs['MeetingCycle'][i], runs['DesignChangeCycle'][i],
                        runs['DesignChangeVariation'][i], runs['ProductionRateChange'][i], runs['QualityCheck'][i],
                        runs['PriorityChange'][i], runs['TaskSelectionFunction'][i]))

    def run(self):
        i = 1
        for project in self.projects:
            t0 = time.clock()
            project.run()
            t1 = time.clock() - t0
            print "project", i, "takes", t1, "seconds"


if __name__ == '__main__':
    game = Simulation()
    game.run()
