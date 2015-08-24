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

import helper
import pandas as pd
import numpy as np
from rdoclient import RandomOrgClient


def meeting(dfs, gameTime):
    """
    weekly meeting: update their klg of the previous day meeting is at the begining of the day, so the klg belongs to gameTime-1

    :param dfs:
    :param gameTime:
    :return:
    """
    subs = dfs['Fact_Sub'][['SubName']]
    syncWPStatus_among_subs(dfs, subs, gameTime - 1)
    syncActivity_among_subs(dfs, subs, gameTime - 1)
    for sub in subs['SubName']:
        # do plan for everybody!using the yesterday's info
        plan(dfs, sub, gameTime - 1)
    # the initial meeting doesn't count in the log
    if gameTime>1:
        new_meeting = {'gameTime': gameTime}
        dfs['Log_Meeting'].loc[helper.dataframe_row_count(dfs['Log_Meeting'])] = new_meeting


def syncWPStatus_among_subs(dfs, subs, gameTime):
    """
    use the true wp status to update every subs knowledge of WPStatus, input a pandas data frame of subs

    :param dfs: the entire data set
    :param subs: subs that share the klg
    :param gameTime: game time
    :return:
    """
    # get the accurate klg of wpstatus of these subs
    wpStatus = helper.latestWPStatusByTime(dfs, gameTime)
    klg = subs[['SubName']].merge(wpStatus, on='SubName', how='inner').reset_index(drop=True)
    # update their klg using the accurate info
    klg['gameTime'] = gameTime
    for sub in subs['SubName']:
        klg['Klg_Owner'] = sub
        # only update the wpstatus of others' cases
        dfs['Log_WPStatus'] = dfs['Log_WPStatus'].append(klg[(klg.Klg_Owner != klg.SubName)], ignore_index=True)


def syncActivity_among_subs(dfs, subs, gameTime):
    # get the latest location of these subs
    activities = helper.latestActivityByTime(dfs, gameTime)
    klg = subs[['SubName']].merge(activities, on='SubName', how='inner').reset_index(drop=True)
    # update their klg using the accurate info
    klg['gameTime'] = gameTime
    for sub in subs['SubName']:
        klg['Klg_Owner'] = sub
        # only update the wpstatus of others' cases
        dfs['Log_Activity'] = dfs['Log_Activity'].append(klg[(klg.Klg_Owner != klg.SubName)], ignore_index=True)


# add to the Log_Plan the sub's plan based on his latest klg of WPStatus
# return the latest plan
def plan(dfs, owner, gameTime):
    # plan = helper.klg_by_sub(dfs,owner)[['WPID','SubName','Duration']]
    plan = helper.WPStatusByOwnerByTime(dfs, owner, gameTime)[['WPID', 'SubName', 'Duration']]
    plan['calculated'] = 0
    plan['startTime'] = 0
    plan['endTime'] = 0
    plan['gameTime'] = gameTime
    plan['Klg_Owner'] = owner
    # a data driven method for derive the cpm
    while True:
        # the WP that has been finalized will be removed from others' PreWP
        remainingIDs = plan[(plan.calculated == 0)][['WPID']]
        if (remainingIDs.shape[0]):
            remainingPre = remainingIDs.merge(dfs['Fact_WPDependency'].rename(columns={'WPID_Pre': 'WPID'}), on='WPID',
                                              how='inner').rename(columns={'WPID': 'WPID_Pre', 'WPID_Fol': 'WPID'})

            # the WP that has no predecessors in the remaining sets
            preCalculated = remainingIDs.merge(remainingPre, on='WPID', how='outer')
            preCalculated = preCalculated[preCalculated['WPID_Pre'].isnull()].merge(plan, on='WPID', how='inner')
            preCalculated['calculated'] = 1
            preCalculated['endTime'] = np.add(preCalculated['startTime'], preCalculated['Duration'])
            del preCalculated['WPID_Pre']

            # fete the startTime of the WPs that follows the preCalculated WPs
            myFols = \
                preCalculated.merge(dfs['Fact_WPDependency'].rename(columns={'WPID_Pre': 'WPID'}), on='WPID',
                                    how='left')[
                    ['WPID_Fol', 'endTime']].rename(columns={'WPID_Fol': 'WPID', 'endTime': 'Pre_endTime'}).merge(plan,
                                                                                                                  on='WPID',
                                                                                                                  how='inner')[
                    ['WPID', 'startTime', 'Pre_endTime']]
            # use the predecessor's endTime as my startTime if the former is later than the latter
            myFols['startTime'] = myFols[['startTime', 'Pre_endTime']].max(axis=1)
            del myFols['Pre_endTime']
            # according to the dependency relationship, I may have multiple predecessors, so this derives the latest startTime of mine
            myFols = pd.DataFrame({'startTime': myFols.groupby(['WPID'], sort=False)['startTime'].max()})

            plan.set_index('WPID', inplace=True)
            preCalculated.set_index('WPID', inplace=True)
            # update the plan that these WPs are finalized and endTime = startTime + Duration
            plan.update(preCalculated)
            # update the plan that these WPs' startTime
            plan.update(myFols)
            plan = plan.reset_index()
        else:
            break
    del plan['calculated']
    dfs['Log_Plan'] = dfs['Log_Plan'].append(plan, ignore_index=True)
    return plan


