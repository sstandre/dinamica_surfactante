subroutine init()
  use globals
  use ziggurat
#include "control.h"
  implicit none
  logical :: es, ms
  integer :: i, j, n_flu, n_surf
  character(len=80) :: text
  real(8) :: dtm, sv1, sv2, tmp, r0, lim_inf(3), lim_sup(3), li, ls
#ifdef GDR
  integer :: k
#endif

!   Leer variables del archivo input.dat, asignar y alocar variables
  open(unit=11,file='input.dat',action='read',status='old')
  read(11,*) n_flu, text
  read(11,*) n_surf, text
  read(11,*) L, text
  read(11,*) Z, text
  read(11,*) zskin, text
  read(11,*) T, text
  read(11,*) nstep, text
  read(11,*) dt, text
  read(11,*) eps(1,1), text
  read(11,*) eps(2,2), text
  read(11,*) eps(1,2), text
  read(11,*) sigma(1,1), text
  read(11,*) sigma(2,2), text
  read(11,*) sigma(1,2), text
  read(11,*) m(1), text
  read(11,*) m(2), text
  read(11,*) gamma, text
  read(11,*) nwrite, text
  read(11,*) vb, text
  close(11)

  eps(2,1) = eps(1,2)
  sigma(2,1) = sigma(1,2)

  !Las propiedades de la pared estan hardcodeadas
  eps_wall(1) = 1.
  eps_wall(2) = 1.
  sigma_wall = 1.
  
  ! Particulas de tipo 1
  n_1 = n_flu + n_surf
  ! Particulas de tipo 2
  n_2 = n_surf
  ! Numero total de particulas y alocar vectores
  N = n_1 + n_2
  allocate(r(3,N),v(3,N),f(3,N), atype(N))
  !Asignar cada tipo de particula
  atype(1:n_1) = 1
  atype(n_1+1:N) = 2


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
  inquire(file='configuracionfff.dat',exist=ms)
  if(ms) then
    if (vb) print *,"  * Leyendo configuracion inicial de configuracion.dat"
    open(unit=12,file='configuracion.dat',status='old')
    do j=1,N
      read(12,*) ( r(i,j), i=1,3 ) , ( v(i,j), i=1,3 )
    end do
    close(12)

  else
  ! Si no hay configuracion inicial, inicializar con posiciones y velocidades aleatorias
    sv1 = sqrt(T/m(1))
    sv2 = sqrt(T/m(2))

    if (vb) print *,"  * Inicializando configuracion aleatoria"
    ! Primero sorteo los dimeros: particulas de tipo 1 con un offset a las de tipo 2
    lim_inf = (/real(8) :: 0., 0., zskin/)
    lim_sup = (/real(8) :: L, L, Z-zskin/)
    do i = 1, 3
      li= lim_inf(i)
      ls= lim_sup(i)
      do j = 1, n_2
        r0 = li + uni()*(ls-li)
        r(i,j) = r0
        v(i,j) = rnor()*sv1
        ! las colas del surfactante estan al final de la lista
        r(i,j+n_1) = r0+uni()
        v(i,j) = rnor()*sv2
      end do
    end do
    ! Depsues sorteo las particulas del fluido, de tipo 1
    do i = 1, 3
      do j = n_2+1, n_1
        r(i,j) = uni()*L
        v(i,j) = rnor()*sv1
      end do
    end do

    if (vb) print *, "Energia potencial:"
  ! Hacemos unos pasos de minimizacion de energia, para evitar tener particulas muy cerca
    dtm = 0.00001
    tmp = dtm**2/(2*m(1))
    do i=1,2000

      call force(1)
      if (vb.and.(mod(i,200)==0)) print *, Vtot

      r = r + f * tmp
      r = modulo(r, L)

    end do

    tmp = 1000*tmp
    do i=1,5000

      call force(1)
      if (vb.and.(mod(i,500)==0)) print *, Vtot

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

