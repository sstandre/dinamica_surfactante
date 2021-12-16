MAKEFILE = Makefile
exe = surfactante
fcomp = gfortran #ifort # /opt/intel/compiler70/ia32/bin/ifc  
# Warning: the debugger doesn't get along with the optimization options
# So: not use -O3 WITH -g option
flags = -cpp -O3  
# Remote compilation
OBJS = ziggurat.o globals.o write_conf.o lang.o init.o force.o intra_molec.o \
	   fluid_wall.o verlet_positions.o verlet_velocities.o final.o main.o minim.o

.SUFFIXES:            # this deletes the default suffixes 
.SUFFIXES: .f90 .o    # this defines the extensions I want 

.f90.o:  
	$(fcomp) -c $(flags) $< 
        

$(exe):  $(OBJS) Makefile 
	$(fcomp) $(flags) -o $(exe) $(OBJS) 


clean:
	rm ./*.o ./*.mod	

ziggurat.o: ziggurat.f90
globals.o: globals.f90
write_conf.o: globals.o write_conf.f90
minim.o: globals.o minim.f90
init.o: ziggurat.o globals.o write_conf.o force.o minim.o init.f90
lang.o: globals.o ziggurat.o lang.f90
verlet_positions.o: globals.o  verlet_positions.f90
verlet_velocities.o: globals.o  verlet_velocities.f90
intra_molec.o: globals.o intra_molec.f90
fluid_wall.o: globals.o fluid_wall.f90
force.o: globals.o intra_molec.o control.h force.f90
final.o: ziggurat.o globals.o write_conf.o control.h final.f90

main.o: main.f90 ziggurat.o globals.o init.o force.o fluid_wall.o \
		verlet_positions.o verlet_velocities.o write_conf.o final.o
