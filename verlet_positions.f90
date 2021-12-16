subroutine verlet_positions
    use globals
    implicit none
    real(8) :: temp
    integer :: i,j

    temp = dt**2/2
    
    do i =1,N
        ! Actualizo posiciones a t+dt
        r(:,i) = r(:,i) + v(:,i)*dt + f(:,i)*temp/m(atype(i))
        ! Condiciones de contorno periodicas en x,y

        do j = 1,2
            if (r(j,i) > L) then
                r(j,i) = r(j,i) - L
            else if (r(j,i) < 0) then
                r(j,i) = r(j,i) + L 
            end if
        end do

        ! r(1,i) = modulo(r(1,i), L)
        ! r(2,i) = modulo(r(2,i), L)

        if (print_debug) then
            do j = 1,3
                if (r(j,i) > L .or. r(j,i) < 0) then
                    print *, "STOOOOOP"
                    print *, r(:, i)
                    stop
                end if
            end do
        end if
    end do

    
    

end subroutine