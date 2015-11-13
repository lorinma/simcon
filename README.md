# simcon - simulation of construction workflow
This is an open source (LGPL) academic project for agent-based construction workflow simulation.
It is written in python 2.7, all the simulation setup data are pulled from an excel file.
The simulation process is recorded in sqlite database, and result of the interesting part is exported in a csv file.

## Dependencies:

### First:
conda install pandas sqlalchemy requests

### Then:
pip install xlrd
pip install -U https://github.com/RandomOrg/JSON-RPC-Python/zipball/master

## Run the simulation
python simcon.py
