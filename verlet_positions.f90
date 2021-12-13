subroutine verlet_positions
    use globals
    implicit none
    real(8) :: temp
    integer :: i

    temp = dt**2/2
    
    do i =1,N
        ! Actualizo posiciones a t+dt
        r(:,i) = r(:,i) + v(:,i)*dt + f(:,i)*temp/m(atype(i))
        ! Condiciones de contorno periodicas para la posicion
        r = modulo(r, L)
    end do

end subroutine