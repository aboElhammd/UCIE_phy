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
vlog ../../MB_Blocks/*/*.v
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
do wave.do
run -all 

 

 