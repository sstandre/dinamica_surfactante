subroutine lang
    use globals
    use ziggurat
    implicit none

    real(8) :: alpha
    integer :: i, j
    
    alpha = sqrt(2*gamma*m*T/dt)

    do i=1,N
        do j=1,3
            f(j,i) = f(j,i) - gamma*v(j,i) + rnor()*alpha
        end do
    end do

end subroutine