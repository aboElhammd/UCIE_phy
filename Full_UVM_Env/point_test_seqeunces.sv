class point_test_seqeunces_base_class extends   uvm_sequence #(sideband_sequence_item);
	sideband_sequence_item trans, resp;
	task prebody();
			trans=sideband_sequence_item::type_id::create("trans");
	endtask : prebody
	/*------------------------------------------------------------------------------
	--sending sideband message   
	------------------------------------------------------------------------------*/
	task send_sb_message_without_data
		(
		 input logic [7:0] msg_code,msg_subcode,
		 input logic [15:0]msg_info,
		 input bit end_of_Sequence=0
		 );
		trans=sideband_sequence_item::type_id::create("trans");
		start_item(trans);
			//fixed parts 
			trans.src_id=3'b010;
			trans.dst_id=3'b110;
			//changed parts 
			trans.msg_info=msg_info;
			trans.msg_code=msg_code;
			trans.msg_subcode=msg_subcode;
			trans.opcode= 5'b10010;
			trans.dp=1'b0;
			trans.cp= ^{trans.src_id , trans.dst_id , trans.msg_info , trans.msg_code 
					   ,trans.msg_subcode , trans.opcode};
			//flags
			trans.pattern_packet=1'b0;
			trans.data_packet=1'b0;
			trans.control_packet=1'b1;
			trans.pattern_packet=1'b0;
			trans.separate_packet=1'b0;
			trans.wait_for_request=0;
			trans.wait_for_response=0;
			trans.end_of_sequence=end_of_Sequence;
		finish_item(trans);
		get_response(resp);
		if(resp.req_detected) begin
			`uvm_info( "MBINIT sequence" , "detection of recieved reqeuset",UVM_MEDIUM);
		end if(resp.resp_detected) begin 
			`uvm_info( "MBINIT sequence" , "detection of recieved response",UVM_MEDIUM);			
		end
	endtask : send_sb_message_without_data
		/*------------------------------------------------------------------------------
	--sending sideband message   
	------------------------------------------------------------------------------*/
	task send_sb_message_with_data
		(
		 input logic [7:0]  msg_code,msg_subcode,
		 input logic [15:0] msg_info,
		 input logic [63:0] data ,
		 input bit end_of_Sequence=0
		);
		trans=sideband_sequence_item::type_id::create("trans");
		start_item(trans);
			//fixed parts 
			trans.src_id=3'b010;
			trans.dst_id=3'b110;
			//changed parts 
			trans.msg_info=msg_info;
			trans.msg_code=msg_code;
			trans.msg_subcode=msg_subcode;
			trans.opcode= 5'b11011;
			trans.dp=^data;
			trans.cp= ^{trans.src_id , trans.dst_id , trans.msg_info , trans.msg_code 
					   ,trans.msg_subcode , trans.opcode};
			//assiging data 
			trans.data=data;
			//flags
			trans.pattern_packet=1'b0;
			trans.data_packet=1'b1;
			trans.control_packet=1'b0;
			trans.pattern_packet=1'b0;
			trans.separate_packet=1'b0;
			trans.wait_for_request=0;
			trans.wait_for_response=0;
			trans.end_of_sequence=end_of_Sequence;
		finish_item(trans);
		get_response(resp);
		if(resp.req_detected) begin
			`uvm_info( "MBINIT sequence" , "detection of recieved reqeuset",UVM_MEDIUM);
		end if(resp.resp_detected) begin
			`uvm_info( "MBINIT sequence" , "detection of recieved response",UVM_MEDIUM);			
		end 
	endtask : send_sb_message_with_data
	/*------------------------------------------------------------------------------
	--waiting for request   
	------------------------------------------------------------------------------*/
	task wait_for_request();
		trans=sideband_sequence_item::type_id::create("trans");
		start_item(trans);
			//fixed parts 
			trans.wait_for_request=1;
			trans.wait_for_response=0;
		finish_item(trans);
		get_response(resp);
	endtask : wait_for_request
	/*------------------------------------------------------------------------------
	--waiting for response   
	------------------------------------------------------------------------------*/
		task wait_for_response();
		trans=sideband_sequence_item::type_id::create("trans");
		start_item(trans);
			//fixed parts 
			trans.wait_for_request=0;
			trans.wait_for_response=1;
		finish_item(trans);
		get_response(resp);
	endtask : wait_for_response
