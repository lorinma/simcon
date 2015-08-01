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
import numpy as np
import pandas as pd
import gviz_api
from rdoclient import RandomOrgClient
import json


def convert_list_to_dataframe(data, dfs):
    """
    convet the python list of dictionary to data frame in pandas

    :param data:
    :param dfs:
    :return:
    """
    for k in data:
        dfs[k] = pd.DataFrame(data=data[k])


def dataframe_row_count(table):
    return len(table.index)


# the true status of all WPs before the given time
# the sub's perception about his own tasks is the truth
def latestWPStatusByTime(dfs, gameTime):
    df = dfs['Log_WPStatus']
    latest = df[(df.Klg_Owner == df.SubName) & (df.gameTime <= gameTime)]
    latest = latest.groupby(['WPID'], sort=False).last().reset_index()
    return latest


def remainingWPStatusByTime(dfs, gameTime):
    wps = latestWPStatusByTime(dfs, gameTime)
    wps = wps[(wps.Duration > 0)].reset_index(drop=True)
    return wps


def finishedWPStatusByTime(dfs, gameTime):
    wps = latestWPStatusByTime(dfs, gameTime)
    wps = wps[(wps.Duration == 0)].reset_index(drop=True)
    return wps


def unPassedWPByTime(dfs, gameTime):
    passed = dfs['Log_QualityCheck'][(dfs['Log_QualityCheck'].passed == 1)][['WPID', 'passed']].reset_index(drop=True)
    wps = latestWPStatusByTime(dfs, gameTime)
    wps = wps.merge(passed, on='WPID', how='left')
    wps = wps[(wps.passed != 1)].reset_index(drop=True)
    del wps['passed']
    return wps


def gameEnd(dfs, gameTime):
    rate = dfs['Fact_Project']['QualityCheckPassRate'][0]
    if rate == 0 or rate >= 1:
        return dataframe_row_count(remainingWPStatusByTime(dfs, gameTime)) == 0
    else:
        # if quality check is required
        return dataframe_row_count(unPassedWPByTime(dfs, gameTime)) == 0


# first get the latest accurate position of each sub (if he has been to any space, and left records in activity log)
def latestActivityByTime(dfs, gameTime):
    df = dfs['Log_Activity']
    activities = df[(df.Klg_Owner == df.SubName) & (df.gameTime <= gameTime)].reset_index(drop=True)
    activities = activities.groupby(['SubName'], sort=False).last().reset_index()
    return activities


# the sub's latest klg of WPStatus
def WPStatusByOwnerByTime(dfs, owner, gameTime):
    df = dfs['Log_WPStatus']
    latest = df[(df.Klg_Owner == owner) & (df.gameTime <= gameTime)]
    latest = latest.groupby(['WPID'], sort=False).last().reset_index()
    return latest


def lastTaskStatusOfSubByOwner(dfs, sub, owner, gameTime):
    lastTask = activityOfSubByOwnerByTime(dfs, sub, owner, gameTime)
    latestPlan = latestPlanByOwnerByTime(dfs, owner, gameTime)
    last = lastTask[['WPID']].merge(latestPlan[['WPID', 'startTime', 'Duration']], on='WPID', how='inner')
    return last


# the owner's klg of sub's latest activity
def activityOfSubByOwnerByTime(dfs, sub, owner, gameTime):
    df = dfs['Log_Activity']
    latest = df[(df.Klg_Owner == owner) & (df.SubName == sub) & (df.gameTime <= gameTime)]
    latest = latest.groupby(['SubName'], sort=False).last().reset_index()
    return latest


# the sub's latest plan of WPStatus
def latestPlanByOwnerByTime(dfs, owner, gameTime):
    df = dfs['Log_Plan']
    latest = df[(df.Klg_Owner == owner) & (df.gameTime <= gameTime)]
    latest = latest.groupby(['WPID'], sort=False).last().reset_index()
    return latest

def rand_key():
    json_key = json.load(open('OAuth2Credentials.json'))
    return json_key['random_org_key']

# first choose the WPs in lowest floor, then randomly pick one if there're more than 1 in the lowest floor
# 1 record of WP with startTime and other info
# TODO this could be replaced by more advanced utitlity function
def prioritizeBacklogOfSubByOwnerByTime(dfs, sub, owner, gameTime):
    # all the tasks in the owner's klg
    tasks = latestPlanByOwnerByTime(dfs, owner, gameTime).merge(dfs['Fact_WorkPackage'][['WPID', 'Floor']], on='WPID',
                                                                how='left')
    # filter to the subs mature works
    backlog = tasks[(tasks.startTime == 0) & (tasks.Duration > 0) & (tasks.SubName == sub)].reset_index(drop=True)
    count = dataframe_row_count(backlog)
    if count == 0:
        return ''
    # assume the wp start from the floor which has the highest priority
    backlog = backlog.merge(latestWorkspacePriorityByTime(dfs, gameTime), on='Floor', how='left')
    backlog = backlog[(backlog['Priority'] == backlog['Priority'].max())].reset_index(drop=True)
    count = dataframe_row_count(backlog)
    radInt = 0
    if count > 1:
        # randomly select a row from the result if there're more than 1 row
        try:
            r = RandomOrgClient(rand_key())
            radInt = r.generate_integers(1, 0, count - 1)[0]
        except:
            radInt = np.random.randint(count, size=1)[0]
    return backlog['WPID'][radInt]


