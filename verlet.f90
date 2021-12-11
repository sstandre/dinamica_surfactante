subroutine verlet
    use globals
    implicit none
    real(8) :: temp1, temp2

    temp1 = dt**2/(2*m)
    temp2 = dt/(2*m)

    ! Actualizo posiciones a t+dt
    r = r + v*dt +f*temp1
    ! Condiciones de contorno periodicas para la posicion
    r = modulo(r, L)
    ! Velocidad "intermedia" (en t+dt/2)
    v = v + f * temp2
    ! Actualizo el potencial y las fuerzas a t+dt
    call force(1)
    ! Actualizar las fuerzas con el termostato de Langevin
    call lang()
    ! Velocidad "final" (en t+dt)
    v = v + f * temp2

end subroutine