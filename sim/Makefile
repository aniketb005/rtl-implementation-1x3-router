#Makefile script for Command line usage for Simulation/Synthesis

RTL= ../rtl/routertop.v ../../fifo/rtl/fifo_router.v ../../fsm/rtl/fsm_router.v ../../register/rtl/register_router.v ../../sync/rtl/sync_router.v
###RTL=../rtl/routertop.v ../fifo/rtl/fifo_router.v ../sync/rtl/sync_router.v ../fsm/rtl/fsm_router.v ../register/rtl/register_router.v  
TB= ../tb/routertop_tb.v
GLBL=glbl.v

######   Simulation  steps ########################################### 
compile:
	vlogcomp $(RTL) $(GLBL) $(TB) #Compiles the source codes and link to the default library work

sim:
	fuse work.routertop_tb  work.glbl -L unisims_ver -L unimacro_ver -L xilinxcorelib_ver -o cmd.exe #Fuse is used here to create a ISIM executable file

exe:
	./cmd.exe #After running the binary file it opens the ISIM console mode and then type run all

run_all:compile sim exe

gui:
	gtkwave&

clean:
	rm -rf fuse* isim* xst *.log *.exe *.ngc* *.ngr *.srp _xmsgs *.vcd	#clean the simulation logs


####### Synthesis   steps ################################################

synthesis:
	xst -ifn synth.scr -ofn synth.log 
 

