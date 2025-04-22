vlib work
vlog ./TB_TRAINERROR_HS_WRAPPER.sv 
vlog ./*.v
vsim -voptargs=+acc TB_TRAINERROR_HS_WRAPPER  
do wave_wrapper.do
run -all  
