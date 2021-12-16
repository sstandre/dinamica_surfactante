subroutine medir(mode)
    use globals
    implicit none
    integer, intent(in) :: mode
    integer :: i
    real(8) :: dz
#ifdef GDR
    integer :: j,k
    real(8) :: d, dvec(3)
#endif

    select case(mode)
    case(0) 
        ! Abro archivo .vtf
        call write_conf(0)
        ! Abro archivo con datos de medición
        open(unit=15,file='output.dat',status='unknown')
        write(15, *) "Paso    Potencial   Cinetica    Total     Presion"

        if (vb) then
            print *, '**************************************************************************'
            ! Calculo inicial de energia
            Ecin = 0
            do i = 1, N
                Ecin = Ecin + sum(v(:,i)*v(:,i))*(m(atype(i)))
            end do
            Ecin = 0.5*Ecin / N
            Vtot = Vtot / N
            print *, "energia"
            print *, "  potencial                 cinetica                  total"
            print *, Vtot, Ecin, Vtot+Ecin
            print *, '--------------------------------------------------------------------------'
        end if

    case(1) 
        !Mediciones y escribir a archivo
        Ecin = 0
        do i = 1, N
            Ecin = Ecin + sum(v(:,i)*v(:,i))*(m(atype(i)))
        end do
        Ecin = 0.5*Ecin / N
        Vtot = Vtot / N
        if (vb) print *, Vtot, Ecin, Vtot+Ecin
        write(15, *) istep, Vtot, Ecin, Vtot+Ecin                 ! , presion
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

    case(2)
        !Cierro archivo
        if (vb) print *, '**************************************************************************'
        close(15)

    end select

end subroutine