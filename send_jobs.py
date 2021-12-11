#!/usr/bin/env python3

import sys
import os
from subprocess import call
from shutil import copy
from pathlib import Path

constants = {
    'dt'      : '0.001',
    'epsilon' : '1.0',
    'sigma'   : '1.0',
    'mass'    : '1.0',
    'gamma'   : '0.5',
    'nwrite'  : '500',
    'verbose' : 'false',
    }

N           = 200
steps       = 500_000
steps_term  = 100_000

densidades = [0.3]
temperaturas = [0.7, 0.93]
# densidades = [0.9]
# temperaturas = [0.7 + 0.7/9*i for i in range(10)]

# densidades = [
#     0.001, 0.01, 0.1,
#     *[0.1 + 0.7/11*i for i in range(1, 11)],
#     0.8, 0.9, 1.0
#     ]
# temperaturas = [0.9, 2.0]

data_files = [
    'input.dat', 'output.dat', 'configuracion.dat', 'movie.vtf', 'correlacion.dat'
    ]
data_folder = Path('./data')
EXE = './dinamica_gdr'
SKIP_EXISTING = True


def run_job(densidad, steps, temp, N, constants):
    
    L = f'{(N/densidad)**(1/3):.3f}'
    data = f'{N:<10}N (atoms)\n'         + \
           f'{L:<10}L (box size)\n'      + \
           f'{temp:<10.2f}Temperature\n' + \
           f'{steps:<10}nstep\n'

    with open('input.dat','w') as infile:
        infile.write(data)
        for name, value in constants.items():
            infile.write(f'{value:<10}{name}\n')

    call(EXE)


def main(args):
    
    if len(args) != 2:
        print(f'Modo de uso: {Path(__file__).name} N_JOBS')
        return 1
    else:
        try:
            njobs = int(args[1])
        except ValueError:
            print('El argumento debe ser un numero entero')
            return 1
        
        for d in densidades:
            if os.path.exists('configuracion.dat'):
                    print('Quitando configuracion.dat para nueva densidad.')
                    os.remove('configuracion.dat')
            
            for temp in temperaturas:
                tempdir = data_folder / f'{d:.3f}_dens' / f'{temp:.2f}_temp'
                print('*'*40)
                print(f'Corrida a densidad={d:.3f}, T={temp:.2f}')

                # corrida de termalizacion
                print("Termalizacion")
                run_job(d, steps_term, temp, N, constants)
                    
                for job in range(1,njobs+1):                   
                    dirname = tempdir / f'{job:02}_JOB'
                    if os.path.exists(dirname) and SKIP_EXISTING:
                        print(f'El directorio {dirname} ya existe, continuando con el siguiente.')
                        continue
                    elif not os.path.exists(dirname):
                        os.makedirs(dirname)
                    
                    print(f'Inciando trabajo {job}')
                    # corrida de produccion
                    run_job(d, steps, temp, N, constants)
                    
                    for file in data_files:
                        copy(file, dirname)
                    
                print('-'*40)

        print(f'Todos los trabajos finalizados')

        return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
