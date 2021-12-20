#!/usr/bin/env python3

import os
import numpy as np
import itertools

def traverse_folders(data, names, level=0):
    if level >= len(names):
        if not os.path.isfile('rdf.dat'):
            print("working in", os.getcwd())
            calc_rdf(data)
        return
    else:
        name = names[level]
    for dirname in os.listdir():
        if os.path.isdir(dirname) and dirname.endswith(f'_{name}'):
            data_new = data + [dirname.split('_')[0]]
            
            os.chdir(dirname)
            traverse_folders(data_new, names, level+1)
            os.chdir('..')


def calc_rdf(data):
    nstep = 1000
    n_2 = int(data[1])
    n_1 = 300 + n_2
    N = n_1 + n_2

    gdr_bins = 200
    deltag = 4./gdr_bins
    hist = np.zeros((4,gdr_bins))
    L= 10.0
    Z = 10.0

    with open('movie.vtf', 'rt') as f_in:
        for _ in range(3): #skip header
            next(f_in)
        for step in range(nstep):
            # print(step)
            start = 2
            try:
                r = np.genfromtxt(itertools.islice(f_in, start, start+N), dtype=float)
            except ValueError:
                print(start)
                raise
            
            r_x = r[:, None]
            dv = r - r_x
            dv[:,:,:2] -=  L*np.floor(2*dv[:,:,:2]/L)

            d = np.sqrt(np.sum(dv*dv, axis=2))
            chunk1, chunk2 = np.split(d, [n_1], axis=0)
            d11, d12 = np.split(chunk1, [n_1], axis=1)
            d21, d22 = np.split(chunk2, [n_1], axis=1)
            
            for i, arr in enumerate([d11, d12, d21, d22]):
                h, edges = np.histogram(arr, bins=gdr_bins, range=(0.,4.))
                hist[i,:] += h
            
    hist[:, 0] = 0.
    const = 1.0/3.0*3.141592*deltag**3/(L**2*Z)
    dens_casc = const * np.array( [(k+1)**3 - k**3 for k in range(gdr_bins)] )
    n_norm = np.array([a*b for a in (n_1, n_2) for b in (n_1, n_2)])*nstep
    normal = np.outer(dens_casc, n_norm)

    np.savetxt('rdf.dat', np.c_[edges[:-1], hist.T/normal])

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

# with open(OUTFILE, 'w') as datafile:
    # datafile.write(HEADER)
data = []
os.chdir(DATAFOLDER)
traverse_folders(data, NAMES)
os.chdir('..')