cd C:/questasim64_2021.1/examples/GP/RX_D2C_POINT_TEST/integration_with_pattern_generator_detector
vlib work
vlog ./*.sv 
vlog ./*.v
vsim -voptargs=+acc tb_rx_d2c_pt_with_pattern_integ  
do wave_integ.do
run -all  
