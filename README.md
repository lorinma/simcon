# simcon - simulation of construction workflow
This is an open source (LGPL) academic project for agent-based workflow simulation of construction process.
It is written in python 2.7, all the simulation setup data are pulled from google spreadsheet, and the program will try to upload the simulation result to the same spreadsheet. 

But anyway, each round of the simulation will generate a csv file for local backup of the result

## Dependencies:

### First:
on Mac: conda install pyopenssl

on Ubuntu: apt-get install -y --force-yes --no-install-recommends python-openssl libssl-dev libffi-dev

### Then:
pip install gspread numpy pandas oauth2client cryptography requests

pip install -U https://github.com/RandomOrg/JSON-RPC-Python/zipball/master       

pip install -U https://github.com/google/google-visualization-python/zipball/master

## or use my docker images

docker run -it lorinma/simcon bash

## Spreadsheet and other setup
### Spreadsheet:
It requires a credential files to use data on google spreadsheet

(see http://gspread.readthedocs.org/en/latest/oauth2.html?highlight=oauth) 

Notice: The file should be named as OAuth2Credentials.json and placed in the root of this project

Besides the instruction above, also need to add a line to OAuth2Credentials.json about the Key of the target spreadsheet like: "sheet_id": "xxxxxx",

Notice: make sure the sheet you provide is shared with email address with write right
### Random number generator:
This project uses https://www.random.org/ to generate true random numbers

You need to add a line to OAuth2Credentials.json about your Key of RandomOrgClient like "random_org_key": "xxxx",

(see https://www.random.org/clients/http/) 

if the number of api usage is used out, the program will use general random number generator

## Run the simulation

python game.py