# return 0 means waiting, 1 means working
def deduction(dfs, sub, owner, gameTime):
    # import ipdb; ipdb.set_trace()  # XXX BREAKPOINT
    wpID = ''
    wpID = chooseAPlaceForSubByOwner(dfs, sub, owner, gameTime)
    if wpID == '':
        return 0
    return subWorkByOwner(dfs, sub, owner, wpID, gameTime)


def chooseAPlaceForSubByOwner(dfs, sub, owner, gameTime):
    wpID = ''
    # get the status of jobs that was worked on yesterday
    last = helper.lastTaskStatusOfSubByOwner(dfs, sub, owner, gameTime - 1)
    # if the task hasn't been finished
    if helper.dataframe_row_count(last) > 0 and last['Duration'][0] > 0 and last['startTime'][0] == 0:
        wpID = last['WPID'][0]
    else:
        # choose a work in yesterday's backlog
        wpID = helper.prioritizeBacklogOfSubByOwnerByTime(dfs, sub, owner, gameTime - 1)
        # if there's no wp is ready for work, then wait
    commitActivityByOwner(dfs, wpID, sub, owner, gameTime)
    return wpID


def commitActivityByOwner(dfs, wpID, sub, owner, gameTime):
    if wpID == '':
        return 0
    floor = dfs['Fact_WorkPackage'][(dfs['Fact_WorkPackage'].WPID == wpID)].reset_index(drop=True)['Floor'][0]
    # add this wpID as the current activity
    newActivity = {'WPID': wpID, 'Klg_Owner': owner, 'SubName': sub, 'gameTime': gameTime, 'Floor': floor}
    dfs['Log_Activity'].loc[helper.dataframe_row_count(dfs['Log_Activity'])] = newActivity


def subWorkByOwner(dfs, sub, owner, wpID, gameTime):
    # import ipdb; ipdb.set_trace()  # XXX BREAKPOINT
    # the perception of his own activity is the real action, and only the real action will update the klg using truth
    if owner == sub:
        floor = dfs['Fact_WorkPackage'][(dfs['Fact_WorkPackage'].WPID == wpID)].reset_index(drop=True)['Floor'][0]
        # get the status of the wp yesterday, so ignore the work today in this room, may be performed
        updateWPStatusInFloorByOwner(dfs, floor, owner, gameTime - 1)
        # once the klg of wpstatus changes, correct the plan that was made yesterday by this klg owner
        wp = plan(dfs, owner, gameTime - 1)
        wp = wp[(wp.WPID == wpID) & (wp.startTime == 0) & (wp.Duration > 0)]
        if helper.dataframe_row_count(wp) == 0:
            return 0
        # 0 means extrem cases happen
        if productionRateChange(dfs, wpID, gameTime) == 0:
            # copy the yesterday's wp info
            wps = helper.WPStatusByOwnerByTime(dfs, owner, gameTime - 1)
            wps = wps[(wps.WPID == wpID)]
            wps['gameTime'] = gameTime
            dfs['Log_WPStatus'] = dfs['Log_WPStatus'].append(wps).reset_index(drop=True)
            return 0
    workOnWpByOwner(dfs, owner, wpID, gameTime)
    return 1


def updateWPStatusInFloorByOwner(dfs, floor, owner, gameTime):
    wps = helper.latestWPStatusBySpaceByTime(dfs, floor, gameTime)
    wps['gameTime'] = gameTime
    wps['Klg_Owner'] = owner
    # only update the klg of others' work
    dfs['Log_WPStatus'] = dfs['Log_WPStatus'].append(wps[(wps.SubName != owner)], ignore_index=True)


# if the production rate<=0 means no material, no equipment, or weather is not pleasent
# or other prerequisites are not met
# so return 0 means don't work
def productionRateChange(dfs, wpID, gameTime):
    # only the  himself can change his own productionrate
    # get the production rate yesterday
    wps = helper.latestWPStatusByTime(dfs, gameTime - 1)
    wps = wps[(wps.WPID == wpID)].reset_index(drop=True)
    mu = wps['ProductionRate'][0]
    std = dfs['Fact_Project']['productionRateChangeStd'][0]
    rate = helper.randomChange(mu, std)
    if rate > 0:
        # change the production rate today
        wps['ProductionRate'] = rate
        wps['gameTime'] = gameTime
        dfs['Log_WPStatus'] = dfs['Log_WPStatus'].append(wps).reset_index(drop=True)
        return 1
    else:
        return 0


