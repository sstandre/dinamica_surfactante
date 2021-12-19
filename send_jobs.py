#!/usr/bin/env python3

import sys
import os
from subprocess import call
from shutil import copy
from pathlib import Path

constants = {
    'dt'      : '0.001',
    'eps_11'  : '1.0',
    'eps_22'  : '1.0',
    'eps_12'  : '0.5',
    'sig_11'   : '1.0',
    'sig_22'   : '1.0',
    'sig_12'   : '1.0',
    'mass1'    : '1.0',
    'mass2'    : '1.0',
    'gamma'   : '0.5',
    'nwrite'  : '500',
    'verbose' : 'false',
    }

L           = 10.
Z           = 10.
N_fluid     = 300
steps       = 500_000
steps_term  = 100_000

surfactantes = [10, 30, 50, 100]
temperaturas = [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
# densidades = [0.9]
# temperaturas = [0.7 + 0.7/9*i for i in range(10)]

# densidades = [
#     0.001, 0.01, 0.1,
#     *[0.1 + 0.7/11*i for i in range(1, 11)],
#     0.8, 0.9, 1.0
#     ]
# temperaturas = [0.9, 2.0]

data_files = [
    'input.dat', 'output.dat', 'configuracion.dat', 'movie.vtf', 'perfil.dat'
    ]
data_folder = Path('./data')
EXE = './surfactante'
SKIP_EXISTING = True
openmp_threads = 4



def run_job(n_surf, steps, temp, N, L, Z, constants):
    
    data = f'{N:<10}N_fluid (fluid molecules)\n'                        + \
           f'{n_surf:<10}N_surf (surfactant molecules, each 2 atoms)\n' + \
           f'{L:<10}L (box size in x,y)\n'                              + \
           f'{Z:<10}L (box size in z)\n'                                + \
           f'{temp:<10.2f}Temperature\n'                                + \
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
        
        os.environ["OMP_NUM_THREADS"] = str(openmp_threads)

        for nsur  in surfactantes:
            if os.path.exists('configuracion.dat'):
                    print('Quitando configuracion.dat para nueva cantidad de surfactante.')
                    os.remove('configuracion.dat')
            
            for temp in temperaturas:
                eps = constants['eps_12']
                tempdir = data_folder / f'{eps}_eps' /f'{nsur:03}_surf' / f'{temp:.2f}_temp'
                print('*'*40)
                print(f'Corrida con surfactante={nsur:03}, T={temp:.2f}')

                # corrida de termalizacion
                print("Termalizacion")
                run_job(nsur, steps_term, temp, N_fluid, L, Z, constants)
                    
                for job in range(1,njobs+1):                   
                    dirname = tempdir / f'{job:02}_JOB'
                    if os.path.exists(dirname) and SKIP_EXISTING:
                        print(f'El directorio {dirname} ya existe, continuando con el siguiente.')
                        continue
                    elif not os.path.exists(dirname):
                        os.makedirs(dirname)
                    
                    print(f'Inciando trabajo {job}')
                    # corrida de produccion
                    run_job(nsur, steps, temp, N_fluid, L, Z, constants)
                    
                    for file in data_files:
                        copy(file, dirname)
                    
                print('-'*40)

        print(f'Todos los trabajos finalizados')

        return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
