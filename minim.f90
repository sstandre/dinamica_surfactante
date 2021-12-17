subroutine minim(tmp, nmin, zskin)
    use globals
    implicit none
    real(8), intent(in) :: tmp, zskin
    integer, intent(in) :: nmin
    integer :: imin, i
    real(8) :: z_red

    z_red = Z-2*zskin

    do imin=1,nmin
        call force(1)
        if (vb.and.(mod(imin,nmin/10)==0)) print *, Vtot
        do i = 1,N

            r(:,i) = r(:,i) + f(:,i) * tmp
            
            ! al principio vale todo para minimizar
            r(1:2,i) = modulo(r(1:2,i), L)
            r(3,i) = modulo(r(3,i)-zskin, z_red) + zskin

        end do
        
    end do

end subroutine