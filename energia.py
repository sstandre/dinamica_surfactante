#!/usr/bin/env python3.9

import numpy as np
import matplotlib.pyplot as plt

keys = [
    'n_flu',
    'n_sur',
    'L',
    'Z',
    'T',
    'nstep',
    'dt',
    'e11',
    'e22',
    'e12',
    's11',
    's12',
    's22',
    'm1',
    'm2',
    'gamma',
    'nwrite',
    ]
g = globals()

with open('input.dat') as f:
    for key, line in zip(keys, f.readlines()):
        g[key] = float(line.split()[0])

N = n_flu + 2* n_sur
folder = '.'
# folder = './data/0.418_dens/1.1_temp/01_JOB'

steps, Epot, Ecin, Etot, presion= np.loadtxt(folder+'/output.dat', skiprows=1, unpack=True)

print(f'Energía potencial media: {Epot.mean():.2f} ± {Epot.std():.2f}')
print(f'Energía cinética media: {Ecin.mean():.2f} ± {Ecin.std():.2f}')
print(f'Energía total media: {Etot.mean():.2f} ± {Etot.std():.2f}')

print(f'Densidad: {N/(L**2*Z):.3f}')
print(f'Temperatura input: {T}')
Treal = Ecin.mean()*2/3
print(f'Temperatura real: {Treal:.2f}')
print(f'Presión media: {presion.mean():.4f} ± {presion.std():.4f}')



plt.plot(steps*dt, Epot, label="Energia potencial")
plt.plot(steps*dt, Ecin, label="Energia cinetica")
plt.plot(steps*dt, Etot, label="Energia total")
plt.xlabel('Tiempo')
plt.legend(loc=(0.1, 0.3))

plt.figure()
plt.plot(steps*dt, presion)
plt.xlabel('Tiempo')
plt.ylabel('Presión')
# plt.ylim(0, presion.max()*1.1)
plt.show()