subroutine force(mode)
  use globals
#include "control.h" 
  implicit none
  integer, intent(in) :: mode
  integer :: i, j
  real(8) :: dvec(3), fij(3)
  real(8) :: dist2, temp

  select case(mode)
  case(0)   ! Inicializar radio de corte y potencial
    
    rc2 = (2.5*sigma)**2
    temp = sigma**6/rc2**3
    Vrc = 4*eps*temp*(temp-1)


  case(1)   ! Loop sobre pares de atomos
    
    ! Inicializar acumuladores en 0
    Vtot = 0.0
    f(:,:) = 0.0
    presion = 0.0

    do i = 1, N-1
      do j = i+1, N
        dvec(:) = r(:,i) - r(:,j)
        ! Por condiciones de contorno, la distancia siempre debe ser -L/2<d<L/2
        dvec = dvec - L*int(2*dvec/L)
        ! Solo necesito distancia^2 para hacer las cuentas
        dist2 = sum(dvec*dvec)

        if(dist2 < rc2) then  ! Solo cuento atomos dentro del radio de corte
          ! Uso una variable temporal para no calcular tantas potencias de dist
          temp = sigma**6/dist2**3
          ! Vtot acumula el potencial de todos los pares, con la correccion del radio de corte
          Vtot = Vtot + 4*eps*temp*(temp-1) - Vrc
          ! fij es el vector de fuerza que siente el atomo i debido al j
          fij(:) =  24*eps*temp*(2*temp-1)/dist2 * dvec(:)
          ! Acumulo las fuerzas en el array f
          f(:,i) = f(:,i) + fij(:)
          ! El par de reaccion corresponde a la fueza que siente j debido a i
          f(:,j) = f(:,j) - fij(:)

          !virial (chequear signo)
          presion = presion + sum(dvec*fij)
        end if
      end do
    end do
    
    presion = (presion/3 + N*T)/L**3

  end select

end subroutine