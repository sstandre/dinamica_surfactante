#!/usr/bin/env python3.9

import numpy as np
import matplotlib.pyplot as plt
from itertools import cycle

colors = cycle('rmbcyg')
folder = '.'
temps = ['0.50', '0.90']
lines = cycle(['-', '--', '-.', ':'])

for T, line in zip(temps, lines):
    folder = f'data/0.5_eps/100_surf/{T}_temp/04_JOB'
    r, g11, g12, g21, g22 = np.loadtxt(folder+'/rdf.dat', skiprows=1, unpack=True)

    # plt.plot(r, g11, label='g11', color='r')
    plt.plot(r, g12, label=f'g12, T={T}', color='g', ls=line)
    # plt.plot(r, g21, label='g21', color='b')
    plt.plot(r, g22, label=f'g22, T={T}', color='b', ls=line)

plt.legend()
plt.title(f'eps=0.5, N_surf=100')



plt.figure()
epsilons = ['0.5', '0.6','0.7', '0.8']
lines = cycle(['-', '--', '-.', ':'])

for eps, line in zip(epsilons, lines):
    folder = f'data/{eps}_eps/050_surf/0.50_temp/04_JOB'
    r, g11, g12, g21, g22 = np.loadtxt(folder+'/rdf.dat', skiprows=1, unpack=True)

    # plt.plot(r, g11, label='g11', color='r')
    plt.plot(r, g12, label=f'g12, eps={eps}', color='g', ls=line)
    # plt.plot(r, g21, label='g21', color='b')
    plt.plot(r, g22, label=f'g22, eps={eps}', color='b', ls=line)

plt.legend()
plt.title(f'T=0.5, N_surf=50')




plt.show()
# folder = 'data/0.5_eps/100_surf/0.90_temp/04_JOB'

# r, g11, g12, g21, g22 = np.loadtxt(folder+'/rdf.dat', skiprows=1, unpack=True)

# # plt.plot(r, g11, ls='--', color='r')
# plt.plot(r, g12, ls='--', color='g')
# # plt.plot(r, g21, ls='--', color='b')
# plt.plot(r, g22, ls='--', color='b')



