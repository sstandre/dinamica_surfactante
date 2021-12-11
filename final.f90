subroutine final()
    use globals
    use ziggurat
#include "control.h"
    implicit none

    integer :: i, j
#ifdef GDR    
    integer :: k
    real(8) :: dens_casc
#endif
    ! Cerrar el archivo de configuraciones
    call write_conf(2)

    ! ! Guardar la ultima configuracion en un archivo
    open(unit=12,file='configuracion.dat',action='write',status='replace')
      
    do j=1,N
      write(12,*) ( r(i,j), i=1,3 ) , ( v(i,j), i=1,3 )
    end do
 
    close(12) 
  
    !Guardar funcion g(r) normalizada
#ifdef GDR
    open(unit=13,file='correlacion.dat',action='write',status='unknown')
    do k = 1, n_bins
      dens_casc = 4.0/3.0*3.141592*(bines(k)**3-bines(k-1)**3)*N/L**3
      write(13,*) bines(k), cuentas(k)/(N*dens_casc*nstep/nwrite)
    end do
    close(13)
#endif


! Escribir la última semilla para continuar con la cadena de numeros aleatorios 
    open(unit=10,file='seed.dat',status='unknown')
    seed = shr3() 
     write(10,*) seed
    close(10)
![FIN no Tocar]        

  end subroutine
  
  