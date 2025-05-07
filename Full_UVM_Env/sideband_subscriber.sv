class coverage_collector extends uvm_component;
  `uvm_component_utils(coverage_collector)

  // Variables
  sideband_sequence_item tr;                          // Transaction object for coverage sampling
  uvm_analysis_export #(sideband_sequence_item) Coverage_Collector_port; // Analysis export to receive transactions
  uvm_tlm_analysis_fifo #(sideband_sequence_item) cov_fifo; // FIFO to buffer transactions from monitor

  // Covergroup: side_band_coverages
  // Tracks coverage of msg_code, msg_subcode, opcode fields, their cross, and state transitions in seq_item.
  covergroup side_band_coverages;
    option.per_instance = 1; // Separate coverage data for each instance

    // Coverpoint: cp_msg_code
    // Tracks coverage of msg_code field in seq_item with named bins.
    cp_msg_code: coverpoint tr.msg_code {
      bins msg_85h = {8'h85}; // Tx initiate D to C request
      bins msg_8Ah = {8'h8A}; // Tx initiate D to C response
    //   bins msg_81h = {8'h81}; // Rx Init D to C sweep done with results
      bins msg_91h = {8'h91}; // SBINIT out of Reset
      bins msg_95h = {8'h95}; // SBINIT done request
      bins msg_9Ah = {8'h9A}; // SBINIT done response
      bins msg_A5h = {8'hA5}; // MBINIT request
      bins msg_AAh = {8'hAA}; // MBINIT response
      bins msg_B5h = {8'hB5}; // MBTRAIN request
      bins msg_BAh = {8'hBA}; // MBTRAIN response
      bins msg_E5h = {8'hE5}; // TRAINERROR Entry request
      bins msg_EAh = {8'hEA}; // TRAINERROR Entry response
    //   bins msg_01h = {8'h01}; // AdvCap.Adapter
    //   bins msg_02h = {8'h02}; // FinCap.Adapter
      bins msg_C5h = {8'hC5}; // PHYRETRAIN request
      bins msg_CAh = {8'hCA}; // PHYRETRAIN response
    }

    // Coverpoint: cp_msg_subcode
    // Tracks coverage of msg_subcode field in seq_item with named bins.
    cp_msg_subcode: coverpoint tr.msg_subcode {
      bins sub_00h = {8'h00}; // Subcode 00h (e.g., SBINIT out of Reset)
      bins sub_01h = {8'h01}; // Subcode 01h (e.g., Start Tx Init D to C point test)
      bins sub_02h = {8'h02}; // Subcode 02h (e.g., LFSR clear error)
      bins sub_03h = {8'h03}; // Subcode 03h (e.g., Tx Init D to C results)
      bins sub_04h = {8'h04}; // Subcode 04h (e.g., End Tx Init D to C point test)
      bins sub_05h = {8'h05}; // Subcode 05h (e.g., Start Tx Init D to C eye sweep)
      bins sub_06h = {8'h06}; // Subcode 06h (e.g., End Tx Init D to C eye sweep)
      bins sub_07h = {8'h07}; // Subcode 07h (e.g., Start Rx Init D to C point test)
      bins sub_08h = {8'h08}; // Subcode 08h (e.g., Rx Init D to C Tx Count Done)
      bins sub_09h = {8'h09}; // Subcode 09h (e.g., End Rx Init D to C point test)
      bins sub_0Ah = {8'h0A}; // Subcode 0Ah (e.g., Start Rx Init D to C eye sweep)
      bins sub_0Bh = {8'h0B}; // Subcode 0Bh (e.g., Rx Init D to C results)
      bins sub_0Ch = {8'h0C}; // Subcode 0Ch (e.g., Rx Init D to C sweep done)
      bins sub_0Dh = {8'h0D}; // Subcode 0Dh (e.g., End Rx Init D to C eye sweep)
      bins sub_0Eh = {8'h0E}; // Subcode 0Eh (e.g., MBINIT.REVERSALMB clear error)
      bins sub_0Fh = {8'h0F}; // Subcode 0Fh (e.g., MBINIT.REVERSALMB result)
      bins sub_10h = {8'h10}; // Subcode 10h (e.g., MBINIT.REVERSALMB done)
      bins sub_11h = {8'h11}; // Subcode 11h (e.g., MBINIT.REPAIRMB start)
      bins sub_12h = {8'h12}; // Subcode 12h (e.g., MBTRAIN.RXDESKEW end)
      bins sub_13h = {8'h13}; // Subcode 13h (e.g., MBINIT.REPAIRMB end)
      bins sub_14h = {8'h14}; // Subcode 14h (e.g., MBINIT.REPAIRMB apply degrade)
      bins sub_15h = {8'h15}; // Subcode 15h (e.g., MBTRAIN.LINKSPEED start)
      bins sub_16h = {8'h16}; // Subcode 16h (e.g., MBTRAIN.LINKSPEED error)
      bins sub_17h = {8'h17}; // Subcode 17h (e.g., MBTRAIN.LINKSPEED exit to repair)
      bins sub_18h = {8'h18}; // Subcode 18h (e.g., MBTRAIN.LINKSPEED exit to speed degrade)
      bins sub_19h = {8'h19}; // Subcode 19h (e.g., MBTRAIN.LINKSPEED done)
    //   bins sub_1Ah = {8'h1A}; // Subcode 1Ah (e.g., MBTRAIN.LINKSPEED multi-module disable)
      bins sub_1Bh = {8'h1B}; // Subcode 1Bh (e.g., MBTRAIN.REPAIR init)
      bins sub_1Ch = {8'h1C}; // Subcode 1Ch (e.g., MBTRAIN.REPAIR Apply repair)
      bins sub_1Dh = {8'h1D}; // Subcode 1Dh (e.g., MBTRAIN.REPAIR end)
      bins sub_1Eh = {8'h1E}; // Subcode 1Eh (e.g., MBTRAIN.REPAIR Apply degrade)
      bins sub_1Fh = {8'h1F}; // Subcode 1Fh (e.g., MBTRAIN.LINKSPEED exit to phy retrain)
    }

    // Coverpoint: cp_opcode
    // Tracks coverage of opcode field in seq_item with named bins.
    cp_opcode: coverpoint tr.opcode {
      bins op_10010b = {5'b10010}; // Opcode 10010b
      bins op_11011b = {5'b11011}; // Opcode 11011b
    }

    // Cross: cross_msg_subcode_opcode
    // Tracks cross coverage between msg_code, msg_subcode, and opcode using bin names.
    cross_msg_subcode_opcode: cross cp_msg_code, cp_msg_subcode, cp_opcode {
      // Start Tx Init D to C point test request
	  option.cross_auto_bin_max = 0;
      bins start_tx_init_d_to_c_point_test_req = 
        binsof(cp_msg_code.msg_85h) && 
        binsof(cp_msg_subcode.sub_01h) && 
        binsof(cp_opcode.op_11011b);
      // Start Tx Init D to C point test response
      bins start_tx_init_d_to_c_point_test_resp = 
        binsof(cp_msg_code.msg_8Ah) && 
        binsof(cp_msg_subcode.sub_01h) && 
        binsof(cp_opcode.op_10010b);
      // LFSR clear error request
      bins lfsr_clear_error_req = 
        binsof(cp_msg_code.msg_85h) && 
        binsof(cp_msg_subcode.sub_02h) && 
        binsof(cp_opcode.op_10010b);
      // LFSR clear error response
      bins lfsr_clear_error_resp = 
        binsof(cp_msg_code.msg_8Ah) && 
        binsof(cp_msg_subcode.sub_02h) && 
        binsof(cp_opcode.op_10010b);
      // Tx Init D to C results request
      bins tx_init_d_to_c_results_req = 
        binsof(cp_msg_code.msg_85h) && 
        binsof(cp_msg_subcode.sub_03h) && 
        binsof(cp_opcode.op_10010b);
      // Tx Init D to C results response
      bins tx_init_d_to_c_results_resp = 
        binsof(cp_msg_code.msg_8Ah) && 
        binsof(cp_msg_subcode.sub_03h) && 
        binsof(cp_opcode.op_11011b);
      // End Tx Init D to C point test request
      bins end_tx_init_d_to_c_point_test_req = 
        binsof(cp_msg_code.msg_85h) && 
        binsof(cp_msg_subcode.sub_04h) && 
        binsof(cp_opcode.op_10010b);
      // End Tx Init D to C point test response
      bins end_tx_init_d_to_c_point_test_resp = 
        binsof(cp_msg_code.msg_8Ah) && 
        binsof(cp_msg_subcode.sub_04h) && 
        binsof(cp_opcode.op_10010b);
      // Start Tx Init D to C eye sweep request
        // here we can use 
    //   bins start_tx_init_d_to_c_eye_sweep_req = 
    //     binsof(cp_msg_code.msg_85h) && 
    //     binsof(cp_msg_subcode.sub_05h) && 
    //     binsof(cp_opcode.op_11011b);
      // Start Tx Init D to C eye sweep response
    //   bins start_tx_init_d_to_c_eye_sweep_resp = 
    //     binsof(cp_msg_code.msg_8Ah) && 
    //     binsof(cp_msg_subcode.sub_05h) && 
    //     binsof(cp_opcode.op_10010b);
    //   // End Tx Init D to C eye sweep request
    //   bins end_tx_init_d_to_c_eye_sweep_req = 
    //     binsof(cp_msg_code.msg_85h) && 
    //     binsof(cp_msg_subcode.sub_06h) && 
    //     binsof(cp_opcode.op_10010b);
    //   // End Tx Init D to C eye sweep response
    //   bins end_tx_init_d_to_c_eye_sweep_resp = 
    //     binsof(cp_msg_code.msg_8Ah) && 
    //     binsof(cp_msg_subcode.sub_06h) && 
    //     binsof(cp_opcode.op_10010b);
      // Start Rx Init D to C point test request
      bins start_rx_init_d_to_c_point_test_req = 
        binsof(cp_msg_code.msg_85h) && 
        binsof(cp_msg_subcode.sub_07h) && 
        binsof(cp_opcode.op_11011b);
      // Start Rx Init D to C point test response
      bins start_rx_init_d_to_c_point_test_resp = 
        binsof(cp_msg_code.msg_8Ah) && 
        binsof(cp_msg_subcode.sub_07h) && 
        binsof(cp_opcode.op_10010b);
      // Rx Init D to C Tx Count Done request
      bins rx_init_d_to_c_tx_count_done_req = 
        binsof(cp_msg_code.msg_85h) && 
        binsof(cp_msg_subcode.sub_08h) && 
        binsof(cp_opcode.op_10010b);
      // Rx Init D to C Tx Count Done response
      bins rx_init_d_to_c_tx_count_done_resp = 
        binsof(cp_msg_code.msg_8Ah) && 
        binsof(cp_msg_subcode.sub_08h) && 
        binsof(cp_opcode.op_10010b);
      // End Rx Init D to C point test request
      bins end_rx_init_d_to_c_point_test_req = 
        binsof(cp_msg_code.msg_85h) && 
        binsof(cp_msg_subcode.sub_09h) && 
        binsof(cp_opcode.op_10010b);
      // End Rx Init D to C point test response
      bins end_rx_init_d_to_c_point_test_resp = 
        binsof(cp_msg_code.msg_8Ah) && 
        binsof(cp_msg_subcode.sub_09h) && 
        binsof(cp_opcode.op_10010b);
    //   // Start Rx Init D to C eye sweep request
    //   bins start_rx_init_d_to_c_eye_sweep_req = 
    //     binsof(cp_msg_code.msg_85h) && 
    //     binsof(cp_msg_subcode.sub_0Ah) && 
    //     binsof(cp_opcode.op_11011b);
    //   // Start Rx Init D to C eye sweep response
    //   bins start_rx_init_d_to_c_eye_sweep_resp = 
    //     binsof(cp_msg_code.msg_8Ah) && 
    //     binsof(cp_msg_subcode.sub_0Ah) && 
    //     binsof(cp_opcode.op_10010b);
      // Rx Init D to C results request
      bins rx_init_d_to_c_results_req = 
        binsof(cp_msg_code.msg_85h) && 
        binsof(cp_msg_subcode.sub_0Bh) && 
        binsof(cp_opcode.op_10010b);
      // Rx Init D to C results response
      bins rx_init_d_to_c_results_resp = 
        binsof(cp_msg_code.msg_8Ah) && 
        binsof(cp_msg_subcode.sub_0Bh) && 
        binsof(cp_opcode.op_11011b);
      // Rx Init D to C sweep done with results
    //   bins rx_init_d_to_c_sweep_done_with_results = 
    //     binsof(cp_msg_code.msg_81h) && 
    //     binsof(cp_msg_subcode.sub_0Ch) && 
    //     binsof(cp_opcode.op_11011b);
      // End Rx Init D to C eye sweep request
    //   bins end_rx_init_d_to_c_eye_sweep_req = 
    //     binsof(cp_msg_code.msg_85h) && 
    //     binsof(cp_msg_subcode.sub_0Dh) && 
    //     binsof(cp_opcode.op_10010b);
    //   // End Rx Init D to C eye sweep response
    //   bins end_rx_init_d_to_c_eye_sweep_resp = 
    //     binsof(cp_msg_code.msg_8Ah) && 
    //     binsof(cp_msg_subcode.sub_0Dh) && 
    //     binsof(cp_opcode.op_10010b);
      // SBINIT out of Reset
      bins sbinit_out_of_reset = 
        binsof(cp_msg_code.msg_91h) && 
        binsof(cp_msg_subcode.sub_00h) && 
        binsof(cp_opcode.op_10010b);
      // SBINIT done request
      bins sbinit_done_req = 
        binsof(cp_msg_code.msg_95h) && 
        binsof(cp_msg_subcode.sub_01h) && 
        binsof(cp_opcode.op_10010b);
      // SBINIT done response
      bins sbinit_done_resp = 
        binsof(cp_msg_code.msg_9Ah) && 
        binsof(cp_msg_subcode.sub_01h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT PARAM configuration request
      bins mbinit_param_configuration_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_00h) && 
        binsof(cp_opcode.op_11011b);
      // MBINIT PARAM configuration response
      bins mbinit_param_configuration_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_00h) && 
        binsof(cp_opcode.op_11011b);
      // MBINIT CAL Done request
      bins mbinit_cal_done_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_02h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT CAL Done response
      bins mbinit_cal_done_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_02h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRCLK init request
      bins mbinit_repairclk_init_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_03h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRCLK init response
      bins mbinit_repairclk_init_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_03h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRCLK result request
      bins mbinit_repairclk_result_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_04h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRCLK result response
      bins mbinit_repairclk_result_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_04h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRCLK done request
      bins mbinit_repairclk_done_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_08h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRCLK done response
      bins mbinit_repairclk_done_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_08h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRVAL init request
      bins mbinit_repairval_init_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_09h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRVAL init response
      bins mbinit_repairval_init_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_09h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRVAL result request
      bins mbinit_repairval_result_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_0Ah) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRVAL result response
      bins mbinit_repairval_result_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_0Ah) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRVAL done request
      bins mbinit_repairval_done_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_0Ch) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRVAL done response
      bins mbinit_repairval_done_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_0Ch) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REVERSALMB init request
      bins mbinit_reversalmb_init_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_0Dh) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REVERSALMB init response
      bins mbinit_reversalmb_init_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_0Dh) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REVERSALMB clear error request
      bins mbinit_reversalmb_clear_error_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_0Eh) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REVERSALMB clear error response
      bins mbinit_reversalmb_clear_error_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_0Eh) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REVERSALMB result request
      bins mbinit_reversalmb_result_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_0Fh) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REVERSALMB result response
      bins mbinit_reversalmb_result_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_0Fh) && 
        binsof(cp_opcode.op_11011b);
      // MBINIT REVERSALMB done request
      bins mbinit_reversalmb_done_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_10h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REVERSALMB done response
      bins mbinit_reversalmb_done_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_10h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRMB start request
      bins mbinit_repairmb_start_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_11h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRMB start response
      bins mbinit_repairmb_start_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_11h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRMB end request
      bins mbinit_repairmb_end_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_13h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRMB end response
      bins mbinit_repairmb_end_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_13h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRMB apply degrade request
      bins mbinit_repairmb_apply_degrade_req = 
        binsof(cp_msg_code.msg_A5h) && 
        binsof(cp_msg_subcode.sub_14h) && 
        binsof(cp_opcode.op_10010b);
      // MBINIT REPAIRMB apply degrade response
      bins mbinit_repairmb_apply_degrade_resp = 
        binsof(cp_msg_code.msg_AAh) && 
        binsof(cp_msg_subcode.sub_14h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALVREF start request
      bins mbtrain_valvref_start_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_00h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALVREF start response
      bins mbtrain_valvref_start_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_00h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALVREF end request
      bins mbtrain_valvref_end_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_01h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALVREF end response
      bins mbtrain_valvref_end_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_01h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATAVREF start request
      bins mbtrain_datavref_start_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_02h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATAVREF start response
      bins mbtrain_datavref_start_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_02h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATAVREF end request
      bins mbtrain_datavref_end_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_03h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATAVREF end response
      bins mbtrain_datavref_end_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_03h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN SPEEDIDLE done request
      bins mbtrain_speedidle_done_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_04h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN SPEEDIDLE done response
      bins mbtrain_speedidle_done_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_04h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN TXSELFCAL Done request
      bins mbtrain_txselfcal_done_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_05h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN TXSELFCAL Done response
      bins mbtrain_txselfcal_done_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_05h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN RXCLKCAL start request
      bins mbtrain_rxclkcal_start_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_06h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN RXCLKCAL start response
      bins mbtrain_rxclkcal_start_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_06h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN RXCLKCAL done request
      bins mbtrain_rxclkcal_done_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_07h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN RXCLKCAL done response
      bins mbtrain_rxclkcal_done_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_07h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALTRAINCENTER start request
      bins mbtrain_valtraincenter_start_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_08h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALTRAINCENTER start response
      bins mbtrain_valtraincenter_start_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_08h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALTRAINCENTER done request
      bins mbtrain_valtraincenter_done_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_09h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALTRAINCENTER done response
      bins mbtrain_valtraincenter_done_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_09h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALTRAINVREF start request
      bins mbtrain_valtrainvref_start_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_0Ah) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALTRAINVREF start response
      bins mbtrain_valtrainvref_start_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_0Ah) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALTRAINVREF done request
      bins mbtrain_valtrainvref_done_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_0Bh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN VALTRAINVREF done response
      bins mbtrain_valtrainvref_done_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_0Bh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINCENTER1 start request
      bins mbtrain_datatraincenter1_start_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_0Ch) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINCENTER1 start response
      bins mbtrain_datatraincenter1_start_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_0Ch) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINCENTER1 end request
      bins mbtrain_datatraincenter1_end_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_0Dh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINCENTER1 end response
      bins mbtrain_datatraincenter1_end_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_0Dh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINVREF start request
      bins mbtrain_datatrainvref_start_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_0Eh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINVREF start response
      bins mbtrain_datatrainvref_start_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_0Eh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINVREF end request
      bins mbtrain_datatrainvref_end_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_10h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINVREF end response
      bins mbtrain_datatrainvref_end_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_10h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN RXDESKEW start request
      bins mbtrain_rxdeskew_start_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_11h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN RXDESKEW start response
      bins mbtrain_rxdeskew_start_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_11h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN RXDESKEW end request
      bins mbtrain_rxdeskew_end_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_12h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN RXDESKEW end response
      bins mbtrain_rxdeskew_end_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_12h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINCENTER2 start request
      bins mbtrain_datatraincenter2_start_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_13h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINCENTER2 start response
      bins mbtrain_datatraincenter2_start_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_13h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINCENTER2 end request
      bins mbtrain_datatraincenter2_end_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_14h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN DATATRAINCENTER2 end response
      bins mbtrain_datatraincenter2_end_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_14h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED start request
      bins mbtrain_linkspeed_start_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_15h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED start response
      bins mbtrain_linkspeed_start_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_15h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED error request
      bins mbtrain_linkspeed_error_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_16h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED error response
      bins mbtrain_linkspeed_error_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_16h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED exit to repair request
      bins mbtrain_linkspeed_exit_to_repair_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_17h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED exit to repair response
      bins mbtrain_linkspeed_exit_to_repair_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_17h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED exit to speed degrade request
      bins mbtrain_linkspeed_exit_to_speed_degrade_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_18h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED exit to speed degrade response
      bins mbtrain_linkspeed_exit_to_speed_degrade_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_18h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED done request
      bins mbtrain_linkspeed_done_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_19h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED done response
      bins mbtrain_linkspeed_done_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_19h) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED multi-module disable module response
    //   bins mbtrain_linkspeed_multi_module_disable_module_resp = 
    //     binsof(cp_msg_code.msg_BAh) && 
    //     binsof(cp_msg_subcode.sub_1Ah) && 
    //     binsof(cp_opcode.op_10010b);
      // MBTRAIN REPAIR init request
      bins mbtrain_repair_init_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_1Bh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN REPAIR init response
      bins mbtrain_repair_init_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_1Bh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN REPAIR Apply repair request
      bins mbtrain_repair_apply_repair_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_1Ch) && 
        binsof(cp_opcode.op_11011b);
      // MBTRAIN REPAIR Apply repair response
      bins mbtrain_repair_apply_repair_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_1Ch) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN REPAIR end request
      bins mbtrain_repair_end_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_1Dh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN REPAIR end response
      bins mbtrain_repair_end_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_1Dh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN REPAIR Apply degrade request
      bins mbtrain_repair_apply_degrade_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_1Eh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN REPAIR Apply degrade response
      bins mbtrain_repair_apply_degrade_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_1Eh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED exit to phy retrain request
      bins mbtrain_linkspeed_exit_to_phy_retrain_req = 
        binsof(cp_msg_code.msg_B5h) && 
        binsof(cp_msg_subcode.sub_1Fh) && 
        binsof(cp_opcode.op_10010b);
      // MBTRAIN LINKSPEED exit to phy retrain response
      bins mbtrain_linkspeed_exit_to_phy_retrain_resp = 
        binsof(cp_msg_code.msg_BAh) && 
        binsof(cp_msg_subcode.sub_1Fh) && 
        binsof(cp_opcode.op_10010b);
      // TRAINERROR Entry request
      bins trainerror_entry_req = 
        binsof(cp_msg_code.msg_E5h) && 
        binsof(cp_msg_subcode.sub_00h) && 
        binsof(cp_opcode.op_10010b);
      // TRAINERROR Entry response
      bins trainerror_entry_resp = 
        binsof(cp_msg_code.msg_EAh) && 
        binsof(cp_msg_subcode.sub_00h) && 
        binsof(cp_opcode.op_10010b);
      // LinkMgmt RDI Req Retrain
    //   bins linkmgmt_rdi_req_retrain = 
    //     binsof(cp_msg_code.msg_01h) && 
    //     binsof(cp_msg_subcode.sub_09h) && 
    //     binsof(cp_opcode.op_10010b);
      // LinkMgmt RDI Rsp Retrain
    //   bins linkmgmt_rdi_rsp_retrain = 
    //     binsof(cp_msg_code.msg_02h) && 
    //     binsof(cp_msg_subcode.sub_0Bh) && 
    //     binsof(cp_opcode.op_10010b);
      // PHYRETRAIN retrain start request
      bins phyretrain_retrain_start_req = 
        binsof(cp_msg_code.msg_C5h) && 
        binsof(cp_msg_subcode.sub_01h) && 
        binsof(cp_opcode.op_10010b);
      // PHYRETRAIN retrain start response
      bins phyretrain_retrain_start_resp = 
        binsof(cp_msg_code.msg_CAh) && 
        binsof(cp_msg_subcode.sub_01h) && 
        binsof(cp_opcode.op_10010b);
    }

      // Coverpoint: cp_state_transitions
    // Tracks coverage of state transitions for specific message sequences
//     cp_state_transitions: coverpoint cross_msg_subcode_opcode {
//       // Tx Init D to C point test sequence
//       bins tx_init_d_to_c_point_test_seq = 
//         (cross_msg_subcode_opcode.start_tx_init_d_to_c_point_test_req => 
//          cross_msg_subcode_opcode.start_tx_init_d_to_c_point_test_resp => 
//          cross_msg_subcode_opcode.lfsr_clear_error_req => 
//          cross_msg_subcode_opcode.lfsr_clear_error_resp => 
//          cross_msg_subcode_opcode.tx_init_d_to_c_results_req => 
//          cross_msg_subcode_opcode.tx_init_d_to_c_results_resp => 
//          cross_msg_subcode_opcode.end_tx_init_d_to_c_point_test_req => 
//          cross_msg_subcode_opcode.end_tx_init_d_to_c_point_test_resp);

//       // Transmitter Initiated Data to Clock Eye Width Sweep
//       bins tx_init_d_to_c_eye_sweep_seq = 
//         (cross_msg_subcode_opcode.start_tx_init_d_to_c_eye_sweep_req => 
//          cross_msg_subcode_opcode.start_tx_init_d_to_c_eye_sweep_resp => 
//          cross_msg_subcode_opcode.lfsr_clear_error_req => 
//          cross_msg_subcode_opcode.lfsr_clear_error_resp => 
//          cross_msg_subcode_opcode.tx_init_d_to_c_results_req => 
//          cross_msg_subcode_opcode.tx_init_d_to_c_results_resp => 
//          cross_msg_subcode_opcode.end_tx_init_d_to_c_eye_sweep_req => 
//          cross_msg_subcode_opcode.end_tx_init_d_to_c_eye_sweep_resp);

//       // Receiver Initiated Data to Clock Point Test
//       bins rx_init_d_to_c_point_test_seq = 
//         (cross_msg_subcode_opcode.start_rx_init_d_to_c_point_test_req => 
//          cross_msg_subcode_opcode.start_rx_init_d_to_c_point_test_resp => 
//          cross_msg_subcode_opcode.lfsr_clear_error_req => 
//          cross_msg_subcode_opcode.lfsr_clear_error_resp => 
//          cross_msg_subcode_opcode.rx_init_d_to_c_tx_count_done_req => 
//          cross_msg_subcode_opcode.rx_init_d_to_c_tx_count_done_resp => 
//          cross_msg_subcode_opcode.end_rx_init_d_to_c_point_test_req => 
//          cross_msg_subcode_opcode.end_rx_init_d_to_c_point_test_resp);

//       // Receiver Initiated Data to Clock Eye Width Sweep
//       bins rx_init_d_to_c_eye_sweep_seq = 
//         (cross_msg_subcode_opcode.start_rx_init_d_to_c_eye_sweep_req => 
//          cross_msg_subcode_opcode.start_rx_init_d_to_c_eye_sweep_resp => 
//          cross_msg_subcode_opcode.lfsr_clear_error_req => 
//          cross_msg_subcode_opcode.lfsr_clear_error_resp => 
//          cross_msg_subcode_opcode.rx_init_d_to_c_results_req => 
//          cross_msg_subcode_opcode.rx_init_d_to_c_results_resp => 
//          cross_msg_subcode_opcode.rx_init_d_to_c_sweep_done_with_results => 
//          cross_msg_subcode_opcode.end_rx_init_d_to_c_eye_sweep_req => 
//          cross_msg_subcode_opcode.end_rx_init_d_to_c_eye_sweep_resp);

//       // SBINIT sequence
//       bins sbinit_seq = 
//         (cross_msg_subcode_opcode.sbinit_out_of_reset => 
//          cross_msg_subcode_opcode.sbinit_done_req => 
//          cross_msg_subcode_opcode.sbinit_done_resp);

//       // MBINIT parameter configuration sequence
//       bins mbinit_param_config_seq = 
//         (cross_msg_subcode_opcode.mbinit_param_configuration_req => 
//          cross_msg_subcode_opcode.mbinit_param_configuration_resp);

//       // MBINIT CAL Done sequence
//       bins mbinit_cal_done_seq = 
//         (cross_msg_subcode_opcode.mbinit_cal_done_req => 
//          cross_msg_subcode_opcode.mbinit_cal_done_resp);

//       // MBINIT REPAIRCLK sequence
//       bins mbinit_repairclk_seq = 
//         (cross_msg_subcode_opcode.mbinit_repairclk_init_req => 
//          cross_msg_subcode_opcode.mbinit_repairclk_init_resp => 
//          cross_msg_subcode_opcode.mbinit_repairclk_result_req => 
//          cross_msg_subcode_opcode.mbinit_repairclk_result_resp => 
//          cross_msg_subcode_opcode.mbinit_repairclk_done_req => 
//          cross_msg_subcode_opcode.mbinit_repairclk_done_resp);

//       // MBINIT REPAIRVAL sequence
//       bins mbinit_repairval_seq = 
//         (cross_msg_subcode_opcode.mbinit_repairval_init_req => 
//          cross_msg_subcode_opcode.mbinit_repairval_init_resp => 
//          cross_msg_subcode_opcode.mbinit_repairval_result_req => 
//          cross_msg_subcode_opcode.mbinit_repairval_result_resp => 
//          cross_msg_subcode_opcode.mbinit_repairval_done_req => 
//          cross_msg_subcode_opcode.mbinit_repairval_done_resp);

//       // MBINIT REVERSALMB sequence
//       bins mbinit_reversalmb_seq = 
//         (cross_msg_subcode_opcode.mbinit_reversalmb_init_req => 
//          cross_msg_subcode_opcode.mbinit_reversalmb_init_resp => 
//          cross_msg_subcode_opcode.mbinit_reversalmb_clear_error_req => 
//          cross_msg_subcode_opcode.mbinit_reversalmb_clear_error_resp => 
//          cross_msg_subcode_opcode.mbinit_reversalmb_result_req => 
//          cross_msg_subcode_opcode.mbinit_reversalmb_result_resp => 
//          cross_msg_subcode_opcode.mbinit_reversalmb_done_req => 
//          cross_msg_subcode_opcode.mbinit_reversalmb_done_resp);

//       // MBINIT REPAIRMB sequence
//       bins mbinit_repairmb_seq = 
//         (cross_msg_subcode_opcode.mbinit_repairmb_start_req => 
//          cross_msg_subcode_opcode.mbinit_repairmb_start_resp => 
//          cross_msg_subcode_opcode.mbinit_repairmb_apply_degrade_req => 
//          cross_msg_subcode_opcode.mbinit_repairmb_apply_degrade_resp => 
//          cross_msg_subcode_opcode.mbinit_repairmb_end_req => 
//          cross_msg_subcode_opcode.mbinit_repairmb_end_resp);

//       // MBTRAIN VALVREF sequence
//       bins mbtrain_valvref_seq = 
//         (cross_msg_subcode_opcode.mbtrain_valvref_start_req => 
//          cross_msg_subcode_opcode.mbtrain_valvref_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_valvref_end_req => 
//          cross_msg_subcode_opcode.mbtrain_valvref_end_resp);

//       // MBTRAIN DATAVREF sequence
//       bins mbtrain_datavref_seq = 
//         (cross_msg_subcode_opcode.mbtrain_datavref_start_req => 
//          cross_msg_subcode_opcode.mbtrain_datavref_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_datavref_end_req => 
//          cross_msg_subcode_opcode.mbtrain_datavref_end_resp);

//       // MBTRAIN SPEEDIDLE sequence
//       bins mbtrain_speedidle_seq = 
//         (cross_msg_subcode_opcode.mbtrain_speedidle_done_req => 
//          cross_msg_subcode_opcode.mbtrain_speedidle_done_resp);

//       // MBTRAIN TXSELFCAL sequence
//       bins mbtrain_txselfcal_seq = 
//         (cross_msg_subcode_opcode.mbtrain_txselfcal_done_req => 
//          cross_msg_subcode_opcode.mbtrain_txselfcal_done_resp);

//       // MBTRAIN RXCLKCAL sequence
//       bins mbtrain_rxclkcal_seq = 
//         (cross_msg_subcode_opcode.mbtrain_rxclkcal_start_req => 
//          cross_msg_subcode_opcode.mbtrain_rxclkcal_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_rxclkcal_done_req => 
//          cross_msg_subcode_opcode.mbtrain_rxclkcal_done_resp);

//       // MBTRAIN VALTRAINCENTER sequence
//       bins mbtrain_valtraincenter_seq = 
//         (cross_msg_subcode_opcode.mbtrain_valtraincenter_start_req => 
//          cross_msg_subcode_opcode.mbtrain_valtraincenter_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_valtraincenter_done_req => 
//          cross_msg_subcode_opcode.mbtrain_valtraincenter_done_resp);

//       // MBTRAIN VALTRAINVREF sequence
//       bins mbtrain_valtrainvref_seq = 
//         (cross_msg_subcode_opcode.mbtrain_valtrainvref_start_req => 
//          cross_msg_subcode_opcode.mbtrain_valtrainvref_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_valtrainvref_done_req => 
//          cross_msg_subcode_opcode.mbtrain_valtrainvref_done_resp);

//       // MBTRAIN DATATRAINCENTER1 sequence
//       bins mbtrain_datatraincenter1_seq = 
//         (cross_msg_subcode_opcode.mbtrain_datatraincenter1_start_req => 
//          cross_msg_subcode_opcode.mbtrain_datatraincenter1_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_datatraincenter1_end_req => 
//          cross_msg_subcode_opcode.mbtrain_datatraincenter1_end_resp);

//       // MBTRAIN DATATRAINVREF sequence
//       bins mbtrain_datatrainvref_seq = 
//         (cross_msg_subcode_opcode.mbtrain_datatrainvref_start_req => 
//          cross_msg_subcode_opcode.mbtrain_datatrainvref_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_datatrainvref_end_req => 
//          cross_msg_subcode_opcode.mbtrain_datatrainvref_end_resp);

//       // MBTRAIN RXDESKEW sequence
//       bins mbtrain_rxdeskew_seq = 
//         (cross_msg_subcode_opcode.mbtrain_rxdeskew_start_req => 
//          cross_msg_subcode_opcode.mbtrain_rxdeskew_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_rxdeskew_end_req => 
//          cross_msg_subcode_opcode.mbtrain_rxdeskew_end_resp);

//       // MBTRAIN DATATRAINCENTER2 sequence
//       bins mbtrain_datatraincenter2_seq = 
//         (cross_msg_subcode_opcode.mbtrain_datatraincenter2_start_req => 
//          cross_msg_subcode_opcode.mbtrain_datatraincenter2_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_datatraincenter2_end_req => 
//          cross_msg_subcode_opcode.mbtrain_datatraincenter2_end_resp);

//       // MBTRAIN LINKSPEED sequence
//       bins mbtrain_linkspeed_seq = 
//         (cross_msg_subcode_opcode.mbtrain_linkspeed_start_req => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_done_req => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_done_resp);

//       // MBTRAIN LINKSPEED error sequence
//       bins mbtrain_linkspeed_error_seq = 
//         (cross_msg_subcode_opcode.mbtrain_linkspeed_start_req => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_error_req => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_error_resp);

//       // MBTRAIN LINKSPEED exit to repair sequence
//       bins mbtrain_linkspeed_exit_to_repair_seq = 
//         (cross_msg_subcode_opcode.mbtrain_linkspeed_start_req => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_exit_to_repair_req => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_exit_to_repair_resp);

//       // MBTRAIN LINKSPEED exit to speed degrade sequence
//       bins mbtrain_linkspeed_exit_to_degrade_seq = 
//         (cross_msg_subcode_opcode.mbtrain_linkspeed_start_req => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_exit_to_speed_degrade_req => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_exit_to_speed_degrade_resp);

//       // MBTRAIN LINKSPEED exit to phy retrain sequence
//       bins mbtrain_linkspeed_exit_to_phy_retrain_seq = 
//         (cross_msg_subcode_opcode.mbtrain_linkspeed_start_req => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_start_resp => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_exit_to_phy_retrain_req => 
//          cross_msg_subcode_opcode.mbtrain_linkspeed_exit_to_phy_retrain_resp);

//       // MBTRAIN REPAIR sequence
//       bins mbtrain_repair_seq = 
//         (cross_msg_subcode_opcode.mbtrain_repair_init_req => 
//          cross_msg_subcode_opcode.mbtrain_repair_init_resp => 
//          cross_msg_subcode_opcode.mbtrain_repair_apply_repair_req => 
//          cross_msg_subcode_opcode.mbtrain_repair_apply_repair_resp => 
//          cross_msg_subcode_opcode.mbtrain_repair_end_req => 
//          cross_msg_subcode_opcode.mbtrain_repair_end_resp);

//       // MBTRAIN REPAIR degrade sequence
//       bins mbtrain_repair_degrade_seq = 
//         (cross_msg_subcode_opcode.mbtrain_repair_init_req => 
//          cross_msg_subcode_opcode.mbtrain_repair_init_resp => 
//          cross_msg_subcode_opcode.mbtrain_repair_apply_degrade_req => 
//          cross_msg_subcode_opcode.mbtrain_repair_apply_degrade_resp => 
//          cross_msg_subcode_opcode.mbtrain_repair_end_req => 
//          cross_msg_subcode_opcode.mbtrain_repair_end_resp);

//       // TRAINERROR sequence
//       bins trainerror_seq = 
//         (cross_msg_subcode_opcode.trainerror_entry_req => 
//          cross_msg_subcode_opcode.trainerror_entry_resp);

//       // LinkMgmt RDI Retrain sequence
//       bins linkmgmt_rdi_retrain_seq = 
//         (cross_msg_subcode_opcode.linkmgmt_rdi_req_retrain => 
//          cross_msg_subcode_opcode.linkmgmt_rdi_rsp_retrain);

//       // PHYRETRAIN sequence
//       bins phyretrain_seq = 
//         (cross_msg_subcode_opcode.phyretrain_retrain_start_req => 
//          cross_msg_subcode_opcode.phyretrain_retrain_start_resp);
//     }
  endgroup

  // Constructor: new
  // Initializes the coverage_collector and creates covergroup instance.
  function new(string name = "coverage_collector", uvm_component parent = null);
    super.new(name, parent);
    side_band_coverages = new();
  endfunction

  // Build Phase: Create analysis port and FIFO
  // Creates the TLM analysis port and FIFO for receiving transactions.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    Coverage_Collector_port = new("Coverage_Collector_port", this);
    cov_fifo = new("cov_fifo", this);
  endfunction

  // Connect Phase: Link export to FIFO
  // Connects the analysis export to the FIFO's analysis export for transaction flow.
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    Coverage_Collector_port.connect(cov_fifo.analysis_export);
  endfunction

  // Run Phase: Sample coverage
  // Continuously retrieves transactions from the FIFO and samples the covergroup.
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      cov_fifo.get(tr); // Get transaction from FIFO
      side_band_coverages.sample();
    end
  endtask

  // Function: get_cumulative_coverage
  // Returns the cumulative coverage (real value) for all instances of the covergroup.
  // Useful for checking overall coverage across all instances.
  function real get_cumulative_coverage();
    return side_band_coverages.get_coverage();
  endfunction

  // Function: get_instance_coverage
  // Returns the instance-specific coverage (real value) for this coverage_collector instance.
  // Useful for debugging coverage for a specific instance.
  function real get_instance_coverage();
    return side_band_coverages.get_inst_coverage();
  endfunction

  // Function: get_overall_coverage
  // Returns the overall coverage (0 to 100) for all coverage groups in the design.
  // Uses SystemVerilog's $get_coverage system function.
  function real get_overall_coverage();
    return $get_coverage();
  endfunction

  // Function: load_coverage_db
  // Loads cumulative coverage information from a specified file.
  // Uses SystemVerilog's $load_coverage_db system function.
  // Parameter: filename - Path to the coverage database file.
  function void load_coverage_db(string filename);
    $load_coverage_db(filename);
  endfunction

endclass