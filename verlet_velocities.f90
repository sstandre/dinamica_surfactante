subroutine verlet_velocities
    use globals
    implicit none
    real(8) :: temp
    integer :: i

    temp = dt/2
    
    do i =1,N
        ! Actualizo velocidades a t+dt/2
        v(:,i) = v(:,i) + f(:,i)*temp/m(atype(i))
    end do

end subroutine