MAKEFILE = Makefile
exe = dinamica
fcomp = gfortran #ifort # /opt/intel/compiler70/ia32/bin/ifc  
# Warning: the debugger doesn't get along with the optimization options
# So: not use -O3 WITH -g option
flags = -cpp -O3  
# Remote compilation
OBJS = ziggurat.o globals.o write_conf.o lang.o init.o force.o verlet.o final.o main.o

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
force.o: globals.o control.h force.f90
init.o: ziggurat.o globals.o write_conf.o force.o init.f90
lang.o: globals.o ziggurat.o verlet.f90
verlet.o: globals.o force.o lang.o verlet.f90
final.o: ziggurat.o globals.o write_conf.o control.h final.f90

main.o: main.f90 ziggurat.o globals.o init.o force.o verlet.o write_conf.o final.o
