import pack1::*;
import uvm_pkg::*;

class sideband_monitor extends  uvm_monitor;
	`uvm_component_utils(sideband_monitor)

	localparam REQ = 5;
	localparam RESP = 10;

    virtual sideband_interface vif_monitor;
    sideband_sequence_item old_trans, new_trans;
    sideband_sequence_item input_trans, output_trans;
    sideband_sequence_item input_req, output_resp;

    sideband_sequence_item data_in_req[$], data_in_resp[$]; 
    sideband_sequence_item data_out_req[$], data_out_resp[$];
    sideband_sequence_item data_packet_in[$], data_packet_out[$];
    sideband_sequence_item data_in_pattern[$], data_out_pattern[$];

    logic [63:0] message_with_data_in[string];  
    logic [63:0] message_with_data_out[string];      

    uvm_analysis_port #(sideband_sequence_item) my_analysis_port;
    int number_of_patterns;
    int pattern_finished;
    string successful_checks[$];
    bit sbinit_done;
    bit mbinit_done;
    int correct_count;
    int error_count;
	/*------------------------------------------------------------------------------
	--new  
	------------------------------------------------------------------------------*/
	function  new(string name="sideband_monitor",uvm_component parent=null);
			super.new(name,parent);
	endfunction : new
	/*------------------------------------------------------------------------------
	--build phase   
	------------------------------------------------------------------------------*/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual sideband_interface)::get(this, "", "my_vif",vif_monitor ))
			`uvm_fatal(get_full_name,"ERROR");
		my_analysis_port=new("my_analysis_port",this);
	endfunction : build_phase
	/*------------------------------------------------------------------------------
	--run phase   
	------------------------------------------------------------------------------*/
	task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_full_name(), "Monitor run phase started", UVM_MEDIUM)

        forever begin
        	// Create new transaction object
	    	input_trans = sideband_sequence_item::type_id::create("input_trans", this);
	    	output_trans = sideband_sequence_item::type_id::create("output_trans", this);
	    	
        	fork
        		begin
        			forever begin
        				// Handle recieving meessages to dut
	        			@(posedge vif_monitor.de_ser_done);
	        			`uvm_info(get_type_name(), "De_ser_done is hgih now", UVM_LOW)
	        			// wait_for_bus_change(vif_monitor.deser_data, vif_monitor.de_ser_done);
	        			capture_transaction(vif_monitor.deser_data, input_trans);
	        			`uvm_info(get_type_name(), $sformatf("Deser_data %0h",input_trans.data) , UVM_LOW)

	        			// Store Message 
	        			store_message(input_trans, 1);
	        			
	        			// Check if this is a message that should be followed by data
	                    if (is_message_with_data(input_trans)) begin
	                        sideband_sequence_item message_with_data_header_in;
	                        message_with_data_header_in = input_trans;
	                        
	                        // Wait and capture the next packet as data
	                        @(posedge vif_monitor.de_ser_done);
	                        capture_transaction(vif_monitor.deser_data, input_trans);
	                        // Store Data 
	                        store_data(message_with_data_header_in, input_trans, 1); // 1 for input direction
	                    end
        			end
        		end
        		begin
        			forever begin
        				// Handle sending meessages from dut
	        			@(posedge vif_monitor.clk_ser_en);
	        			`uvm_info(get_type_name(), "Clk_ser_en is hgih now", UVM_LOW)
	        			// wait_for_bus_change_resp(vif_monitor.fifo_data_out, vif_monitor.clk_ser_en);
	        			capture_transaction(vif_monitor.fifo_data_out, output_trans);
	        			`uvm_info(get_type_name(), $sformatf("Fifo_out_data %0h",output_trans.data) , UVM_LOW)

	        			// Store Message 
	        			store_message(output_trans, 0);

	        			// Check if this is a message that should be followed by data
	                    if (is_message_with_data(output_trans)) begin
	                        sideband_sequence_item message_with_data_header_out;
	                        message_with_data_header_out = output_trans;
	                        
	                        // Wait and capture the next packet as data
	                        @(posedge vif_monitor.clk_ser_en);
	                        capture_transaction(vif_monitor.fifo_data_out, output_trans);
	                        // Store Data 
	                        store_data(message_with_data_header_out, output_trans, 0); // 0 for output direction
	                    end
        			end
        		end
        		begin 
        			compare_req_resp(data_in_req,data_out_resp,"RX:REQ ---> TX:RESP");
				end
				begin 

        			compare_req_resp(data_out_req,data_in_resp,"TX:REQ ---> RX:RESP");
				end
        	join
            // @(posedge vif_monitor.clk_ser_en);
            // detect_and_compare_transactions();
        end
    endtask

    /*------------------------------------------------------------------------------
	-- Storage Tasks 
	------------------------------------------------------------------------------*/
    // Function to check if a message should be followed by data
    function bit is_message_with_data(sideband_sequence_item trans);
        // Check opcode for message with data (example: opcode 5'b11011)
        if (trans.opcode == 5'b11011) begin
            return 1;
        end
        else begin
        	return 0;
        end
       
    endfunction

    // Task to store messages in the queue
    task store_message(input sideband_sequence_item header_trans, input bit is_input);
        if (is_input) begin
            if (header_trans.data == {32{2'b10}} || header_trans.msg_code == 8'h91) begin
                data_in_pattern.push_back(header_trans);
            end
            else if (header_trans.msg_code[3:0] == REQ) begin
                data_in_req.push_back(header_trans);
            end
            else if (header_trans.msg_code[3:0] == RESP) begin
                data_in_resp.push_back(header_trans);
            end
        end
        else begin
            if (header_trans.data == {32{2'b10}} || header_trans.msg_code == 8'h91) begin
                data_out_pattern.push_back(header_trans);
            end
            else if (header_trans.msg_code[3:0] == REQ) begin
                data_out_req.push_back(header_trans);
            end
            else if (header_trans.msg_code[3:0] == RESP) begin
                data_out_resp.push_back(header_trans);
            end
        end
    endtask

    // Task to store data in the appropriate associative array
    task store_data(input sideband_sequence_item header_trans, input sideband_sequence_item data_trans, input bit is_input);
        string msg_name;
        logic[63:0] data;

        msg_name = get_message_name(header_trans);
        data = data_trans.data;

        if (is_input) begin
            message_with_data_in[msg_name] = data;
        end
        else begin
            message_with_data_out[msg_name] = data;
        end
    endtask


    /*------------------------------------------------------------------------------
	-- Capture Tasks  
	------------------------------------------------------------------------------*/
    task capture_transaction(
	    input bit [63:0] packet,               // Packet input
	    output sideband_sequence_item trans    // Transaction output
	);
	    // Create new transaction object
	    trans = sideband_sequence_item::type_id::create("trans", this);
	    
	    // Capture all fields from interface
	    trans.src_id      = packet[31:29];
	    trans.dst_id      = packet[58:56];
	    trans.msg_code    = packet[21:14];
	    trans.msg_subcode = packet[39:32];
	    trans.opcode      = packet[4:0];
	    trans.dp          = packet[63];
	    trans.cp          = packet[62];
	    trans.msg_info    = packet[55:40];
	    trans.data        = packet;

	endtask

	/*------------------------------------------------------------------------------
	-- Compare Tasks  
	------------------------------------------------------------------------------*/
	task compare_req_resp(ref sideband_sequence_item data_in[$], 
                          ref sideband_sequence_item data_out[$],
                          input string order);
	    sideband_sequence_item input_req, output_resp;
	    
	    if (data_in.size() > 0 && data_out.size() > 0) begin
	        input_req = data_in[0];
	        output_resp = data_out[0];
	        
	        if (input_req.msg_code == 8'h91 && output_resp.msg_code == 8'h91) begin
	        	`uvm_info(get_full_name(), 
	                     $sformatf("\n  %s  \n  Match found: REQ %s -> RESP %s",
                     		    order,
                                get_message_name(input_req),
                                get_message_name(output_resp)), 
	                     		UVM_MEDIUM)

	        	data_in.delete(0);
            	data_out.delete(0);
	            
	        end
	        else if (output_resp.msg_code[8:4] !== input_req.msg_code[8:4] || 
	            output_resp.msg_code[3:0] !== (input_req.msg_code[3:0]<<1) || 
	            output_resp.msg_subcode !== input_req.msg_subcode) begin
	            
	            // Detailed mismatch reporting
	            string msg = "  Mismatch detected:  ";
	            
	            if (output_resp.msg_code[8:4] != input_req.msg_code[8:4]) begin
	                msg = {msg, $sformatf("\n  MsgCode[8:4] mismatch (REQ: 0x%0h, RESP: 0x%0h)", 
	                          input_req.msg_code[8:4], output_resp.msg_code[8:4])};
	            end
	            
	            if (output_resp.msg_code[3:0] != (input_req.msg_code[3:0]<<1)) begin
	                msg = {msg, $sformatf("\n  MsgCode[3:0] mismatch (REQ: 0x%0h, Expected RESP: 0x%0h, Actual: 0x%0h)", 
	                          input_req.msg_code[3:0], (input_req.msg_code[3:0]<<1), output_resp.msg_code[3:0])};
	            end
	            
	            if (output_resp.msg_subcode != input_req.msg_subcode) begin
	                msg = {msg, $sformatf("\n  Subcode mismatch (REQ: 0x%0h, RESP: 0x%0h) (Input data %0h , Output data %0h)", 
	                          input_req.msg_subcode, output_resp.msg_subcode, input_req.data, output_resp.data)};
	            end
	            
	            `uvm_error(get_full_name(), 
	                      $sformatf("\n  %s  \n%s\n  REQ:  %s  (Code:0x%02h, SubCode:0x%02h)\n  RESP: %s (Code:0x%02h, SubCode:0x%02h)",
	                      	        order,
	                                msg,
	                                get_message_name(input_req), 
	                                input_req.msg_code, 
	                                input_req.msg_subcode,
	                                get_message_name(output_resp),
	                                output_resp.msg_code,
	                                output_resp.msg_subcode))

	        	data_in.delete(0);
            	data_out.delete(0);
	            
	        end
	        else begin
	            	`uvm_info(get_full_name(), 
	                     $sformatf("\n  %s  \n  REQ:  %s  (Code:0x%02h, SubCode:0x%02h)\n  RESP: %s (Code:0x%02h, SubCode:0x%02h) (Input data %0h , Output data %0h)",
	                     	        order,
	                                get_message_name(input_req), 
	                                input_req.msg_code, 
	                                input_req.msg_subcode,
	                                get_message_name(output_resp),
	                                output_resp.msg_code,
	                                output_resp.msg_subcode, 
				                    input_req.data,
				                    output_resp.data),
	                     UVM_MEDIUM)

		            data_in.delete(0);
	            	data_out.delete(0);

	        end
	    end
	endtask

	/*------------------------------------------------------------------------------
	-- Message Name Tasks  
	------------------------------------------------------------------------------*/
	function string get_message_name(input sideband_sequence_item trans);
	    if (trans.data == {32{2'b10}}) begin
	        return "PATTERN";
	    end
	    else begin
	        case (trans.msg_code)
	        	8'h85: begin
	                case (trans.msg_subcode)
	                    8'h01: return "START_TX_INIT_POINT_TEST_REQ";
	                    8'h02: return "LFSR_CLEAR_ERROR_REQ";
	                    8'h03: return "TX_INIT_POINT_TEST_RESULT_REQ";
	                    8'h04: return "END_TX_INIT_POINT_TEST_REQ";
	                    8'h05: return "START_TX_INIT_EYE_SWEEP_REQ";
	                    8'h06: return "END_TX_INIT_EYE_SWEEP_REQ";
	                    8'h07: return "START_RX_INIT_POINT_TEST_REQ";
	                    8'h08: return "RX_INIT_TX_COUNT_DONE_REQ";
	                    8'h09: return "END_RX_INIT_POINT_TEST_REQ";
	                    8'h0A: return "START_RX_INIT_EYE_SWEEP_REQ";
	                    8'h0B: return "RX_INIT_RESULT_REQ";
	                    8'h0C: return "RX_INIT_SWEEP_DONE_WITH_RESULTS_REQ";
	                    8'h0C: return "END_RX_INIT_EYE_SWEEP_REQ";
				        default: return "UNKNOWN_TEST_REQ";
	                endcase
	            end 
	            8'h8A: begin
				    case (trans.msg_subcode)
				        8'h01: return "START_TX_INIT_POINT_TEST_RESP";
				        8'h02: return "LFSR_CLEAR_ERROR_RESP";
				        8'h03: return "TX_INIT_POINT_TEST_RESULT_RESP";
				        8'h04: return "END_TX_INIT_POINT_TEST_RESP";
				        8'h05: return "START_TX_INIT_EYE_SWEEP_RESP";
				        8'h06: return "END_TX_INIT_EYE_SWEEP_RESP";
				        8'h07: return "START_RX_INIT_POINT_TEST_RESP";
				        8'h08: return "RX_INIT_TX_COUNT_DONE_RESP";
				        8'h09: return "END_RX_INIT_POINT_TEST_RESP";
				        8'h0A: return "START_RX_INIT_EYE_SWEEP_RESP";
				        8'h0B: return "RX_INIT_RESULT_RESP";
				        8'h0C: return "RX_INIT_SWEEP_DONE_WITH_RESULTS_RESP";
				        8'h0D: return "END_RX_INIT_EYE_SWEEP_RESP";
				        default: return "UNKNOWN_TEST_RESP";
				    endcase
				end 
	            8'h91: return "SBINIT_OUT_OF_RESET";
	            8'h95: return "SBINIT_DONE_REQ";
	            8'h9A: return "SBINIT_DONE_RESP";
	            8'hA5: begin
	                case (trans.msg_subcode)
	                    8'h00: return "MBINIT_PARAM_CONFIG_REQ";
				        8'h02: return "MBINIT_CAL_DONE_REQ";
				        8'h03: return "MBINIT_REPAIRCLK_INIT_REQ";
				        8'h04: return "MBINIT_REPAIRCLK_RESULT_REQ";
				        8'h08: return "MBINIT_REPAIRCLK_DONE_REQ";
				        8'h09: return "MBINIT_REPAIRVAL_INIT_REQ";
				        8'h0A: return "MBINIT_REPAIRVAL_RESULT_REQ";
				        8'h0C: return "MBINIT_REPAIRVAL_DONE_REQ";
				        8'h0D: return "MBINIT_REVERSALMB_INIT_REQ";
				        8'h0E: return "MBINIT_REVERSALMB_CLEAR_ERROR_REQ";
				        8'h0F: return "MBINIT_REVERSALMB_RESULT_REQ";
				        8'h10: return "MBINIT_REVERSALMB_DONE_REQ";
				        8'h11: return "MBINIT_REPAIRMB_START_REQ";
				        8'h13: return "MBINIT_REPAIRMB_END_REQ";
				        8'h14: return "MBINIT_REPAIRMB_APPLY_DEGRADE_REQ";
				        default: return "UNKNOWN_MBINIT_REQ";
	                endcase
	            end 
	            8'hAA: begin
	                case (trans.msg_subcode)
	                    8'h00: return "MBINIT_PARAM_CONFIG_RESP";
				        8'h02: return "MBINIT_CAL_DONE_RESP";
				        8'h03: return "MBINIT_REPAIRCLK_INIT_RESP";
				        8'h04: return "MBINIT_REPAIRCLK_RESULT_RESP";
				        8'h08: return "MBINIT_REPAIRCLK_DONE_RESP";
				        8'h09: return "MBINIT_REPAIRVAL_INIT_RESP";
				        8'h0A: return "MBINIT_REPAIRVAL_RESULT_RESP";
				        8'h0C: return "MBINIT_REPAIRVAL_DONE_RESP";
				        8'h0D: return "MBINIT_REVERSALMB_INIT_RESP";
				        8'h0E: return "MBINIT_REVERSALMB_CLEAR_ERROR_RESP";
				        8'h0F: return "MBINIT_REVERSALMB_RESULT_RESP";
				        8'h10: return "MBINIT_REVERSALMB_DONE_RESP";
				        8'h11: return "MBINIT_REPAIRMB_START_RESP";
				        8'h13: return "MBINIT_REPAIRMB_END_RESP";
				        8'h14: return "MBINIT_REPAIRMB_APPLY_DEGRADE_RESP";
				        default: return "UNKNOWN_MBINIT_RESP";
	                endcase
	            end
	            8'hB5: begin
				    case (trans.msg_subcode)
				        8'h00: return "MBTRAIN_VALVREF_START_REQ";
				        8'h01: return "MBTRAIN_VALVREF_END_REQ";
				        8'h02: return "MBTRAIN_DATAVREF_START_REQ";
				        8'h03: return "MBTRAIN_DATAVREF_END_REQ";
				        8'h04: return "MBTRAIN_SPEEDIDLE_DONE_REQ";
				        8'h05: return "MBTRAIN_TXSELFCAL_DONE_REQ";
				        8'h06: return "MBTRAIN_RXCLKCAL_START_REQ";
				        8'h07: return "MBTRAIN_RXCLKCAL_DONE_REQ";
				        8'h08: return "MBTRAIN_VALTRAINCENTER_START_REQ";
				        8'h09: return "MBTRAIN_VALTRAINCENTER_DONE_REQ";
				        8'h0A: return "MBTRAIN_VALTRAINVREF_START_REQ";
				        8'h0B: return "MBTRAIN_VALTRAINVREF_DONE_REQ";
				        8'h0C: return "MBTRAIN_DATATRAINCENTER1_START_REQ";
				        8'h0D: return "MBTRAIN_DATATRAINCENTER1_END_REQ";
				        8'h0E: return "MBTRAIN_DATATRAINVREF_START_REQ";
				        8'h10: return "MBTRAIN_DATATRAINVREF_END_REQ";
				        8'h11: return "MBTRAIN_RXDESKEW_START_REQ";
				        8'h12: return "MBTRAIN_RXDESKEW_END_REQ";
				        8'h13: return "MBTRAIN_DATATRAINCENTER2_START_REQ";
				        8'h14: return "MBTRAIN_DATATRAINCENTER2_END_REQ";
				        8'h15: return "MBTRAIN_LINKSPEED_START_REQ";
				        8'h16: return "MBTRAIN_LINKSPEED_ERROR_REQ";
				        8'h17: return "MBTRAIN_LINKSPEED_EXIT_TO_REPAIR_REQ";
				        8'h18: return "MBTRAIN_LINKSPEED_EXIT_TO_SPEED_DEGRADE_REQ";
				        8'h19: return "MBTRAIN_LINKSPEED_DONE_REQ";
				        8'h1A: return "MBTRAIN_LINKSPEED_MULTI_MODULE_DISABLE_REQ";
				        8'h1B: return "MBTRAIN_REPAIR_INIT_REQ";
				        8'h1C: return "MBTRAIN_REPAIR_APPLY_REPAIR_REQ";
				        8'h1D: return "MBTRAIN_REPAIR_END_REQ";
				        8'h1E: return "MBTRAIN_REPAIR_APPLY_DEGRADE_REQ";
				        8'h1F: return "MBTRAIN_LINKSPEED_EXIT_TO_PHY_RETRAIN_REQ";
				        default: return "UNKNOWN_MBTRAIN_REQ";
				    endcase
				end
				8'hBA: begin
				    case (trans.msg_subcode)
				        8'h00: return "MBTRAIN_VALVREF_START_RESP";
				        8'h01: return "MBTRAIN_VALVREF_END_RESP";
				        8'h02: return "MBTRAIN_DATAVREF_START_RESP";
				        8'h03: return "MBTRAIN_DATAVREF_END_RESP";
				        8'h04: return "MBTRAIN_SPEEDIDLE_DONE_RESP";
				        8'h05: return "MBTRAIN_TXSELFCAL_DONE_RESP";
				        8'h06: return "MBTRAIN_RXCLKCAL_START_RESP";
				        8'h07: return "MBTRAIN_RXCLKCAL_DONE_RESP";
				        8'h08: return "MBTRAIN_VALTRAINCENTER_START_RESP";
				        8'h09: return "MBTRAIN_VALTRAINCENTER_DONE_RESP";
				        8'h0A: return "MBTRAIN_VALTRAINVREF_START_RESP";
				        8'h0B: return "MBTRAIN_VALTRAINVREF_DONE_RESP";
				        8'h0C: return "MBTRAIN_DATATRAINCENTER1_START_RESP";
				        8'h0D: return "MBTRAIN_DATATRAINCENTER1_END_RESP";
				        8'h0E: return "MBTRAIN_DATATRAINVREF_START_RESP";
				        8'h10: return "MBTRAIN_DATATRAINVREF_END_RESP";
				        8'h11: return "MBTRAIN_RXDESKEW_START_RESP";
				        8'h12: return "MBTRAIN_RXDESKEW_END_RESP";
				        8'h13: return "MBTRAIN_DATATRAINCENTER2_START_RESP";
				        8'h14: return "MBTRAIN_DATATRAINCENTER2_END_RESP";
				        8'h15: return "MBTRAIN_LINKSPEED_START_RESP";
				        8'h16: return "MBTRAIN_LINKSPEED_ERROR_RESP";
				        8'h17: return "MBTRAIN_LINKSPEED_EXIT_TO_REPAIR_RESP";
				        8'h18: return "MBTRAIN_LINKSPEED_EXIT_TO_SPEED_DEGRADE_RESP";
				        8'h19: return "MBTRAIN_LINKSPEED_DONE_RESP";
				        8'h1A: return "MBTRAIN_LINKSPEED_MULTI_MODULE_DISABLE_RESP";
				        8'h1B: return "MBTRAIN_REPAIR_INIT_RESP";
				        8'h1C: return "MBTRAIN_REPAIR_APPLY_REPAIR_RESP";
				        8'h1D: return "MBTRAIN_REPAIR_END_RESP";
				        8'h1E: return "MBTRAIN_REPAIR_APPLY_DEGRADE_RESP";
				        8'h1F: return "MBTRAIN_LINKSPEED_EXIT_TO_PHY_RETRAIN_RESP";
				        default: return "UNKNOWN_MBTRAIN_RESP";
				    endcase
				end
				8'hD5: begin
				    case (trans.msg_subcode)
				        8'h00: return "RECAL_TRACK_PATTERN_INIT_REQ";
				        8'h01: return "RECAL_TRACK_PATTERN_DONE_REQ";
				        default: return "UNKNOWN_RECAL_REQ";
				    endcase
				end
				8'hDA: begin
				    case (trans.msg_subcode)
				        8'h00: return "RECAL_TRACK_PATTERN_INIT_RESP";
				        8'h01: return "RECAL_TRACK_PATTERN_DONE_RESP";
				        default: return "UNKNOWN_RECAL_RESP";
				    endcase
				end
				8'hE5: begin
				    case (trans.msg_subcode)
				        8'h00: return "TRAINERROR_ENTRY_REQ";
				        default: return "UNKNOWN_TRAINERROR_REQ";
				    endcase
				end
				8'hEA: begin
				    case (trans.msg_subcode)
				        8'h00: return "TRAINERROR_ENTRY_RESP";
				        default: return "UNKNOWN_TRAINERROR_RESP";
				    endcase
				end
				8'h01: begin
				    case (trans.msg_subcode)
				        8'h09: return "LINKMGMT_RDI_RETRAIN_REQ";
				        default: return "UNKNOWN_LINKMGMT_REQ";
				    endcase
				end
				8'h02: begin
				    case (trans.msg_subcode)
				        8'h0B: return "LINKMGMT_RDI_RETRAIN_RESP";
				        default: return "UNKNOWN_LINKMGMT_RESP";
				    endcase
				end
				8'hC5: begin
				    case (trans.msg_subcode)
				        8'h01: return "PHYRETRAIN_START_REQ";
				        default: return "UNKNOWN_PHYRETRAIN_REQ";
				    endcase
				end
				8'hCA: begin
				    case (trans.msg_subcode)
				        8'h01: return "PHYRETRAIN_START_RESP";
				        default: return "UNKNOWN_PHYRETRAIN_RESP";
				    endcase
				end
	            default: return "DATA_PACKET";
	        endcase
	    end    
	endfunction

	/*------------------------------------------------------------------------------
	-- Report Phase  
	------------------------------------------------------------------------------*/
	function void report_phase(uvm_phase phase);
	    super.report_phase(phase);
	    
	    `uvm_info(get_type_name(), "=== Transaction Report ===", UVM_MEDIUM);

	    // Print pattern queues
	    if (data_in_pattern.size() > 0)
	        print_queue(data_in_pattern, "Input Pattern Transactions");
	    if (data_out_pattern.size() > 0)
	        print_queue(data_out_pattern, "Output Pattern Transactions");
	    
	    // Print handsahke queues 
	    print_compare_queues(data_in_resp, data_out_req, "REQ Transactions");
	    print_compare_queues(data_in_req, data_out_resp, "RESP Transactions");

	    print_assoc_array("Input Messages", message_with_data_in);
    	print_assoc_array("Output Messages", message_with_data_out);
	    
	endfunction

	// Print two related queues (req vs resp)
	task print_compare_queues(
	    ref sideband_sequence_item in_queue[$],
	    ref sideband_sequence_item out_queue[$],
	    input string label
	);
	    int max_count = (in_queue.size() > out_queue.size()) ? in_queue.size() : out_queue.size();
	    
	    `uvm_info("SB MONITOR", $sformatf("=================== %s (IN: %0d vs OUT: %0d) ===================", 
	              label, in_queue.size(), out_queue.size()), UVM_MEDIUM)
	    
	    for (int i = 0; i < max_count; i++) begin
	        string in_str = (i < in_queue.size()) ? 
	                       $sformatf("IN[%0d]: %s", i, get_message_name(in_queue[i])) :
	                       "IN[ ]: <none>";
	                       
	        string out_str = (i < out_queue.size()) ? 
	                        $sformatf("OUT[%0d]: %s", i, get_message_name(out_queue[i])) :
	                        "OUT[ ]: <none>";
	        
	        `uvm_info("SB MONITOR", $sformatf("%-40s|%s", in_str, out_str), UVM_MEDIUM)
	    end
	    
	    // Clear queues after printing
	    in_queue.delete();
	    out_queue.delete();
	endtask

	// Print a single queue (for pattern queues)
	task print_queue(
	    ref sideband_sequence_item queue[$],
	    input string label
	);
	    `uvm_info("SB MONITOR", $sformatf("=================== %s (%0d items) ===================", label, queue.size()), UVM_MEDIUM)
	    foreach (queue[i]) begin
	        `uvm_info(get_type_name(), 
	                  $sformatf("%0d: %s", i, get_message_name(queue[i])), 
	                  UVM_MEDIUM)
	    end
	    queue.delete();
	endtask

	task print_assoc_array(input string name, ref logic [63:0] assoc_array[string]);
	    string key;
	    $display("Contents of associative array: %s", name);
	    foreach (assoc_array[key]) begin
	        $display("Message: %s, Data: %h", key, assoc_array[key]);
	    end
	endtask

endclass : sideband_monitor

	// // Task to wait for change on bus
	// task wait_for_bus_change(input [63:0] deser_data, input bit evnt);
	//     bit [63:0] initial_data;
	//     bit bus_changed;
	    
	//     // Capture initial bus state
	//     initial_data = deser_data;
	//     bus_changed = 0;
	    
	    
	//     // Monitoring loop
	//     while (!bus_changed) begin
	//         @(posedge vif_monitor.clk);

	//         // Check for data change 
	//         if (vif_monitor.deser_data != initial_data) begin
	//             bus_changed = 1;
	//             `uvm_info(get_full_name(),$sformatf("Bus changed (0x%0h -> 0x%0h)", initial_data, vif_monitor.deser_data),UVM_MEDIUM);
	//         end
	//     end
	   
	// endtask

	// // Task to wait for change on bus
	// task wait_for_bus_change_resp(input [63:0] fifo_data, input bit evnt);
	//     bit [63:0] initial_data;
	//     bit bus_changed;
	    
	//     // Capture initial bus state
	//     initial_data = fifo_data;
	//     bus_changed = 0;
	    
	//     forever begin
	//         @(posedge vif_monitor.clk);

	//         // Check for data change 
	//         if (vif_monitor.fifo_data_out != initial_data) begin
	//             bus_changed = 1;
	//             `uvm_info(get_full_name(),$sformatf("Bus changed (0x%0h -> 0x%0h)", initial_data, vif_monitor.fifo_data_out),UVM_MEDIUM);
	//         end
	//     end
	   
	// endtask

	    //------------------------------------------------------------------------------

    // // Main detection and comparison task
    // task detect_and_compare_transactions();
    //     pattern_detection(vif_monitor.fifo_data_out, number_of_patterns, pattern_finished);       
    //     if (pattern_finished) begin
    //         sb_out_of_reset_detection();
    //         sb_done_handshake();
    //         // forever begin
    //         // 	if (mbinit_done) begin
    //         // 		break;
    //         // 	end
    //         // 	else begin
    //         // 		mbinit_handshake();
    //         // 	end
    //         // end       
    //     end
    //     else begin 
    //         `uvm_info(get_full_name(), $sformatf("Sending Patterns (%0d detected)", number_of_patterns), UVM_MEDIUM);
    //     end
    // endtask

    // /*------------------------------------------------------------------------------
	// -- Pattern Detection  
	// ------------------------------------------------------------------------------*/
    // task pattern_detection(input [63:0] data, output int count, output bit finished);
    //     static int pattern_count; 
    //     if (data == {32{2'b10}}) begin
    //         pattern_count++;
    //         finished = 0;
    //     end
    //     else begin
    //         finished = 1;
    //     end
    //     count = pattern_count;
    // endtask

    // /*------------------------------------------------------------------------------
	// -- SBINIT State Detection  
	// ------------------------------------------------------------------------------*/
    // // SBINIT out of reset detection task
	// task sb_out_of_reset_detection();
	// 	capture_transaction();
	// 	check_encoding(old_trans);
	//     if (!sbinit_done) begin
	//     	if (old_trans.msg_code == 8'h91) begin
	//     		successful_checks.push_back(old_trans.get_message_name());
	//     		`uvm_info(get_full_name(), 
	//     			$sformatf("Detected message type: %s", old_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s handshake successful (REQ_MSG_CODE: 0x%0h)", 
	// 	        	old_trans.get_message_name(), old_trans.msg_code), UVM_MEDIUM);
	//         end
	// 	    else begin
	// 	    	`uvm_error(get_full_name(),
	// 	            $sformatf("\n%s handshake failed! (REQ_MSG_CODE: 0x%0h)", 
	// 	            old_trans.get_message_name(), old_trans.msg_code));
	// 	    end
	//     end
	//     else begin
	//     	return;
	//     end
	    	
	// endtask

	// // Sideband done handshake detection task
	// task sb_done_handshake();
	// 	capture_transaction();
	// 	check_encoding(old_trans);
	// 	check_encoding(new_trans);
	//     if (!sbinit_done) begin
	//     	if (old_trans.msg_code == 8'h95 && new_trans.msg_code == 8'h9A) begin
	// 	    	sbinit_done = 1;
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s handshake successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_trans.msg_code, new_trans.msg_code), UVM_MEDIUM);
	// 	    end
	// 	    else begin
	// 	    	`uvm_error(get_full_name(),
	// 	            $sformatf("\n%s handshake failed! (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h)", 
	// 	            new_trans.get_message_name(), old_trans.msg_code, new_trans.msg_code));
	// 	    end 
	//     end
	//     else begin
	//     	return;
	//     end
	    	
	// endtask

	// /*------------------------------------------------------------------------------
	// -- MBINIT State Detection  
	// ------------------------------------------------------------------------------*/
	// task mbinit_handshake();
	// 	bit[7:0] old_msg_code, new_msg_code;
	// 	bit[7:0] old_sub_code, new_sub_code;
	// 	string message_type;

		
	//     if (!mbinit_done) begin
	//     	capture_transaction(); 
	// 		old_msg_code = new_trans.msg_code;
	// 		old_sub_code = new_trans.msg_subcode;
	// 		check_opcode(new_trans.opcode, message_type);
	// 		check_encoding(new_trans);

	// 		if (message_type == "MESSAGE WITH DATA") begin
	// 			capture_data(1'b1);
	// 			capture_transaction();
	// 			new_msg_code = new_trans.msg_code;
	// 			new_sub_code = new_trans.msg_subcode;
	// 			check_encoding(new_trans);
	// 			capture_data(1'b0);
	// 		end
	// 		else begin
	// 			//wait_for_bus_change();
	// 			old_msg_code = new_trans.msg_code;
	// 			old_sub_code = new_trans.msg_subcode;
	// 			capture_transaction();
	// 			new_msg_code = new_trans.msg_code;
	// 			new_sub_code = new_trans.msg_subcode;
	// 			check_encoding(new_trans);
	// 		end
	//     	/*------------------------------------------------------------------------------
	// 		-- PARAM_CONFIG Handshake  
	// 		------------------------------------------------------------------------------*/
	//     	if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h00 && new_sub_code == 8'h00) begin
	//     		successful_checks.push_back(old_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", old_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	old_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- CAL_DONE	 Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h02 && new_sub_code == 8'h02) begin
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- REPAIRCLK_INIT Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h03 && new_sub_code == 8'h03) begin
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- REPAIRCLK_RESULT Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h04 && new_sub_code == 8'h04) begin
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- REPAIRCLK_DONE Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h08 && new_sub_code == 8'h08) begin
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- REPAIRVAL_INIT Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h09 && new_sub_code == 8'h09) begin
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- REPAIRVAL_RESULT Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h0A && new_sub_code == 8'h0A) begin
	// 	    	mbinit_done = 1;
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- REPAIRVAL_DONE Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h0C && new_sub_code == 8'h0C) begin
	// 	    	mbinit_done = 1;
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- REVERSALMB_INIT Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h0D && new_sub_code == 8'h0D) begin
	// 	    	mbinit_done = 1;
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- REVERSALMB_CLEAR_ERROR Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h0E && new_sub_code == 8'h0E) begin
	// 	    	mbinit_done = 1;
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- REVERSALMB_RESULT Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h0F && new_sub_code == 8'h0F) begin
	// 	    	mbinit_done = 1;
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- REVERSALMB_DONE Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else if (old_msg_code == 8'hA5 && new_msg_code == 8'hAA && old_sub_code == 8'h10 && new_sub_code == 8'h10) begin
	// 	    	mbinit_done = 1;
	// 	    	successful_checks.push_back(new_trans.get_message_name());
	// 	    	`uvm_info(get_full_name(), 
	// 	    		$sformatf("Detected message type: %s", new_trans.get_message_name()), UVM_MEDIUM);
	// 	        `uvm_info(get_full_name(), 
	// 	        	$sformatf("\n%s successful (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	        	new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code), UVM_MEDIUM);
	// 	    end
	// 	    /*------------------------------------------------------------------------------
	// 		-- Error Handshake  
	// 		------------------------------------------------------------------------------*/
	// 	    else begin
	// 	    	`uvm_error(get_full_name(),
	// 	            $sformatf("\n%s handshake failed! (REQ_MSG_CODE: 0x%0h, RESP_MSG_CODE: 0x%0h) (REQ_MSG_SUB_CODE: 0x%0h, RESP_MSG_SUB_CODE: 0x%0h)", 
	// 	            new_trans.get_message_name(), old_msg_code, new_msg_code, old_sub_code, new_sub_code));
	// 	    end 
	//     end
	//     else begin
	//     	return;
	//     end
	    	
	// endtask

	// /*------------------------------------------------------------------------------
	// -- Capture Tasks  
	// ------------------------------------------------------------------------------*/
    // task capture_transaction(
	//     input bit [63:0] packet,               // Packet input
	//     output sideband_sequence_item trans    // Transaction output
	// );
	//     // Create new transaction object
	//     trans = sideband_sequence_item::type_id::create("trans", this);
	    
	//     // Capture all fields from interface
	//     trans.src_id      = packet[31:29];
	//     trans.dst_id      = packet[58:56];
	//     trans.msg_code    = packet[21:14];
	//     trans.msg_subcode = packet[39:32];
	//     trans.opcode      = packet[4:0];
	//     trans.dp          = packet[63];
	//     trans.cp          = packet[62];
	//     trans.msg_info    = packet[55:40];
	//     trans.data        = packet;

	// endtask
    // // task capture_transaction();
    // //     old_trans = sideband_sequence_item::type_id::create("old_trans", this);
    // //     new_trans = sideband_sequence_item::type_id::create("new_trans", this);
    // //     // Capture last transaction
    // //     old_trans.src_id      = vif_monitor.fifo_data_out[31:29];
    // //     old_trans.dst_id      = vif_monitor.fifo_data_out[58:56];
    // //     old_trans.msg_code    = vif_monitor.fifo_data_out[21:14];
    // //     old_trans.msg_subcode = vif_monitor.fifo_data_out[39:32];
    // //     old_trans.opcode      = vif_monitor.fifo_data_out[4:0];
    // //     old_trans.dp          = vif_monitor.fifo_data_out[63];
    // //     old_trans.cp          = vif_monitor.fifo_data_out[62];
    // //     old_trans.msg_info    = vif_monitor.fifo_data_out[55:40];
    // //     old_trans.data        = vif_monitor.fifo_data_out;

    // //     // Capture new transaction
    // //     wait_for_bus_change();
    // //     new_trans.src_id      = vif_monitor.fifo_data_out[31:29];
    // //     new_trans.dst_id      = vif_monitor.fifo_data_out[58:56];
    // //     new_trans.msg_code    = vif_monitor.fifo_data_out[21:14];
    // //     new_trans.msg_subcode = vif_monitor.fifo_data_out[39:32];
    // //     new_trans.opcode      = vif_monitor.fifo_data_out[4:0];
    // //     new_trans.dp          = vif_monitor.fifo_data_out[63];
    // //     new_trans.cp          = vif_monitor.fifo_data_out[62];
    // //     new_trans.msg_info    = vif_monitor.fifo_data_out[55:40];
    // //     new_trans.data        = vif_monitor.fifo_data_out;
    // // endtask

    // // Data Packet capture
    // task capture_data(input bit req);
    // 	string data_type;
    // 	bit [63:0] data;
    // 	string dp_check;
	// 	bit dp;

    // 	if (req) begin
    // 		data_type = "REQ";
    // 	end
    // 	else begin
    // 		data_type = "RESP";
    // 	end

	// 	capture_transaction();
	// 	dp = old_trans.dp;
	// 	data = new_trans.data;
	// 	chech_data_parity(new_trans.data, dp, dp_check);

	// 	if (dp_check == "Failed") begin
	// 		error_count++;
	// 	end
	// 	else if (dp_check == "Passed") begin
	// 		correct_count++;
	// 	end

	// 	`uvm_info(get_full_name(), 
	//     		$sformatf("\n%s - Data: %h, Data Parity: %s", data_type, data, dp_check), UVM_MEDIUM);
    // endtask : capture_data

	// // Task to wait for change on bus
	// task wait_for_bus_change();
	// 	int max_cycles = 1000;
	//     bit [63:0] initial_data;
	//     int cycles_waited = 0;
	//     bit bus_changed;
	    
	//     // Capture initial bus state
	//     initial_data = vif_monitor.fifo_data_out;
	//     bus_changed = 0;
	    
	//     `uvm_info(get_full_name(),$sformatf("Waiting for bus change (timeout=%0d cycles)", max_cycles),UVM_DEBUG);
	    
	//     // Monitoring loop
	//     while (cycles_waited < max_cycles && !bus_changed) begin
	//         @(posedge vif_monitor.clk_ser_en);
	//         cycles_waited++;
	        
	//         // Check for data change 
	//         if (vif_monitor.fifo_data_out != initial_data) begin
	//             bus_changed = 1;
	//             `uvm_info(get_full_name(),$sformatf("Bus changed after %0d cycles (0x%0h -> 0x%0h)",cycles_waited, initial_data, vif_monitor.fifo_data_out),UVM_MEDIUM);
	//         end
	//     end
	    
	//     // Timeout handling
	//     if (!bus_changed) begin
	//         `uvm_info(get_full_name(),$sformatf("Bus unchanged after %0d cycles (data: 0x%0h)",max_cycles, initial_data),UVM_MEDIUM);
	//     end
	// endtask

	// /*------------------------------------------------------------------------------
	// -- Checking Tasks  
	// ------------------------------------------------------------------------------*/
	// task check_opcode(input [4:0] opcode, output string message_type);
	// 	// there are another cases like compilation messages comes from adapter
	// 	if (opcode == 5'b11011) begin
	// 		message_type = "MESSAGE WITH DATA";
	// 	end
	// 	else begin
	// 		message_type = "MESSAGE WITHOUT DATA";
	// 	end
	// endtask : check_opcode

	// task check_srid(input [2:0] srid, output string source);
	// 	if (srid == 3'b001) begin
	// 		source = "D2D Adapter";
	// 	end
	// 	else begin
	// 		source = "Physical Layer";
	// 	end
	// endtask : check_srid

	// task check_dstid(input [2:0] dstid, output string destination);
	// 	if (dstid == 3'b101) begin
	// 		destination = "D2D Adapter";
	// 	end
	// 	else begin
	// 		destination = "Physical Layer";
	// 	end
	// endtask : check_dstid

	// task chech_control_parity(input [63:0] packet, output string correct_cp);
	// 	if ((~^packet[62:0])) begin
	// 			correct_cp = "Passed";
	// 		end
	// 		else begin
	// 			correct_cp = "Failed";
	// 		end
	// endtask : chech_control_parity

	// task chech_data_parity(input [63:0] packet, input bit dp, output string correct_dp);
	// 	if ((^packet == dp) ) begin
	// 			correct_dp = "Passed";
	// 		end
	// 		else begin
	// 			correct_dp = "Failed";
	// 		end
	// endtask : chech_data_parity

	// task check_encoding(input sideband_sequence_item trans);
    // 	string message_type, source, destination, parity_ok, req_resp_type;

	// 	check_opcode(trans.opcode, message_type);
	// 	check_srid(trans.src_id, source);
	// 	check_dstid(trans.dst_id, destination);
	// 	chech_control_parity(trans.data, parity_ok);

	// 	if (parity_ok == "Failed") begin
	// 		error_count++;
	// 	end
	// 	else if (parity_ok == "Passed") begin
	// 		correct_count++;
	// 	end

	// 	if (trans.msg_code[3:0] == 4'h5) begin
	// 		req_resp_type = "REQ";
	// 	end
	// 	else if (trans.msg_code[3:0] == 4'hA) begin
	// 		req_resp_type = "RESP";
	// 	end
	// 	else begin
	// 		req_resp_type = "OUT OF RESET";
	// 	end

	// 	// Summary report
	// 	`uvm_info(get_full_name(),
	// 	    $sformatf(" \nChecks complete - %s - Type: %s, Src: %s, Dst: %s, Control Parity: %s",
	// 	    req_resp_type,
	// 	    message_type,
	// 	    source,
	// 	    destination,
	// 	    parity_ok ),
	// 	    UVM_MEDIUM)
	// endtask

	// function void report_phase(uvm_phase phase);
	//     super.report_phase(phase);

	//     `uvm_info(get_full_name(),
	//              "==================================================",
	//              UVM_MEDIUM)
	//     `uvm_info(get_full_name(),
	//              $sformatf("              Parity Results              "),
	//              UVM_MEDIUM)
	//     `uvm_info(get_full_name(),
	//              $sformatf("Correct Counts are %0d, Error Counts are %0d", correct_count, error_count),
	//              UVM_MEDIUM)
	//     `uvm_info(get_full_name(),
	//              "==================================================",
	//              UVM_MEDIUM)
	    
	//     // Print all successful handshakes
	//     `uvm_info(get_full_name(),
	//              $sformatf("            Completed Handshakes            "),
	//              UVM_MEDIUM)

	//     foreach (successful_checks[i]) begin
	//         `uvm_info(get_full_name(),
	//                  $sformatf(" %0d. %s", i+1, successful_checks[i]),
	//                  UVM_MEDIUM)
	//     end
	    
	//     `uvm_info(get_full_name(),
	//              "==================================================",
	//              UVM_MEDIUM)
	// endfunction : report_phase


