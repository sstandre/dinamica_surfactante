subroutine final()
    use globals
    use ziggurat
    implicit none
    integer :: i, j

    ! Cerrar el archivo de mediciones
    call medir(2)
    ! Cerrar el archivo de configuraciones
    call write_conf(2)

    ! ! Guardar la ultima configuracion en un archivo
    open(unit=12,file='configuracion.dat',action='write',status='replace')
      
    do j=1,N
      write(12,*) ( r(i,j), i=1,3 ) , ( v(i,j), i=1,3 )
    end do
 
    close(12) 


! Escribir la última semilla para continuar con la cadena de numeros aleatorios 
    open(unit=10,file='seed.dat',status='unknown')
    seed = shr3() 
     write(10,*) seed
    close(10)
![FIN no Tocar]        

  end subroutine
  
  