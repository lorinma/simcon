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

import time
import initialData as inD
import events
import helper
import uuid
import pandas as pd


def simulation():
    t0 = time.clock()
    dfs = load_dataframe_from_spreadsheet()
    t1 = time.clock() - t0
    print 'loadDataFromGSheet takes', t1, 'seconds'
    i = 1
    # only load unrun projects
    projects = dfs['Fact_Project'][dfs['Fact_Project'].ProjectID==''].reset_index(drop=True)[['Username', 'DesignChangeVariation', 'DesignChangeCycle', 'QualityCheckPassRate', 'ProjectName', 'productionRateChangeStd', 'meetingCycle', 'Email']]
    results = []
    while helper.dataframe_row_count(projects) > 0:
        dfs['Fact_Project'] = projects[(projects.index == 0)].reset_index(drop=True)
        print 'start a new game', i
        result = new_game(dfs)
        result['ProjectID'] = uuid.uuid1().hex
        # result['WPName'] = str(i) + '-' + result['WPName']
        result = result[["WPName", "Day", "gameTime", "status", "percent", "SubName", "Workprocedure", "Floor", "WPID", "collision", "notMature",'rework','designChange','meeting','ProjectID']]
        result.to_csv(str(i)+'result.csv', sep='\t', encoding='utf-8', index=False)
        print 'simulation result saved as', str(i)+'result.csv'
        # results.append(result)
        projects = projects.ix[1:].reset_index(drop=True)
        i += 1
    # data=pd.concat(results).reset_index(drop=True)
    # uploadDataToGspread(data)

def load_dataframe_from_spreadsheet():
    spreadsheet = inD.load_db()
    data = inD.load_all_data(spreadsheet)
    dfs = {}
    helper.convert_list_to_dataframe(data, dfs)
    return dfs


def new_game(dfs):
    t0 = time.clock()
    initial_data(dfs)
    t1 = time.clock() - t0
    print 'initialData takes', t1, 'seconds'
    run(dfs)
    t2 = time.clock() - t1
    print 'simulation takes', t2, 'seconds'
    return helper.wpTrack(dfs)


def initial_data(dfs):
    inD.initialWorkpackage(dfs)
    inD.initialWPDependency(dfs)
    inD.initialSpacePriority(dfs)
    inD.initialPlan(dfs)
    inD.initialActivity(dfs)
    inD.initialQualityCheck(dfs)
    inD.initialDesignChange(dfs)
    inD.initialMeetingLog(dfs)


def run(dfs):
    gameTime = 1
    while True:
        print 'Day', gameTime
        aDay(dfs, gameTime)
        gameTime += 1
        # if helper.rowCount(helper.remainingWPStatusByTime(dfs,gameTime))==0:
        if helper.gameEnd(dfs, gameTime):
            break
    print 'game ends!'


def meeting_check(dfs, gameTime):
    meetingCycle = dfs['Fact_Project'].iloc[0]['meetingCycle']
    if meetingCycle > 0:
        if (gameTime - 1) % meetingCycle == 0:
            # do the meeting every cycle time
            events.meeting(dfs, gameTime)
    elif gameTime == 1:
        # if no regular meetings, only do the meeting once at the begining of the game
        events.meeting(dfs, gameTime)


# iterate every sub, at the end of the day, everyone do a plan for tomorrow based on their own assumption
def aDay(dfs, gameTime):
    meeting_check(dfs, gameTime)
    # get the latest status yesterday
    wps = helper.latestWPStatusByTime(dfs, gameTime - 1)
    subs = dfs['Fact_Sub']['SubName']
    for owner in subs:
        # if his own tasks are done, then no need to guess others
        if helper.dataframe_row_count(wps[(wps.SubName == owner) & (wps.Duration > 0)]) == 0:
            continue
        # first do his own action, then start imaging others' behavior
        events.deduction(dfs, owner, owner, gameTime)
        for sub in subs:
            if (sub == owner):
                continue
            events.deduction(dfs, sub, owner, gameTime)
    events.collision_check(dfs, gameTime)
    events.qualityCheck(dfs, gameTime)
    designChangeCheck(dfs, gameTime)
    for sub in subs:
        # do plan for everybody!using the yesterday's info
        events.plan(dfs, sub, gameTime)
    return 1


def designChangeCheck(dfs, gameTime):
    designChangeCycle = dfs['Fact_Project']['DesignChangeCycle'][0]
    if designChangeCycle > 0:
        if gameTime > 1 and (gameTime - 1) % designChangeCycle == 0:
            # do the meeting every cycle time
            events.designChange(dfs, gameTime)


def uploadDataToGspread(data):
    """
    upload the dataframe to google spreadsheet, make sure the sharer has the right to write data

    :type data: pandas.dataframe
    """
    db = inD.load_db()
    sh = db.worksheet('Result')
    data = map(list, data.values)
    for da in data:
        sh.append_row(da)

# This is the main of the program.
if __name__ == "__main__":
    simulation()
