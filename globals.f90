module globals
  implicit none
  integer, allocatable :: atype(:), hist_z(:,:), hist_gdr(:,:)
  real(8), allocatable :: r(:,:), v(:,:), f(:,:)
  real(8) :: Z, L, Vtot, T, rc2, Vrc(2,2), sigma(2,2), eps(2,2), m(2), dt, &
             Ecin, gamma, presion, eps_wall(2), sigma_wall(2), deltaz
  integer :: n_1, n_2, N, nstep, seed, nwrite, istep, zbins, gdr_bins
  logical :: vb, print_debug

end module globals
