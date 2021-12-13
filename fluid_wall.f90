subroutine fluid_wall
    use globals
    implicit none
    integer :: i, i_type
    real(8) :: inv_z, r_dummy, v_fluid_wall, zskin, e_wall, s_wall
    
    zskin = 0.7
    v_fluid_wall = 0.

    do i = 1,N
        i_type = atype(i)
        e_wall =(eps_wall(i_type))
        s_wall = (sigma_wall(i_type))
        inv_z = 1./r(3,i)
        r_dummy = s_wall*inv_z
        ! En la pared inferior tengo un potencial L-J integrado
        v_fluid_wall = v_fluid_wall + e_wall*(r_dummy**9 - r_dummy**3)    !int with bottom wall
        
        f(3,i) = f(3,i) + 9.*e_wall*(s_wall)**9*(inv_z)**10
        f(3,i) = f(3,i) - 3.*e_wall*(s_wall)**3*(inv_z)**4
        ! En la pared superior "rebota"
        if ( r(3,i) > (Z - zskin) .and. v(3,i) > 0. ) then
            v(3,i) = -v(3,i)
        end if  
    end do

    Vtot = Vtot + v_fluid_wall

end subroutine