subroutine medir(mode)
    use globals
    implicit none
    integer, intent(in) :: mode
    integer :: i, zi, i_type
    real(8) :: normal1, normal2, rcm
#ifdef GDR
    integer :: j,k
    real(8) :: d, dvec(3)
#endif

    select case(mode)
    case(0) 
        ! Inicializo perfil de densidad
        zbins = 100
        deltaz = dble(Z)/dble(zbins)
        allocate(hist_z(2,0:zbins-1))
        hist_z(:,:) = 0

        ! Abro archivo .vtf
        call write_conf(0)
        ! Abro archivo con datos de medición
        open(unit=13,file='output.dat',status='unknown')
        write(13, *) "Paso    Potencial   Cinetica    Total     Presion"

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
            i_type = atype(i)
            Ecin = Ecin + sum(v(:,i)*v(:,i))*(m(i_type))
        end do
        Ecin = 0.5*Ecin / N
        Vtot = Vtot / N
        if (vb) print *, Vtot, Ecin, Vtot+Ecin
        ! Escribir en output.dat las cantidades de interes
        write(13, *) istep, Vtot, Ecin, Vtot+Ecin                 ! , presion
        ! Escribir configuracion para visualizar con vmd
        call write_conf(1)
        ! Calcular perfil de densidad
        ! USAR POSICIONES NORMALIZADAS PARA BINS
        do i = 1, n_2
            rcm = 0.5 * (r(3,i) + r(3,i+n_1))
            zi = int(rcm/deltaz)
            hist_z(2, zi) = hist_z(2, zi) + 1 
        end do
        
        do i = n_2+1, n_1
            zi = int(r(3,i)/deltaz)
            hist_z(1, zi) = hist_z(1, zi) + 1 
        end do

#ifdef GDR
        do i = 1, N-1
        do j = i+1, N
            dvec(:) = r(:,i) - r(:,j)
            ! Por condiciones de contorno, la distancia en x,y debe ser -L/2<d<L/2
            dvec(1:2) = dvec(1:2) - L*int(2*dvec(1:2)/L)
            d = sqrt(sum(dvec*dvec))
            ! Contar la distancia en el primer bin que sea mayor a la distancia
            ! USAR DISTANCIAS NORMALIZADAS PARA BINS
            end do
        end do
#endif       

    case(2)
        !Cierro archivo output.dat
        if (vb) print *, '**************************************************************************'
        close(13)

        ! Guardar perfil de densidad
        open(unit=14,file='perfil.dat',action='write',status='unknown')
        write(14,*) "Z        fluid       surfact"
        do i = 0, zbins-1
            normal1 = dble(hist_z(1,i)) / ((n_1-n_2) * nstep/nwrite) 
            normal2 = dble(hist_z(2,i)) / (n_2 * nstep/nwrite) 
            write(14,*) deltaz*i, normal1, normal2
        end do
        close(14)

        ! Guardar funcion g(r) normalizada
#ifdef GDR
        open(unit=15,file='rdf.dat',action='write',status='unknown')
        do k = 1, gdr_bins
          dens_casc = 4.0/3.0*3.141592*(bines(k)**3-bines(k-1)**3)*N/L**3
          write(15,*) bines(k), cuentas(k)/(N*dens_casc*nstep/nwrite)
        end do
        close(15)
#endif
    
    end select

end subroutine