vlib work
vlog ./TB_SBINIT_WRAPPER.sv 
vlog ./*.v
vsim -voptargs=+acc TB_SBINIT_WRAPPER  
do wave_wrapper.do
run -all  