# in the owner's perception: a sub work on a given wp
def workOnWpByOwner(dfs, owner, wpID, gameTime):
    # using the latest production rate instead of yesterday's,  cause the rate may be changed today
    wps = helper.WPStatusByOwnerByTime(dfs, owner, gameTime)
    wps = wps[(wps.WPID == wpID)]
    wps['RemainingQty'] = np.maximum((wps['RemainingQty'] - wps['ProductionRate']), 0)
    wps['Duration'] = wps['RemainingQty'] / wps['ProductionRate']
    wps['gameTime'] = gameTime
    dfs['Log_WPStatus'] = dfs['Log_WPStatus'].append(wps).reset_index(drop=True)


# sync the activities among subs if they collide
def collision_check(dfs, gameTime):
    # first get the latest accurate position of each sub (if he has been to any space, and left records in activity log)
    subs_position = helper.latestActivityByTime(dfs, gameTime)
    # find the floors that have more than 1 sub in them
    count = subs_position[['SubName', 'Floor']].groupby(['Floor']).count().reset_index()
    collision_floors = count[(count.SubName > 1)][['Floor']].reset_index(drop=True)
    # find all the subs in each collision floor
    for floor in collision_floors['Floor']:
        subs = subs_position[(subs_position.Floor == floor)].reset_index(drop=True)
        syncWPStatus_among_subs(dfs, subs, gameTime)
        syncActivity_among_subs(dfs, subs, gameTime)


def designChange(dfs, gameTime):
    wps = helper.remainingWPStatusByTime(dfs, gameTime)
    count = helper.dataframe_row_count(wps)
    radInt = 0
    if count < 1:
        return 0
    elif count > 1:
        try:
            r = RandomOrgClient(helper.rand_key())
            radInt = r.generate_integers(1, 0, count - 1)[0]
        except:
            radInt = np.random.randint(count, size=1)[0]
    wpID = wps['WPID'][radInt]
    wp = wps[(wps.WPID == wpID)].reset_index(drop=True)
    wp['gameTime'] = gameTime
    mu = wp['Qty'][0]
    std = dfs['Fact_Project']['DesignChangeVariation'][0]
    v = helper.randomChange(mu, std)
    if v > 0:
        wp['Qty'] = v
        wp['RemainingQty'] = wp['Qty']
        wp['Duration'] = wp['RemainingQty'] / wp['ProductionRate']
        dfs['Log_WPStatus'] = dfs['Log_WPStatus'].append(wp).reset_index(drop=True)
        newDesign = {'WPID': wpID, 'gameTime': gameTime}
        dfs['Log_DesignChange'].loc[helper.dataframe_row_count(dfs['Log_DesignChange'])] = newDesign


# return 1 if the quality check passed
# return 0 if fail
def qualityCheck(dfs, gameTime):
    rate = dfs['Fact_Project']['QualityCheckPassRate'][0]
    if rate == 0 or rate >= 1:
        return 1
    # only use the un-passed but finished wps
    wps = helper.unPassedWPByTime(dfs, gameTime)
    wps = wps[(wps.Duration == 0)].reset_index(drop=True)
    count = helper.dataframe_row_count(wps)
    radInt = 0
    if count < 1:
        return 0
    elif count > 1:
        try:
            r = RandomOrgClient(helper.rand_key())
            radInt = r.generate_integers(1, 0, count - 1)[0]
        except:
            radInt = np.random.randint(count, size=1)[0]
    wpID = wps['WPID'][radInt]
    check = np.random.binomial(1, rate, 1)[0]
    if check == 1:
        result = {'WPID': wpID, 'passed': 1, 'gameTime': gameTime}
        dfs['Log_QualityCheck'].loc[helper.dataframe_row_count(dfs['Log_QualityCheck'])] = result
        return 1
    else:
        result = {'WPID': wpID, 'passed': 0, 'gameTime': gameTime}
        dfs['Log_QualityCheck'].loc[helper.dataframe_row_count(dfs['Log_QualityCheck'])] = result
        wp = wps[(wps.WPID == wpID)].reset_index(drop=True)
        wp['gameTime'] = gameTime
        wp['RemainingQty'] = wp['Qty']
        wp['Duration'] = wp['RemainingQty'] / wp['ProductionRate']
        dfs['Log_WPStatus'] = dfs['Log_WPStatus'].append(wp).reset_index(drop=True)
        return 0


# sync the true activities among the subs
def syncActivity(dfs, gameTime):
    subs = dfs['Fact_Sub']
    syncActivity_among_subs(dfs, subs, gameTime)


# use the true wp status to update every subs knowledge of WPStatus
# sync all the subs knowledge
def syncWPStatus(dfs, gameTime):
    subs = dfs['Fact_Sub']
    syncWPStatus_among_subs(dfs, subs, gameTime)
