subroutine write_conf(mode)
    use globals
    implicit none
    integer, intent(in) :: mode
    integer :: i
    character(len=12) :: N_str


    select case(mode)
    case(0)  ! Abrir archivo y escribir header
        write(N_str, *) N-1
        open(unit=20, file='movie.vtf', status='unknown')
        write(20, *) 'atom 0:' // adjustl(N_str) //'radius 0.5 name Ar'

    case(1)  ! Escribir un frame de la animacion
        write(20, *) "timestep"
        write(20, *)
        do i=1,N
            write(20, *) r(:,i)
        end do

    case(2)  ! Cerrar archivo
        close(20)

    end select

end subroutine