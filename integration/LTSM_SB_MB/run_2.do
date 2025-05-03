vlib work
vlog ./TB_LTSM_SB_MB.sv
vlog ./LTSM_SB_MB.v 
vlog ../../LTSM/MBINIT/*.v
vlog ../../LTSM/MBTRAIN/*.v
vlog ../../LTSM/PHYRETRAIN/TX_PHYRETRAIN.v
vlog ../../LTSM/PHYRETRAIN/RX_PHYRETRAIN.v
vlog ../../LTSM/PHYRETRAIN/PHYRETRAIN_WRAPPER.v
vlog ../../LTSM/SBINIT/TX_SBINIT.v
vlog ../../LTSM/SBINIT/RX_SBINIT.v
vlog ../../LTSM/SBINIT/SBINIT_WRAPPER.v
vlog ../../LTSM/TRAINERROR/TX_TRAINERROR_HS.v
vlog ../../LTSM/TRAINERROR/RX_TRAINERROR_HS.v
vlog ../../LTSM/TRAINERROR/TRAINERROR_HS_WRAPPER.v
vlog ../../LTSM/TOP/LTSM_TOP.v
vlog ../../LTSM/SHARED_MODULE/nedege_detector.v
vlog ../../LTSM/SHARED_MODULE/*.v
vlog ../../MB_Blocks/*/*.v
vlog ../../MB_Blocks/clock_tx_rx/clock_generator.v
vlog ../../MB_Blocks/clock_tx_rx/clock_detector.v
vlog ../../RX_D2C_POINT_TEST/rx_initiated_point_test_tx.v
vlog ../../RX_D2C_POINT_TEST/rx_initiated_point_test_rx.v
vlog ../../RX_D2C_POINT_TEST/rx_initiated_point_test_wrapper.v
vlog ../../TX_D2C_POINT_TEST/tx_initiated_point_test_tx.v
vlog ../../TX_D2C_POINT_TEST/tx_initiated_point_test_rx.v
vlog ../../TX_D2C_POINT_TEST/tx_initiated_point_test_wrapper.v
vlog ../../synchronizers/*.v
vlog ../../SB_RTL/ANALOG_MODELLING/*.sv
vlog ../../SB_RTL/SIDEBAND_TX/*.sv
vlog ../../SB_RTL/SIDEBAND_RX/*.sv
vlog ../../SB_RTL/SIDEBAND_TOP_WRAPPER/*.sv
vlog ../../Full_UVM_Env/pack1.sv

vsim -voptargs=+acc work.top

do wave_uvm_2.do
# add wave -position insertpoint  \
# sim:/uvm_root/uvm_test_top/env/agent/driver/count \
# sim:/uvm_root/uvm_test_top/env/agent/driver/sb_pattern_detected \
# sim:/uvm_root/uvm_test_top/env/agent/driver/new_resp \
# sim:/uvm_root/uvm_test_top/env/agent/driver/new_req \
# sim:/uvm_root/uvm_test_top/env/agent/driver/rsp \
# sim:/uvm_root/uvm_test_top/env/agent/driver/req \
# sim:/uvm_root/uvm_test_top/env/agent/driver/trans
run -all 



 

 