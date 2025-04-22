vlib work
vlog ./*.sv 
vlog ./*.v
vsim -voptargs=+acc TB_TX_SBINIT  
do wave.do
run -all  
