      subroutine intra_molec()
      use globals
      implicit none
      integer:: i_part, j_part, i_mon
      real(8) :: delta_r(3), r_2, force_loc(3), k_chain, v_intra_molec, r_dummy, r_chain, inv_r_chain_2
      
!  **** Variables 
! n_dim = 3. Dimensiones del espacio
    v_intra_molec = 0.
    k_chain = 30.
    r_chain = 1.5
    inv_r_chain_2 = 1./r_chain**2 !????????????????????????????????????
    
! Intra for polymers
! para los dímeros
! n_chain = numero de dímeros
! n_mon = 2 
! dimeros y trimeros

    do i_part = 1,n_2       ! los primeros n_2 atomos coresponden a la cabeza de los dimeros
        do i_mon = 1,2
            ! i_part = (i_chain-1)*n_mon+i_mon
            j_part = i_part+n_1     !las colas de los dimeros estan al final de la lista

            delta_r(:) = r(:,i_part) - r(:,j_part)
            delta_r(1:2) = delta_r(1:2) - L *  int(2.*delta_r(1:2)/L)
            r_2 = sum(delta_r*delta_r)

!   -----  check whether interaction takes place

            r_dummy = min(r_2*inv_r_chain_2,0.98)
            v_intra_molec = v_intra_molec -0.5*log(1. -r_dummy)
            r_dummy = k_chain/(1. -r_dummy)*inv_r_chain_2
            force_loc(:) = r_dummy*delta_r(:)
            ! HPC
            f(:,i_part) = f(:,i_part) - force_loc(:)
            f(:,j_part) = f(:,j_part) + force_loc(:)

        end do
    end do

    Vtot = Vtot + k_chain*v_intra_molec

end subroutine intra_molec
