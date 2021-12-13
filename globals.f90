module globals
  implicit none
  integer, allocatable :: atype(:)
  real(8), allocatable :: r(:,:), v(:,:), f(:,:), bines(:), cuentas(:)
  real(8) :: L, Vtot, T, rc2, Vrc(2,2), sigma(2,2), eps(2,2), m(2), dt, Ecin, gamma, presion
  integer :: n_1, n_2, N, nstep, seed, nwrite, n_bins
  logical :: vb

end module globals
