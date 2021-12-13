
      subroutine fluid_wall(inter_type)
        
#include "control.h"
      use globals
      implicit none
      real (kind=8) :: inv_z
      integer, intent(in) :: inter_type
      logical, parameter :: debug_fw=.false.

      v_fluid_wall = 0.

!-----------  ! Only bottom wall with 9-3 potential and top wall pure repulsive (hard wall)


          !------- Bottom Wall interaction 

          do i_part = 1,N

              inv_z = 1./r0(3,i_part) 

              r_dummy = sigma_w*inv_z


              v_fluid_wall = v_fluid_wall + abs(a_w)*r_dummy**9 - a_w*r_dummy**3    !int with bottom wall

             

              ! HPC
              force(3,i_part) = force(3,i_part) +   9.*abs(a_w)*(sigma_w)**9*(inv_z)**10 
              force(3,i_part) = force(3,i_part)   - 3.*a_w*(sigma_w)**3*(inv_z)**4                              

 !------- Top  Wall interaction: athermal or adiabatic wall 
! z_head: pequeña distancia de seguridad 
              if (r0(3,i_part) > (Lz-z_head) .and. v(3,i_part) > 0. ) then
                  v(3,i_part) = -v(3,i_part)
              end if

          end do


         end subroutine fluid_wall
