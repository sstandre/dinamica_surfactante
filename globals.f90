module globals
  implicit none

  real(8), allocatable :: r(:,:), v(:,:), f(:,:), bines(:), cuentas(:)
  real(8) :: L, Vtot, T, rc2, Vrc, sigma, eps, m, dt, Ecin, gamma, presion
  integer :: N, nstep, seed, nwrite, n_bins
  logical :: vb

end module globals