# the true status of all WPs before the given time
# the sub's perception about his own tasks is the truth
def latestWorkspacePriorityByTime(dfs, gameTime):
    df = dfs['Log_WorkspacePriority']
    df = df[(df.gameTime <= gameTime)]
    latest = df.groupby(['Floor'], sort=False).last().reset_index()
    return latest[['Floor', 'Priority']]


# the true status of all WPs in a space/floor
def latestWPStatusBySpaceByTime(dfs, floor, gameTime):
    wps = latestWPStatusByTime(dfs, gameTime)
    wps = wps[(wps.Floor == floor)].reset_index(drop=True)
    return wps


def randomChange(mu, std):
    if std > 0:
        try:
            # the value should always >0
            r = RandomOrgClient(rand_key())
            # mu = v, std = std, last para is the extreme digit
            # see https://github.com/RandomOrg/JSON-RPC-Python/blob/master/rdoclient/rdoclient.py
            ran = r.generate_gaussians(1, mu, std, 5)[0]
            # return np.random.normal(v, std, 1)[0]
        except:
            ran = np.random.normal(mu, std, 1)[0]
        return ran
    else:
        # if std<=0, then return the mu = v
        return mu


# get the track of wp every iternation/day
def wpTrack(dfs):
    activity = movementTrack(dfs)
    start = startDate(dfs)

    fact_wp = dfs['Fact_WorkPackage']
    fact_wpro = dfs['Fact_WorkProcedure']
    combined = activity.append(start).reset_index(drop=True).merge(fact_wp, on=['WPID'], how='left').merge(fact_wpro,
                                                                                                           on=[
                                                                                                               'Workprocedure'],
                                                                                                           how='left')
    combined = combined.sort(columns=['SubName', 'gameTime']).reset_index(drop=True)
    combined['Day'] = pd.to_timedelta(combined['gameTime'], unit='d') + datetime.date.today()
    # mongo db doesn't accept the date format in python
    combined['Day'] = combined['Day'].apply(str)
    combined['WPName'] = combined['Floor'].apply(str) + '-' + combined['Workprocedure']
    combined['percent'] = combined['status'] - combined['Floor'] + 1

    # add meeting event
    meeting = dfs['Log_Meeting'][['gameTime']]
    meeting['meeting'] = 1
    combined = combined.merge(meeting, on='gameTime', how='left')

    # add quality check rework event
    rework = dfs['Log_QualityCheck'][(dfs['Log_QualityCheck'].passed == 0)].reset_index(drop=True)
    rework['rework'] = 1
    combined = combined.merge(rework[['WPID', 'gameTime', 'rework']], on=['gameTime', 'WPID'], how='left')

    # add design change event
    designChange = dfs['Log_DesignChange'][['WPID', 'gameTime']]
    designChange['designChange'] = 1
    combined = combined.merge(designChange, on=['gameTime', 'WPID'], how='left')

    combined = combined.fillna(0)

    dfs['Result'] = combined
    return combined


def movementTrack(dfs):
    # true movement of subs
    activity = activityTrack(dfs)
    collision = collisionTrack(dfs)
    activity = activity.merge(collision, on=['gameTime', 'Floor'], how='left')
    activity['status'] = activity['Floor'] - 1
    # goto work but not mature as default value
    activity['notMature'] = 1
    activity = activity[['WPID', 'gameTime', 'status', 'collision', 'notMature']]

    # including the rework command
    worked = workedRecords(dfs)
    worked = worked.merge(activity[['WPID', 'gameTime', 'collision']], on=['WPID', 'gameTime'], how='left')

    # merge the work records with the activity records
    activity.set_index(['WPID', 'gameTime'], inplace=True)
    worked.set_index(['WPID', 'gameTime'], inplace=True)
    activity.update(worked)
    activity = activity.reset_index()

    return activity


def activityTrack(dfs):
    log_activity = dfs['Log_Activity']
    # true movement records of subs
    activity = log_activity[(log_activity.Klg_Owner == log_activity.SubName)]
    activity = activity.groupby(['WPID', 'gameTime'], sort=False).last().reset_index()[
        ['SubName', 'gameTime', 'Floor', 'WPID']].sort(columns=['SubName'])
    return activity