endclass : point_test_seqeunces_base_class
/*------------------------------------------------------------------------------
--transmitter_initiated_d2c_point_test  
------------------------------------------------------------------------------*/
class tx_initiated_point_test_init_handshake_per_lane extends point_test_seqeunces_base_class;
	`uvm_object_utils(tx_initiated_point_test_init_handshake_per_lane)
	task body();
		bit recieved_last_respone;
		bit [63:0] data;
		bit  Comparison_Mode ; //(0: Per Lane; 1: Aggregate) 
		bit [15:0] Iteration_Count ;  //always one
		bit [15:0] Idle_Count ;  // always zero
		bit [15:0] Burst_Count;  //2k=128*16 
		bit  Pattern_Mode ;//(0: continuous mode, 1: Burst Mode) -> always zero
		bit [3:0]  Clock_Phase ;//control at Tx Device (Oh: Clock PI Center, 1h: Left Edge, 2h: Right Edge) 
		bit [2:0]  Valid_Pattern; //(0h: Functional pattern)  -> always zero
		bit [2:0] Data_pattern; //(0h: LFSR, 1h: Per Lane ID)
		`uvm_info("tx point test perlane init hs sequence" ,			"
			**********************************************************************************************************************************************************
			************************************************************************point test  init handshake has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
		Comparison_Mode=1'b0;
		Iteration_Count=16'h0001;
		Idle_Count=16'h0000;
		Burst_Count=16'h0800;
		Pattern_Mode=1'b0;
		Clock_Phase=4'h1;
		Valid_Pattern=3'h0;
		Data_pattern=3'h1;
		data= {4'h0 ,Comparison_Mode , Iteration_Count , Idle_Count , Burst_Count , Pattern_Mode , Clock_Phase , Valid_Pattern , Data_pattern};
		send_sb_message_with_data(8'h85,8'h01,16'h0000,data);
		if(resp.req_detected) begin
			send_sb_message_without_data(8'h8A,8'h01,16'h0000,1);
		end else begin
			recieved_last_respone=1;
			wait_for_request();
			send_sb_message_without_data(8'h8A,8'h01,16'h0000,1);
		end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("tx point test perlane init hs sequence" , "point test init  hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("tx point test perlane init hs sequence" , "point test init hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : tx_initiated_point_test_init_handshake_per_lane
/*------------------------------------------------------------------------------
--transmitter _initiated_d2c_point_test valid pattern   
------------------------------------------------------------------------------*/
class tx_initiated_point_test_init_handshake_val_pattern extends point_test_seqeunces_base_class;
	`uvm_object_utils(tx_initiated_point_test_init_handshake_val_pattern)
	task body();
		bit recieved_last_respone;
		bit [63:0] data;
		bit  Comparison_Mode ; //(0: Per Lane; 1: Aggregate) 
		bit [15:0] Iteration_Count ;  //always one
		bit [15:0] Idle_Count ;  // always zero
		bit [15:0] Burst_Count;  //1k=128*8 
		bit  Pattern_Mode ;//(0: continuous mode, 1: Burst Mode) -> always zero
		bit [3:0]  Clock_Phase ;//control at Tx Device (Oh: Clock PI Center, 1h: Left Edge, 2h: Right Edge) 
		bit [2:0]  Valid_Pattern; //(0h: Functional pattern)  -> always zero
		bit [2:0] Data_pattern; //(0h: LFSR, 1h: Per Lane ID)
		`uvm_info("tx point test Valid Pattern init hs sequence" ,			"
			**********************************************************************************************************************************************************
			************************************************************************point test  init handshake has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
		Comparison_Mode=1'b0;
		Iteration_Count=16'h0001;
		Idle_Count=16'h0000;
		Burst_Count=16'h0400;
		Pattern_Mode=1'b0;
		Clock_Phase=4'h1;
		Valid_Pattern=3'h1;
		Data_pattern=3'h1;
		data= {4'h0 ,Comparison_Mode , Iteration_Count , Idle_Count , Burst_Count , Pattern_Mode , Clock_Phase , Valid_Pattern , Data_pattern};
		send_sb_message_with_data(8'h85,8'h01,16'h0000,data);
		if(resp.req_detected) begin
			send_sb_message_without_data(8'h8A,8'h01,16'h0000,1);
		end else begin
			recieved_last_respone=1;
			wait_for_request();
			send_sb_message_without_data(8'h8A,8'h01,16'h0000,1);
		end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("tx point Valid Pattern test init hs sequence" , "point test init  hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("tx point Valid Pattern test init hs sequence" , "point test init hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : tx_initiated_point_test_init_handshake_val_pattern
/*------------------------------------------------------------------------------
--transmitter _initiated_d2c_point_test valid pattern   
------------------------------------------------------------------------------*/
class tx_initiated_point_test_init_handshake_LFSR_pattern extends point_test_seqeunces_base_class;
	`uvm_object_utils(tx_initiated_point_test_init_handshake_LFSR_pattern)
	task body();
		bit recieved_last_respone;
		bit [63:0] data;
		bit  Comparison_Mode ; //(0: Per Lane; 1: Aggregate) 
		bit [15:0] Iteration_Count ;  //always one
		bit [15:0] Idle_Count ;  // always zero
		bit [15:0] Burst_Count;  //4k 
		bit  Pattern_Mode ;//(0: continuous mode, 1: Burst Mode) -> always zero
		bit [3:0]  Clock_Phase ;//control at Tx Device (Oh: Clock PI Center, 1h: Left Edge, 2h: Right Edge) 
		bit [2:0]  Valid_Pattern; //(0h: Functional pattern)  -> always zero
		bit [2:0] Data_pattern; //(0h: LFSR, 1h: Per Lane ID)
		`uvm_info("tx LFSR point test init hs sequence" ,			"
			**********************************************************************************************************************************************************
			************************************************************************point test  init handshake has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
		Comparison_Mode=1'b0;
		Iteration_Count=16'h0001;
		Idle_Count=16'h0000;
		Burst_Count=16'h1000;
		Pattern_Mode=1'b0;
		Clock_Phase=4'h1;
		Valid_Pattern=3'h0;
		Data_pattern=3'h0;
		data= {4'h0 ,Comparison_Mode , Iteration_Count , Idle_Count , Burst_Count , Pattern_Mode , Clock_Phase , Valid_Pattern , Data_pattern};
		send_sb_message_with_data(8'h85,8'h01,16'h0000,data);
		if(resp.req_detected) begin
			send_sb_message_without_data(8'h8A,8'h01,16'h0000,1);
		end else begin
			recieved_last_respone=1;
			wait_for_request();
			send_sb_message_without_data(8'h8A,8'h01,16'h0000,1);
		end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("tx LFSR point test init hs sequence" , "point test init  hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("tx LFSR point test init hs sequence" , "point test init hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : tx_initiated_point_test_init_handshake_LFSR_pattern
/*------------------------------------------------------------------------------
--reciever _initiated_d2c_point_test  
------------------------------------------------------------------------------*/
class rx_initiated_point_test_init_handshake_val_pattern extends point_test_seqeunces_base_class;
	`uvm_object_utils(rx_initiated_point_test_init_handshake_val_pattern)
	task body();
		bit recieved_last_respone;
		bit [63:0] data;
		bit  Comparison_Mode ; //(0: Per Lane; 1: Aggregate) 
		bit [15:0] Iteration_Count ;  //always one
		bit [15:0] Idle_Count ;  // always zero
		bit [15:0] Burst_Count;  //1k=128*8 
		bit  Pattern_Mode ;//(0: continuous mode, 1: Burst Mode) -> always zero
		bit [3:0]  Clock_Phase ;//control at Tx Device (Oh: Clock PI Center, 1h: Left Edge, 2h: Right Edge) 
		bit [2:0]  Valid_Pattern; //(0h: Functional pattern)  -> always zero
		bit [2:0] Data_pattern; //(0h: LFSR, 1h: Per Lane ID)
		`uvm_info("rx point test init hs sequence" ,			"
			**********************************************************************************************************************************************************
			************************************************************************point test  init handshake has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
		Comparison_Mode=1'b0;
		Iteration_Count=16'h0001;
		Idle_Count=16'h0000;
		Burst_Count=16'h0400;
		Pattern_Mode=1'b0;
		Clock_Phase=4'h1;
		Valid_Pattern=3'h0;
		Data_pattern=3'h1;
		data= {4'h0 ,Comparison_Mode , Iteration_Count , Idle_Count , Burst_Count , Pattern_Mode , Clock_Phase , Valid_Pattern , Data_pattern};
		send_sb_message_with_data(8'h85,8'h07,16'h0000,data);
		if(resp.req_detected) begin
			send_sb_message_without_data(8'h8A,8'h07,16'h0000,1);
		end else begin
			recieved_last_respone=1;
			wait_for_request();
			send_sb_message_without_data(8'h8A,8'h07,16'h0000,1);
		end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("rx point test init hs sequence" , "point test init  hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("rx point test init hs sequence" , "point test init hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : rx_initiated_point_test_init_handshake_val_pattern
/*------------------------------------------------------------------------------
--reciever _initiated_d2c_point_test  
------------------------------------------------------------------------------*/
class rx_initiated_point_test_init_handshake_LFSR_pattern extends point_test_seqeunces_base_class;
	`uvm_object_utils(rx_initiated_point_test_init_handshake_LFSR_pattern)
	task body();
		bit recieved_last_respone;
		bit [63:0] data;
		bit  Comparison_Mode ; //(0: Per Lane; 1: Aggregate) 
		bit [15:0] Iteration_Count ;  //always one
		bit [15:0] Idle_Count ;  // always zero
		bit [15:0] Burst_Count;  //1k=128*8 
		bit  Pattern_Mode ;//(0: continuous mode, 1: Burst Mode) -> always zero
		bit [3:0]  Clock_Phase ;//control at Tx Device (Oh: Clock PI Center, 1h: Left Edge, 2h: Right Edge) 
		bit [2:0]  Valid_Pattern; //(0h: Functional pattern)  -> always zero
		bit [2:0] Data_pattern; //(0h: LFSR, 1h: Per Lane ID)
		`uvm_info("rx point test init hs sequence" ,			"
			**********************************************************************************************************************************************************
			************************************************************************point test  init handshake has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM)
		Comparison_Mode=1'b0;
		Iteration_Count=16'h0001;
		Idle_Count=16'h0000;
		Burst_Count=16'h0400;
		Pattern_Mode=1'b0;
		Clock_Phase=4'h1;
		Valid_Pattern=3'h0;
		Data_pattern=3'h1;
		data= {4'h0 ,Comparison_Mode , Iteration_Count , Idle_Count , Burst_Count , Pattern_Mode , Clock_Phase , Valid_Pattern , Data_pattern};
		send_sb_message_with_data(8'h85,8'h07,16'h0000,data);
		if(resp.req_detected) begin
			send_sb_message_without_data(8'h8A,8'h07,16'h0000,1);
		end else begin
			recieved_last_respone=1;
			wait_for_request();
			send_sb_message_without_data(8'h8A,8'h07,16'h0000,1);
		end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("rx point test init hs sequence" , "point test init  hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("rx point test init hs sequence" , "point test init hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : rx_initiated_point_test_init_handshake_LFSR_pattern
/*------------------------------------------------------------------------------
--LFSR clear error hand shake  
------------------------------------------------------------------------------*/
class LFSR_CLEAR_handshake extends point_test_seqeunces_base_class;
	`uvm_object_utils(LFSR_CLEAR_handshake)
	task body();
		bit recieved_last_respone;
		`uvm_info("tx point test init hs sequence" ,			"
			**********************************************************************************************************************************************************
			************************************************************************point test  clear LFSR handshake has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
		send_sb_message_without_data(8'h85,8'h02,16'h0000);
		if(resp.req_detected) begin
			send_sb_message_without_data(8'h8A,8'h02,16'h0000,1);
		end else begin
			recieved_last_respone=1;
			wait_for_request();
			send_sb_message_without_data(8'h8A,8'h02,16'h0000,1);
		end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("tx point test init hs sequence" , "point test clear LFSR  hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("tx point test init hs sequence" , "point test clear LFSR hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : LFSR_CLEAR_handshake
/*------------------------------------------------------------------------------
--result request and done handshake  
------------------------------------------------------------------------------*/
class tx_initiated_point_test_result_and_done_handshakes #(parameter lanes_result = 16'hffff) extends point_test_seqeunces_base_class;
	`uvm_object_param_utils(tx_initiated_point_test_result_and_done_handshakes #(lanes_result))
	task body();
		bit first_time=1;
		bit [7:0]msg_subcode=8'h03;
		int count =3;
		bit recieved_last_respone;
		bit [15:0] msg_info;
		bit [63:0] data;
		`uvm_info("point_test_sequence" ,
			"
			*************************************************************************************************************************************
			********************************************** point test result request has started*************************************************
			************************************************************************************************************************************* 
			" ,UVM_MEDIUM);
		data[15:0]=lanes_result; //all 16 lanes are functioanl 
		msg_info[5:4]=2'b11; //valid lane and accumulative result
		send_sb_message_without_data(8'h85,8'h03,16'h0000);
		for (int i = 0; i < count; i++) begin
			if( (resp.req_detected) && msg_subcode != 8'h05) begin
				if(msg_subcode==8'h03)
					send_sb_message_with_data(8'h8A,msg_subcode,msg_info,data);
				else 
					send_sb_message_without_data(8'h8A,msg_subcode,16'h0000,1);
				msg_subcode=msg_subcode+1;
			end else if(resp.resp_detected && first_time) begin
				first_time=0;
				send_sb_message_without_data(8'h85,8'h04,16'h0000);
			end else if (!resp.resp_detected) begin //case that should never happens
				`uvm_info("initiated_point_test_sequence" , "calling the wait for response task ", UVM_MEDIUM);
				wait_for_response();
				count++;
			end else if(!resp.req_detected) begin //condition can also be resp.resp_detected && !first time which means that we reciebved the last response 
 				`uvm_info("initiated_point_test_sequence" , "calling the wait for request task ", UVM_MEDIUM);				
				wait_for_request();
				count++;
				recieved_last_respone=1;
			end
		end

		if(recieved_last_respone || resp.resp_detected) begin
				`uvm_info("point_test_sequence" , "point test result request and done handshake last response has been recieved and substate has finished", UVM_MEDIUM);
		end else begin
			wait_for_response();
			`uvm_info("point_test_sequence" , "point test result request and done handshake last response has been recieved and substate has finished", UVM_MEDIUM);
		end
	endtask : body
endclass : tx_initiated_point_test_result_and_done_handshakes
/*------------------------------------------------------------------------------
--result request and done handshake  
------------------------------------------------------------------------------*/
class rx_initiated_point_test_result_and_done_handshakes extends point_test_seqeunces_base_class;
	`uvm_object_utils(rx_initiated_point_test_result_and_done_handshakes)
	task body();
		bit first_time=1;
		bit [7:0]msg_subcode=8'h08;
		int count =3;
		bit recieved_last_respone;
		bit [15:0] msg_info;
		bit [63:0] data;
		`uvm_info("point_test_sequence" ,
			"
			*************************************************************************************************************************************
			********************************************** point test result request has started*************************************************
			************************************************************************************************************************************* 
			" ,UVM_MEDIUM);
		data[15:0]=16'hffff; //all 16 lanes are functioanl 
		send_sb_message_without_data(8'h85,8'h08,16'h0000);
		for (int i = 0; i < count; i++) begin
			if( (resp.req_detected) && msg_subcode != 8'h0A) begin
				if(msg_subcode==8'h08)
					send_sb_message_without_data(8'h8A,msg_subcode,16'h0000);
				else 
					send_sb_message_without_data(8'h8A,msg_subcode,16'h0000,1);
				msg_subcode=msg_subcode+1;
			end else if(resp.resp_detected && first_time) begin
				first_time=0;
				send_sb_message_without_data(8'h85,8'h09,16'h0000);
			end else if (!resp.resp_detected) begin //case that should never happens
				`uvm_info("initiated_point_test_sequence" , "calling the wait for response task ", UVM_MEDIUM);
				wait_for_response();
				count++;
			end else if(!resp.req_detected) begin //condition can also be resp.resp_detected && !first time which means that we reciebved the last response 
 				`uvm_info("initiated_point_test_sequence" , "calling the wait for request task ", UVM_MEDIUM);				
				wait_for_request();
				count++;
				recieved_last_respone=1;
			end
		end

		if(recieved_last_respone || resp.resp_detected) begin
				`uvm_info("point_test_sequence" , "point test result request and done handshake last response has been recieved and substate has finished", UVM_MEDIUM);
		end else begin
			wait_for_response();
			`uvm_info("point_test_sequence" , "point test result request and done handshake last response has been recieved and substate has finished", UVM_MEDIUM);
		end
	endtask : body
endclass : rx_initiated_point_test_result_and_done_handshakes
