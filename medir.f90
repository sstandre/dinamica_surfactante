subroutine medir(mode)
    use globals
#include "control.h"
    implicit none
    integer, intent(in) :: mode
    integer :: i, zi, i_type
    real(8) :: normal1, normal2, rcm
#ifdef GDR
    integer :: j, j_type, k, n_norm(2), ri
    real(8) :: d, dvec(3), dens_casc, temp
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


#ifdef GDR
        gdr_bins = 200
        deltag = 4./dble(gdr_bins)
        allocate(hist_gdr(2,2,0:gdr_bins-1))
        hist_gdr(:,:,:) = 0
#endif

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
            i_type = atype(i)
            do j = i+1, N
                j_type = atype(j)
                dvec(:) = r(:,i) - r(:,j)
                ! Por condiciones de contorno, la distancia en x,y debe ser -L/2<d<L/2
                dvec(1:2) = dvec(1:2) - L*int(2*dvec(1:2)/L)
                d = sqrt(sum(dvec*dvec))
                if (d > 4.) then
                    cycle
                end if
                ! Contar la distancia en el primer bin que sea mayor a la distancia
                ! USAR DISTANCIAS NORMALIZADAS PARA BINS
                ri = int(d/deltag)
                hist_gdr(i_type, j_type, ri) = hist_gdr(i_type, j_type, ri) + 1 
                hist_gdr(j_type, i_type, ri) = hist_gdr(j_type, i_type, ri) + 1 

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
        if (vb) print *, "GUARDANDO G(R)"
        open(unit=15,file='rdf.dat',action='write',status='unknown')
        temp = 4.0/3.0*3.141592*deltag**3/(L**2*Z)
        n_norm(1) = n_1
        n_norm(2) = n_2
        do k = 0, gdr_bins-1
            write(15,"(ES15.8)", advance="NO") k*deltag
            dens_casc = temp * ((k+1)**3-k**3)
            do i = 1,2
                do j = 1,2
                    write(15,"(ES15.8)", advance="NO") hist_gdr(i, j, k)/(n_norm(i)*n_norm(j)*dens_casc*nstep/nwrite)
                end do
            end do
            write(15,*)
        end do
        close(15)
#endif
    
    end select

end subroutine