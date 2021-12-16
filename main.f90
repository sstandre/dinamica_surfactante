program main
  use globals
  use ziggurat
#include "control.h"
  implicit none
  
  print_debug = .false.
  ! Inicializo posiciones y velocidades y calculo el potencial y las fuerzas
  call init()
  call force(1)
  call fluid_wall()

  print_debug = .true.    ! Chequear que las particulas no se vayan de la caja
  call medir(0)           ! Inicializa archivo de medición

  do istep = 1, nstep
    ! Las nuevas posiciones y velocidades se calculan mediante Verlet
    ! Actualizo posiciones a t+dt
    call verlet_positions()
    ! Velocidad "intermedia" (en t+dt/2)
    call verlet_velocities()
    ! Actualizo el potencial y las fuerzas a t+dt
    call force(1)
    call fluid_wall()
    ! Actualizar las fuerzas con el termostato de Langevin
    call lang()
    ! Velocidad "final" (en t+dt)
    call verlet_velocities()

    if(mod(istep,nwrite)==0) then
      call medir(1)
    end if
    
  end do
  
  ! Rutina de finalizacion para cerrar archivos, etc
   call final()

end program main
