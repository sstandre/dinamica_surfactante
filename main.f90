program main
  use globals
  use ziggurat
#include "control.h"
  implicit none
  integer :: istep
#ifdef GDR
  integer :: i,j,k
  real(8) :: d, dvec(3)
#endif
  
  ! Inicializo posiciones y velocidades y calculo el potencial y las fuerzas
  call init()
  call force(1)

  ! print *, "posiciones"
  ! do i=1, N
  !   print *, r(:,i)
  ! end do

  ! inicializar los bines con las distancias de cada cascara

  if (vb) then
    print *, '**************************************************************************'
    ! Calculo inicial de energia
    Ecin = sum(v*v)/(2*m*N)
    Vtot = Vtot / N
    print *, "energia"
    print *, "  potencial                 cinetica                  total"
    print *, Vtot, Ecin, Vtot+Ecin
    print *, '--------------------------------------------------------------------------'
  end if

  open(unit=15,file='output.dat',status='unknown')
  write(15, *) "Paso    Potencial   Cinetica    Total     Presion"
  do istep = 1, nstep
    ! Las nuevas posiciones y velocidades se calculan mediante Verlet
    call verlet()

    if(mod(istep,nwrite)==0) then
      Ecin = sum(v*v)/(2*m*N)
      Vtot = Vtot / N
      if (vb) print *, Vtot, Ecin, Vtot+Ecin
      write(15, *) istep, Vtot, Ecin, Vtot+Ecin, presion
      call write_conf(1)


#ifdef GDR
do i = 1, N-1
  do j = i+1, N
      dvec(:) = r(:,i) - r(:,j)
      ! Por condiciones de contorno, la distancia siempre debe ser -L/2<d<L/2
      dvec = dvec - L*int(2*dvec/L)
      d = sqrt(sum(dvec*dvec))
      ! Contar la distancia en el primer bin que sea mayor a la distancia
      do k = 1, n_bins
        if (d < bines(k)) then
          cuentas(k) = cuentas(k) + 2
          exit
        end if
      end do
    end do
  end do
#endif

    end if
  end do
  if (vb) print *, '**************************************************************************'
  close(15)

  ! print *, "posiciones"
  ! do i=1, N
  !   print *, r(:,i)
  ! end do

  ! Rutina de finalizacion para cerrar archivos, etc
   call final()

end program main
