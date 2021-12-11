subroutine init()
  use globals
  use ziggurat
#include "control.h"
  implicit none
  logical :: es, ms
  integer :: i, j
  character(len=80) :: text
  real(8) :: dtm, sv, tmp
#ifdef GDR
  integer :: k
#endif

!   Leer variables del archivo input.dat y alocar variables
  open(unit=11,file='input.dat',action='read',status='old')
  read(11,*) N, text
  read(11,*) L, text
  read(11,*) T, text
  read(11,*) nstep, text
  read(11,*) dt, text
  read(11,*) eps, text
  read(11,*) sigma, text
  read(11,*) m, text
  read(11,*) gamma, text
  read(11,*) nwrite, text
  read(11,*) vb, text
  close(11)

  T = T * eps
  allocate(r(3,N),v(3,N),f(3,N))

![NO TOCAR] Inicializa generador de número random
  inquire(file='seed.dat',exist=es)
  if(es) then
      open(unit=10,file='seed.dat',status='old')
      read(10,*) seed
      close(10)
      ! print *,"  * Leyendo semilla de archivo seed.dat"
  else
      seed = 24583490
  end if

  call zigset(seed)
![FIN NO TOCAR]   

  ! Abro archivos e incializo variables en write_conf y force
  call write_conf(0)
  call force(0)

! Chequear si existe configuracion.dat, y cargarla como configuracion inicial
  inquire(file='configuracion.dat',exist=ms)
  if(ms) then
    if (vb) print *,"  * Leyendo configuracion inicial de configuracion.dat"
    open(unit=12,file='configuracion.dat',status='old')
    do j=1,N
      read(12,*) ( r(i,j), i=1,3 ) , ( v(i,j), i=1,3 )
    end do
    close(12)

  else
  ! Si no hay configuracion inicial, inicializar con posiciones y velocidades aleatorias
    sv = sqrt(T/m)
    if (vb) print *,"  * Inicializando configuracion aleatoria"
    do i = 1, 3
      do j = 1, N
        r(i,j) = uni()*L
        v(i,j) = rnor()*sv
      end do
    end do

    if (vb) print *, "Energia potencial:"
  ! Hacemos unos pasos de minimizacion de energia, para evitar tener particulas muy cerca
    dtm = 0.001
    tmp = dtm**2/(2*m)
    do i=1,500

      call force(1)
      if (vb.and.(mod(i,100)==0)) print *, Vtot

      r = r + f * tmp
      r = modulo(r, L)

    end do

  end if

#ifdef GDR
  n_bins = int(L*30)
  allocate(cuentas(1:n_bins), bines(0:n_bins))
  cuentas = 0.0
  bines(0) = 0.0
  do k = 1, n_bins
    bines(k) = k*dble(L)/dble(n_bins)
  end do
#endif

 end subroutine

