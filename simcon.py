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

import datetime
import pandas as pd
import numpy as np
from sqlalchemy import *
import json
from rdoclient import RandomOrgClient
import time


class Simulation:
    def __init__(self):
        self.engine = create_engine("sqlite:///simcon")

    def run(self):
        day = 1
        while not self.all_done():
            print "day", day
            self.a_day(day)
            day += 1
        project = Table('Fact_Project', MetaData(), autoload=True, autoload_with=self.engine)
        self.engine.execute(project.update().where(project.c.Done == 0).values(Done=1))

    def all_done(self):
        project_ids = pd.read_sql_query(
            "SELECT ProjectID FROM True_ProjectCompleteness WHERE True_ProjectCompleteness.ProjectCompleteness<1",
            self.engine)['ProjectID'].tolist()
        if len(project_ids) > 0:
            return False
        else:
            return True

    def a_day(self, day):
        self.meet_all(day)

        # who goes where and tries working on what
        confirmed = self.work(day)

        # self.collision(day)
        self.design_change(day)
        # self.check(day)
        self.infer(day, confirmed)

    def meet_all(self, day):
        projects = pd.read_sql_query(
            "SELECT ID as ProjectID FROM Fact_Project WHERE MeetingCycle<>0 AND " + str(day) + " % MeetingCycle =0",
            self.engine)
        if len(projects.ProjectID) == 0:
            return 0
        # information about task progress
        sync_task = pd.read_sql_query("SELECT * FROM Sync_Task", self.engine)
        sync_task = sync_task.merge(projects, how='inner', on=['ProjectID']).reset_index(drop=True)
        sync_task['Day'] = day - 1
        self.log_wp(sync_task)

        # information about production rate
        sync_production_rate = pd.read_sql_query("SELECT * FROM Sync_ProductionRate", self.engine)
        sync_production_rate = sync_production_rate.merge(projects, how='inner', on=['ProjectID']).reset_index(
            drop=True)
        sync_production_rate['Day'] = day - 1
        self.log_production_rate(sync_production_rate)

        # information about workspace priority
        sync_workspace_priority = pd.read_sql_query("SELECT * FROM Sync_WorkSpacePriority", self.engine)
        sync_workspace_priority = sync_workspace_priority.merge(projects, how='inner', on=['ProjectID']).reset_index(
            drop=True)
        sync_workspace_priority['Day'] = day - 1
        self.log_priority_space(sync_workspace_priority)

    def log_wp(self, data):
        data[['ProjectID', 'KnowledgeOwner', 'TaskID', 'RemainingQty', 'TotalQty', 'Day']].to_sql(
            name="Log_Task", con=self.engine, if_exists='append', index=False)

    def log_production_rate(self, data):
        data[['ProjectID', 'KnowledgeOwner', 'WorkMethod', 'ProductionRate', 'Day']].to_sql(
            name="Log_ProductionRate", con=self.engine, if_exists='append', index=False)

    def log_priority_space(self, data):
        data[['ProjectID', 'KnowledgeOwner', 'Floor', 'Priority', 'SubName', 'Day']].to_sql(
            name="Log_WorkSpacePriority", con=self.engine, if_exists='append', index=False)

    def work(self, day):
        assign = pd.read_sql_query("SELECT * FROM View_TaskSelected", self.engine)
        assign['Day'] = day
        self.log_wp(assign)

        # check the true completeness of predecessor
        backlog = pd.read_sql_query("SELECT TaskID,ProjectID FROM True_TaskBacklog", self.engine)
        backlog['Chosen'] = 1
        pre_complete = assign.merge(backlog, on=['TaskID', 'ProjectID'], how='left').reset_index(drop=True)
        retrace_pre = pre_complete[pre_complete.Chosen.isnull()].reset_index(drop=True)
        retrace_pre[['ProjectID', 'TaskID', 'Day']].to_sql(name="Event_RetracePredecessor", con=self.engine,
                                                           if_exists='append',
                                                           index=False)
        pre_complete = pre_complete[pre_complete.Chosen == 1].reset_index(drop=True)

        # one floor can only allow one sub working there
        space_complete = pre_complete.sort_values(['ProjectID', 'Floor', 'TaskCompleteness', 'Ran'],
                                                  ascending=[1, 1, 0, 0])
        space_complete = space_complete[space_complete.groupby(['ProjectID', 'Floor']).cumcount() == 0].reset_index(
            drop=True)
        retrace_space = pre_complete[['ProjectID', 'TaskID', 'Day']].merge(
            space_complete[['ProjectID', 'TaskID', 'Chosen']], how='left',
            on=['ProjectID', 'TaskID'])
        retrace_space = retrace_space[retrace_space.Chosen.isnull()].reset_index(drop=True)
        retrace_space[['ProjectID', 'TaskID', 'Day']].to_sql(name="Event_RetraceWorkSpace", con=self.engine,
                                                             if_exists='append',
                                                             index=False)
        # production rate change
        rates = list()
        for i in xrange(len(space_complete['TaskID'])):
            if space_complete['ProductionRateChange'][i] > 0:
                rate = max(self.norm_random(space_complete['ProductionRate'][i], space_complete['PerformanceStd'][i]),
                           0)
                rates.append(rate)
            else:
                rates.append(space_complete['ProductionRate'][i])
        space_complete['ProductionRate'] = rates
        self.log_production_rate(space_complete)
        # external condition un-mature
        workable = space_complete[space_complete.ProductionRate > 0].reset_index(drop=True)

        retrace_external = space_complete[['ProjectID', 'TaskID', 'Day']].merge(
            workable[['ProjectID', 'TaskID', 'Chosen']], how='left',
            on=['ProjectID', 'TaskID'])
        retrace_external = retrace_external[retrace_external.Chosen.isnull()].reset_index(drop=True)
        retrace_external[['ProjectID', 'TaskID', 'Day']].to_sql(name="Event_RetraceExternalCondition", con=self.engine,
                                                                if_exists='append',
                                                                index=False)

        # mark the beginning day of work packages
        workable[(workable.RemainingQty == workable.TotalQty)][['ProjectID', 'TaskID', 'Day']].to_sql(
            name="Event_WorkBegin", con=self.engine, if_exists='append', index=False)

        # the RemainingQty is no less than 0
        workable['RemainingQty'] = workable['RemainingQty'] - workable['ProductionRate']
        workable.loc[workable['RemainingQty'] < 0, 'RemainingQty'] = 0
        self.log_wp(workable)

        # upload retrace
        assign = assign.merge(workable[['ProjectID', 'TaskID', 'Chosen']], how='left', on=['ProjectID', 'TaskID'])
        retrace = assign[assign.Chosen.isnull()].reset_index(drop=True)
        retrace[['ProjectID', 'TaskID', 'Day']].to_sql(name="Event_Retrace", con=self.engine, if_exists='append',
                                                       index=False)

        # remember what he see in the floor
        subs = assign['SubName']
        floors = assign['Floor']
        projects = assign['ProjectID']
        for i in xrange(len(subs)):
            klg = pd.read_sql_query(
                "SELECT * FROM True_TaskLatest WHERE ProjectID=" + str(projects[i]) + " AND Floor=" + str(
                    floors[i]), self.engine)
            klg['KnowledgeOwner'] = subs[i]
            self.log_wp(klg[klg.KnowledgeOwner != klg.SubName])

        return assign

    # def collision(self, day):
    #     col = pd.read_sql_query(
    #         "SELECT * FROM True_SubCollision WHERE ProjectID=" + str(self.id) + " and Day=" + str(day), self.engine)
    #     if len(col['Floor']) == 0:
    #         return 0
    #     floors = col['Floor'].unique()
    #     for floor in floors:
    #         # only need to update their production rate and space priority
    #         # no need to sync wp status, since these have been update by sync_space
    #         self.sync_production_rate(col[col.Floor == floor][['SubName']])
    #         self.sync_priority_space(col[col.Floor == floor][['SubName']])

    def norm_random(self, mean, std):
        try:
            r = RandomOrgClient(self.random_key)
            # mean = v, std = std, last para is the extreme digit
            # see https://github.com/RandomOrg/JSON-RPC-Python/blob/master/rdoclient/rdoclient.py
            ran = r.generate_gaussians(1, mean, std, 5)[0]
        except:
            ran = np.random.normal(mean, std, 1)[0]
        return ran

    # def check(self, day):
    #     if self.quality_check == 0:
    #         return 0
    #     wps = pd.read_sql_query("SELECT * FROM True_TaskFinishedQualityUncheck WHERE ProjectID=" + str(self.id),
    #                             self.engine)
    #     if len(wps['TaskID']) == 0:
    #         return 0
    #     passed = list()
    #     for i in xrange(len(wps['TaskID'])):
    #         passed.append(np.random.binomial(1, wps['QualityPassRate'][i], 1)[0])
    #     wps['Pass'] = passed
    #     wps['Day'] = day
    #     wps[['ProjectID', 'TaskID', 'Day', 'Pass']].to_sql(name="Event_QualityCheck", con=self.engine,
    #                                                        if_exists='append', index=False)
    #     rework = wps[wps.Pass == 0].reset_index(drop=True)
    #     rework['RemainingQty'] = rework['TotalQty']
    #     self.log_wp(rework)

    def design_change(self, day):
        projects = pd.read_sql_query(
            "SELECT ID as ProjectID FROM Fact_Project WHERE Fact_Project.DesignChangeCycle<>0 AND " + str(
                day) + " % DesignChangeCycle=0",
            self.engine)
        if len(projects.ProjectID) == 0:
            return 0

        project_completeness = pd.read_sql_query("SELECT * FROM True_ProjectCompleteness WHERE ProjectCompleteness<1",
                                                 self.engine)
        projects = projects.merge(project_completeness, how='inner', on=['ProjectID']).reset_index(drop=True)
        if len(projects.ProjectID) == 0:
            return 0

        good = list()
        # if most of the work in the project has been completed, then the design will not be changed
        for i in xrange(len(projects["ProjectID"])):
            good.append(np.random.binomial(1, projects['ProjectCompleteness'][i], 1)[0])
        projects['Good'] = good
        projects = projects[projects.Good == 0].reset_index(drop=True)
        if len(projects.ProjectID) == 0:
            return 0

        candidate = pd.read_sql_query("SELECT * FROM True_DesignChangeRandom", self.engine)
        change = candidate.merge(projects[['ProjectID']], on=['ProjectID'], how='inner').reset_index(drop=True)

        if len(change['TaskID']) == 0:
            return 0
        # if the work package has not been started, then just update the status in the initial state
        # and don't change the date to today in log_wp
        change.loc[change.RemainingQty < change.TotalQty, 'Day'] = day
        qties = list()
        for i in xrange(len(change['TaskID'])):
            qty = 0
            while not qty > 0:
                qty = self.norm_random(change['TotalQty'][i], change['DesignChangeVariation'][i])
            qties.append(qty)
        change['TotalQty'] = qties
        change['RemainingQty'] = qties
        self.log_wp(change)

        # always mark the day when it is changed in design change log
        change['Day'] = day
        change[['ProjectID', 'TaskID', 'TotalQty', 'Day']].to_sql(name="Event_DesignChange", con=self.engine,
                                                                  if_exists='append', index=False)

    def infer(self, day, confirmed):
        # these klg have been updated in work function i.e who has known who worked where
        # and needs to be filtered out
        confirmed['F'] = 1
        assign = pd.read_sql_query("SELECT * FROM View_TaskBacklog WHERE KnowledgeOwner!=SubName", self.engine)
        # if len(confirmed['F']) == 0 and len(wps['TaskID']) == 0:
        #     self.meet_all(day)
        #     return 0

        assign = assign.merge(confirmed[['KnowledgeOwner', 'Floor', 'ProjectID', 'F']],
                              on=['KnowledgeOwner', 'Floor', 'ProjectID'], how='left')
        assign = assign[assign.F.isnull()]

        saw = confirmed[['KnowledgeOwner', 'Floor', 'ProjectID']].merge(confirmed[['SubName', 'Floor', 'ProjectID']],
                                                                        on=['Floor', 'ProjectID'], how='outer')[
            ['KnowledgeOwner', 'SubName', 'ProjectID']]
        saw['S'] = 1
        assign = assign.merge(saw, on=['KnowledgeOwner', 'SubName', 'ProjectID'], how='left')
        assign = assign[assign.S.isnull()].reset_index(drop=True)

        assign = assign.sort_values(
            ['ProjectID', 'KnowledgeOwner', 'SubName', 'TaskCompleteness', 'FloorCompleteness', 'WorkspacePriority',
             'Ran'],
            ascending=[1, 1, 1, 0, 0, 0, 0])
        assign = assign[assign.groupby(['ProjectID', 'KnowledgeOwner', 'SubName']).cumcount() == 0].reset_index(
            drop=True)

        # only one work is allowed in one floor
        assign = assign.sort_values(['ProjectID', 'KnowledgeOwner', 'Floor', 'TaskCompleteness', 'Ran'],
                                    ascending=[1, 1, 1, 0, 0])
        assign = assign[assign.groupby(['ProjectID', 'KnowledgeOwner', 'Floor']).cumcount() == 0].reset_index(
            drop=True)

        assign['Day'] = day
        assign['RemainingQty'] = assign['RemainingQty'] - assign['ProductionRate']
        assign.loc[assign['RemainingQty'] < 0, 'RemainingQty'] = 0
        self.log_wp(assign)

    #
    # def sync(self, subs):
    #     self.sync_work_package(subs)
    #     self.sync_production_rate(subs)
    #     self.sync_priority_space(subs)
    #
    # def sync_work_package(self, subs):
    #     status = pd.read_sql_query("SELECT * FROM True_TaskLatest" + str(
    #         self.id), self.engine)
    #     subs_status = subs.merge(status, on=['SubName'], how='inner')
    #     for sub in subs['SubName'].tolist():
    #         subs_status['KnowledgeOwner'] = sub
    #         self.log_wp(subs_status[subs_status.KnowledgeOwner != subs_status.SubName])
    #
    # def sync_production_rate(self, subs):
    #     status = pd.read_sql_query("SELECT * FROM True_ProductionRateLatest WHERE ProjectID=" + str(
    #         self.id), self.engine)
    #     subs_status = subs.merge(status, on=['SubName'], how='inner')
    #     for sub in subs['SubName'].tolist():
    #         subs_status['KnowledgeOwner'] = sub
    #         self.log_production_rate(subs_status[subs_status.KnowledgeOwner != subs_status.SubName])
    #
    # def sync_priority_space(self, subs):
    #     status = pd.read_sql_query("SELECT * FROM True_WorkSpacePriorityLatest WHERE ProjectID=" + str(
    #         self.id), self.engine)
    #     subs_status = subs.merge(status, on=['SubName'], how='inner')
    #     for sub in subs['SubName'].tolist():
    #         subs_status['KnowledgeOwner'] = sub
    #         self.log_priority_space(subs_status[subs_status.KnowledgeOwner != subs_status.SubName])

    def export(self, filename):

        result = pd.read_sql_query("SELECT * FROM _Result", self.engine)
        result['Date'] = pd.to_timedelta(result['Day'], unit='d') + datetime.date(2015, 1, 1)
        # result[['WPName', 'Date', 'Day', 'StatusFiltered', 'Status', 'SubName', 'Floor', 'WorkMethod', 'Retrace',
        #         'DesignChange', 'LowProductivity', 'Meeting', 'QualityFail', 'ProjectID', 'TaskID']].to_csv(
        #     filename, sep='\t', encoding='utf-8',
        #     index=False)
        # result[['WPName', 'Date', 'Day', 'Status', 'SubName', 'Floor', 'WorkMethod', 'Retrace',
        #         'DesignChange', 'LowProductivity', 'Meeting', 'QualityFail', 'Collision', 'ProductionRate', 'ProjectID',
        #         'TaskID']].to_csv(
        #     filename, sep='\t', encoding='utf-8',
        #     index=False)

        result[['WPName', 'Date', 'Day', 'Status', 'SubName', 'Floor', 'WorkMethod', 'ProjectID', 'TaskID', 'NotMature',
                'DesignChange', 'PredecessorIncomplete', 'WorkSpaceCongestion', 'ExternalCondition']].to_csv(
            filename, sep='\t', encoding='utf-8',
            index=False)
        print "result exported to", filename


if __name__ == '__main__':
    game = Simulation()
    game.run()
    game.export("result.csv")
