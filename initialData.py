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

import gspread
import json
from oauth2client.client import SignedJwtAssertionCredentials
import uuid
import pandas as pd
import numpy as np
import helper


def load_db():
    """
    set access to a specific spreadsheet on google

    :type key: bool
    :param key: choose whether to use key or name of the spreadsheet for retrieve data
    :return: a database/google spreadsheet
    """
    json_key = json.load(open('OAuth2Credentials.json'))
    sheet_id = json_key['sheet_id']
    scope = ['https://spreadsheets.google.com/feeds']
    credentials = SignedJwtAssertionCredentials(json_key['client_email'], json_key['private_key'], scope)
    # Login with your Google account
    gc = gspread.authorize(credentials)
    return gc.open_by_key(sheet_id)


def load_all_data(db):
    """
    load all the data except result in a sheet, keys are the name of all the sheets

    :param db: the spreadsheet
    :return:
    """
    sheets = db.worksheets()
    data = {}
    for sh in sheets:
        if sh.title == 'Result':
            continue
        data[sh.title] = sh.get_all_records()
    return data


# initial wps
# initial design log
# initial the status of WPs, results are the subs' perception of each WP's status
# this is necessary to be invoked in every round of game, because it makes sure the same WP in different round has different ID
def initialWorkpackage(dfs):
    # initialize workpackage
    dfs['Fact_WorkPackage'] = dfs['Initial_Design'][['Floor', 'Workprocedure']]
    wpIDs = []
    for i in xrange(helper.dataframe_row_count(dfs['Fact_WorkPackage'])):
        wpIDs.append(uuid.uuid4().hex)
    dfs['Fact_WorkPackage']['WPID'] = wpIDs

    # initialize log of design
    dfs['Log_Design'] = dfs['Fact_WorkPackage'].merge(dfs['Initial_Design'], on=['Floor', 'Workprocedure'], how='left')
    dfs['Log_Design']['gameTime'] = 0

    # initialize WPStatus
    # add sub info
    dfs['Log_WPStatus'] = dfs['Log_Design'].merge(dfs['Fact_WorkProcedure'], on='Workprocedure', how='left')
    # in the begining everyone know their own wpstatus
    dfs['Log_WPStatus']['Klg_Owner'] = dfs['Log_WPStatus']['SubName']
    # add remainingQty
    dfs['Log_WPStatus']['RemainingQty'] = dfs['Log_WPStatus']['Qty']
    dfs['Log_WPStatus'] = dfs['Log_WPStatus'].merge(dfs['Initial_ProductionRate'], on='SubName', how='left')
    dfs['Log_WPStatus']['Duration'] = np.divide(dfs['Log_WPStatus']['RemainingQty'],
                                                dfs['Log_WPStatus']['ProductionRate'])


# derive the workpackage dependencies using SQL-like join operation
# this is necessary to be invoked in every round of game, because the WP is regenerated in every round and has different WPID
def initialWPDependency(dfs):
    count = helper.dataframe_row_count(dfs['Fact_WProDependency'])
    if count == 0:
        # sometime there could be no dependency
        dfs['Fact_WPDependency'] = pd.DataFrame(np.zeros(0, dtype=[
            ('WPID_Pre', 'object'),
            ('WPID_Fol', 'object')]))
    else:
        pres = dfs['Fact_WProDependency'][['WProPre', 'WProFol']].rename(columns={'WProPre': 'Workprocedure'}).merge(
            dfs['Fact_WorkPackage'][['Workprocedure', 'WPID', 'Floor']], on='Workprocedure', how='left').rename(
            columns={'Workprocedure': 'WProPre', 'WPID': 'WPID_Pre'})
        fols = dfs['Fact_WProDependency'][['WProPre', 'WProFol']].rename(columns={'WProFol': 'Workprocedure'}).merge(
            dfs['Fact_WorkPackage'][['Workprocedure', 'WPID', 'Floor']], on='Workprocedure', how='left').rename(
            columns={'Workprocedure': 'WProFol', 'WPID': 'WPID_Fol'})
        dfs['Fact_WPDependency'] = pres.merge(fols, on=['WProFol', 'WProPre', 'Floor'], how='inner')
        del dfs['Fact_WPDependency']['WProPre']
        del dfs['Fact_WPDependency']['WProFol']
        del dfs['Fact_WPDependency']['Floor']


def initialSpacePriority(dfs):
    dfs['Log_WorkspacePriority'] = dfs['Initial_WorkspacePriority'][['Floor', 'Priority']]
    dfs['Log_WorkspacePriority']['gameTime'] = 0


def initialPlan(dfs):
    dfs['Log_Plan'] = pd.DataFrame(np.zeros(0, dtype=[
        ('WPID', 'object'),
        ('SubName', 'object'),
        ('Duration', 'float64'),
        ('startTime', 'float64'),
        ('endTime', 'float64'),
        ('gameTime', 'float64'),
        ('Klg_Owner', 'object')]))


def initialActivity(dfs):
    dfs['Log_Activity'] = pd.DataFrame(np.zeros(0, dtype=[
        ('WPID', 'object'),
        ('Floor', 'float64'),
        ('Klg_Owner', 'object'),
        ('SubName', 'object'),
        ('gameTime', 'float64')]))


def initialQualityCheck(dfs):
    """
    only if the WP pass the quality check will be add to this record

    :param dfs:
    :return:
    """
    dfs['Log_QualityCheck'] = pd.DataFrame(np.zeros(0, dtype=[
        ('WPID', 'object'),
        ('passed', 'float64'),
        ('gameTime', 'float64')]))


def initialDesignChange(dfs):
    dfs['Log_DesignChange'] = pd.DataFrame(np.zeros(0, dtype=[
        ('WPID', 'object'),
        ('gameTime', 'float64')]))


def initialMeetingLog(dfs):
    dfs['Log_Meeting'] = pd.DataFrame(np.zeros(0, dtype=[
        ('gameTime', 'float64')]))
