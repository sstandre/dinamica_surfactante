module globals
  implicit none
  integer, allocatable :: atype(:)
  real(8), allocatable :: r(:,:), v(:,:), f(:,:), bines(:), cuentas(:)
  real(8) :: Z, L, Vtot, T, rc2, Vrc(2,2), sigma(2,2), eps(2,2), m(2), dt, &
             Ecin, gamma, presion, eps_wall(2), sigma_wall(2)
  integer :: n_1, n_2, N, nstep, seed, nwrite, n_bins
  logical :: vb, print_debug

end module globals
