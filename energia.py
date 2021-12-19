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


# folder = '.'
folder = './data/0.5_eps/050_surf/0.70_temp/01_JOB/'


with open(folder + 'input.dat') as f:
    for key, line in zip(keys, f.readlines()):
        g[key] = float(line.split()[0])

N = n_flu + 2* n_sur

steps, Epot, Ecin, Etot = np.loadtxt(folder+'output.dat', skiprows=1, unpack=True)

print(f'Energía potencial media: {Epot.mean():.2f} ± {Epot.std():.2f}')
print(f'Energía cinética media: {Ecin.mean():.2f} ± {Ecin.std():.2f}')
print(f'Energía total media: {Etot.mean():.2f} ± {Etot.std():.2f}')

print(f'Densidad: {N/(L**2*Z):.3f}')
print(f'Temperatura input: {T}')
Treal = Ecin.mean()*2/3
print(f'Temperatura real: {Treal:.2f}')
# print(f'Presión media: {presion.mean():.4f} ± {presion.std():.4f}')



# plt.plot(steps*dt, Epot, label="Energia potencial")
# plt.plot(steps*dt, Ecin, label="Energia cinetica")
# plt.plot(steps*dt, Etot, label="Energia total")
# plt.xlabel('Tiempo')
# plt.legend(loc=(0.1, 0.3))

z_bins, esp1, esp2 = np.loadtxt(folder+'perfil.dat', skiprows=1, unpack=True)

plt.figure()
plt.plot(z_bins, esp1, label="fluido")
plt.plot(z_bins, esp2, label="surfactante")
plt.xlabel('posicion Z')
plt.ylabel('densidad')
plt.legend(loc=(0.1, 0.3))

print(f"Total fluido: {sum(esp1):.3f}")
print(f"Total surfactante: {sum(esp2):.3f}")

# plt.figure()
# plt.plot(steps*dt, presion)
# plt.xlabel('Tiempo')
# plt.ylabel('Presión')
# plt.ylim(0, presion.max()*1.1)
plt.show()