def collisionTrack(dfs):
    activity = activityTrack(dfs)
    # find collision situation by time and floor
    collision = activity[['SubName', 'gameTime', 'Floor']].groupby(['gameTime', 'Floor']).count().reset_index().rename(
        columns={'SubName': 'collision'})
    # exagerate the value for better visualization
    # collision['collision'] = np.power(10,collision['collision'])
    return collision


def workedRecords(dfs):
    log_wps = dfs['Log_WPStatus']
    # derive work records
    worked = log_wps[(log_wps.Klg_Owner == log_wps.SubName) & (log_wps.gameTime > 0)]
    worked = worked.groupby(['WPID', 'gameTime'], sort=False).last().reset_index()[
        ['WPID', 'Floor', 'gameTime', 'Qty', 'RemainingQty']]
    worked['status'] = (worked['Qty'] - worked['RemainingQty']) / worked['Qty'] + worked['Floor'] - 1
    # all the records here are successfully worked
    worked['notMature'] = 0
    worked = worked[['WPID', 'gameTime', 'status', 'notMature']]
    return worked


def startDate(dfs):
    log_wps = dfs['Log_WPStatus']
    start = log_wps[(log_wps.Klg_Owner == log_wps.SubName) & (log_wps.RemainingQty < log_wps.Qty)].groupby(['WPID'],
                                                                                                           sort=False).first().reset_index()[
        ['WPID', 'gameTime', 'Qty', 'RemainingQty', 'SubName', 'Workprocedure', 'Floor']]
    start['status'] = start['Floor'] - 1
    start['gameTime'] = start['gameTime'] - 1
    start['collision'] = 0
    start['notMature'] = 0
    start = start[['WPID', 'gameTime', 'status', 'collision', 'notMature']].reset_index(drop=True)
    return start


# according to example: https://github.com/google/google-visualization-python/blob/master/examples/dynamic_example.py
def ToGvizHeaders(dataframe):
    dt = dataframe.dtypes
    header = {}
    # Loop to add the columns from the dataframe to the gviz datatable
    for col in dataframe.columns.values:
        gvdt = dt[col]
        if dt[col] == "float64" or dt[col] == "int64":
            gvdt = "number"
        elif dt[col] == "datetime64[ns]":
            gvdt = "date"
        else:
            gvdt = "string"
        header[col] = (gvdt, col)
    return header


# according to example: https://github.com/google/google-visualization-python/blob/master/examples/dynamic_example.py
def ToGvizData(dataframe):
    return dataframe.to_dict('records')


# according to example: https://github.com/google/google-visualization-python/blob/master/examples/dynamic_example.py
def ToGvizDataTable(dataframe):
    data_table = gviz_api.DataTable(ToGvizHeaders(dataframe))
    data_table.LoadData(ToGvizData(dataframe))
    # return data_table.ToJSonResponse(columns_order=("WPName", "Day", "gameTime", "status"), order_by="WPName")
    # return data_table.ToJSon(columns_order=("WPName", "Day", "gameTime", "status", "percent", "SubName", "Workprocedure", "Floor", "WPID", "collision", "notMature",'designChange','meeting'), order_by="WPName")
    return data_table.ToJSon(columns_order=(
        "WPName", "Day", "gameTime", "status", "percent", "SubName", "Workprocedure", "Floor", "WPID", "collision",
        "notMature", 'rework', 'designChange', 'meeting'), order_by="WPName")


# def loadMongo(dfs, oid):
#     from pymongo import MongoClient
#     from bson.objectid import ObjectId
#
#     client = MongoClient(host='192.168.59.107', port=27017)
#     db = client.simcon
#     collection = db.simulation
#
#     oid = ObjectId(oid)
#     # oid = ObjectId("55a203975412d90009bf6f75")
#     data = collection.find_one({'_id': oid})
#     result = pd.DataFrame(list(data['Result']))
#     log_activity = pd.DataFrame(list(data['Log_Activity']))
#     log_wps = pd.DataFrame(list(data['Log_WPStatus']))
#     fact_wp = pd.DataFrame(list(data['Fact_WorkPackage']))
#     fact_wpro = pd.DataFrame(list(data['Fact_WorkProcedure']))
#     log_plan = pd.DataFrame(list(data['Log_Plan']))
#     dfs['Result'] = result
#     dfs['Log_Activity'] = log_activity
#     dfs['Log_WPStatus'] = log_wps
#     dfs['Fact_WorkPackage'] = fact_wp
#     dfs['Fact_WorkProcedure'] = fact_wpro
#     dfs['Log_Plan'] = log_plan
