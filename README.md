# simcon - simulation of construction workflow
This is an open source (LGPL) academic project for agent-based workflow simulation of construction process.
It is written in python 2.7, all the simulation setup data are pulled from google spreadsheet, and the program will try to upload the simulation result to the same spreadsheet. 

But anyway, each round of the simulation will generate a csv file for local backup of the result

## Dependencies:

### First:
conda install pandas sqlalchemy requests

### Then:
pip install -U https://github.com/RandomOrg/JSON-RPC-Python/zipball/master

## Run the simulation
python simcon.py
