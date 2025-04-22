cd C:/questasim64_2021.1/examples/GP/RX_D2C_POINT_TEST
vlib work
vlog ./*.sv 
vlog ./*.v
vsim -voptargs=+acc tb_rx_initiated_point_test_wrapper  
do wave.do
run -all  
