vlib work 
vlog *.v
vlog *.sv
vsim -voptargs=+acc work.tx_rx_tb_with_pattern
add wave -position insertpoint  \
sim:/tx_rx_tb_with_pattern/tx_cs \
sim:/tx_rx_tb_with_pattern/tx_ns \
sim:/tx_rx_tb_with_pattern/DUT_tx/o_encoded_sideband_message \
sim:/tx_rx_tb_with_pattern/DUT_tx/o_valid \
sim:/tx_rx_tb_with_pattern/DUT_tx/o_sb_data_pattern \
sim:/tx_rx_tb_with_pattern/DUT_tx/o_sb_burst_count \
sim:/tx_rx_tb_with_pattern/DUT_tx/o_sb_comparison_mode \
sim:/tx_rx_tb_with_pattern/DUT_tx/o_val_pattern_en \
sim:/tx_rx_tb_with_pattern/DUT_tx/o_mainband_pattern_generator_cw \
sim:/tx_rx_tb_with_pattern/DUT_tx/o_test_finish_ack \
sim:/tx_rx_tb_with_pattern/DUT_tx/o_pi_step \
sim:/tx_rx_tb_with_pattern/rx_cs \
sim:/tx_rx_tb_with_pattern/rx_ns \
sim:/tx_rx_tb_with_pattern/DUT_rx/o_encoded_sideband_message \
sim:/tx_rx_tb_with_pattern/DUT_rx/o_sideband_data \
sim:/tx_rx_tb_with_pattern/DUT_rx/o_valid \
sim:/tx_rx_tb_with_pattern/DUT_rx/o_mainband_pattern_compartor_cw \
sim:/tx_rx_tb_with_pattern/DUT_rx/o_comparison_valid_en \
sim:/tx_rx_tb_with_pattern/DUT_rx/o_reciever_ref_volatge
###########################debugging pattern generator#####################################################
# add wave -position insertpoint  \
# sim:/tx_rx_tb_with_pattern/pattern_generator/i_state \
# sim:/tx_rx_tb_with_pattern/pattern_generator/enable_scrambeling_pattern \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_0 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_1 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_2 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_3 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_4 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_5 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_6 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_7 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_8 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_9 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_10 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_11 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_12 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_13 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_14 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/out_data_lane_15 \
# sim:/tx_rx_tb_with_pattern/pattern_generator/done \
# sim:/tx_rx_tb_with_pattern/pattern_generator/counter_lfsr
run -all