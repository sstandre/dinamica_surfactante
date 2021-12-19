#!/usr/bin/env python3

import os
from math import prod

def traverse_folders(data, names, level=0):
    if level >= len(names):
        write_aggregate(data)
        return
    else:
        name = names[level]
    for dirname in os.listdir():
        if os.path.isdir(dirname) and dirname.endswith(f'_{name}'):
            data_new = data + [dirname.split('_')[0]]
            
            os.chdir(dirname)
            traverse_folders(data_new, names, level+1)
            os.chdir('..')




def write_aggregate(data):
    with open('perfil.dat', 'r') as file:
        next(file) # skip headers
        # y1, y2 = zip(*(map(float, line.split()[1:]) for line in file.readlines()))
        integrated = sum(
            (lambda x,y:abs(float(x)-float(y)))(*line.split()[1:])
            for line in file.readlines()
            )

    aggregated = [str(integrated)]       

    data = '\t'.join(data+aggregated)+'\n'
    datafile.write(data)


HEADER = '\t'.join((
    'eps_12',
    'n_surf',
    'temp',
    'job',
    'superposicion',
    ))+'\n'

OUTFILE = 'alldata.dat'
DATAFOLDER = 'data'
NAMES = ['eps', 'surf', 'temp', 'JOB']

with open(OUTFILE, 'w') as datafile:
    datafile.write(HEADER)
    data = []
    os.chdir(DATAFOLDER)
    traverse_folders(data, NAMES)
    os.chdir('..')