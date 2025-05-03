	class sideband_sequence_item extends uvm_sequence_item;
		`uvm_object_utils(sideband_sequence_item)
		/*------------------------------------------------------------------------------
		--new function   
		------------------------------------------------------------------------------*/
		function  new(string name ="sideband_seq_item");
			super.new(name);
		endfunction : new
		/*------------------------------------------------------------------------------
		--control packets fields  
		------------------------------------------------------------------------------*/			
		logic [2:0] src_id,dst_id;
		logic [7:0] msg_code,msg_subcode;
		logic [4:0] opcode;
		logic 		dp,cp;
		logic [15:0]msg_info;
		/*------------------------------------------------------------------------------
		--data packets fields   
		------------------------------------------------------------------------------*/
		logic [63:0] data;
		/*------------------------------------------------------------------------------
		--flags   
		------------------------------------------------------------------------------*/
		//flags from sequendce to driver 
		logic control_packet;
		logic data_packet;
		logic pattern_packet;
		logic separate_packet;
		logic wait_for_request;
		logic wait_for_response;
		bit   end_of_sequence; // if this bit equal one so this means that the packet is the last packet
							  //in a certain sequence so storing the value of new requese or new response 
							 //doesn't matter as the seqeunce ends and no event will be taken based on this flag 
 		//flags sent from driver to sequence to be used in reactive stimulus 
		logic pattern_detected;
		bit req_detected;
		bit resp_detected;

	endclass : sideband_sequence_item