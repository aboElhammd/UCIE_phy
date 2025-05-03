class sideband_sequence extends  uvm_sequence #(sideband_sequence_item);
	`uvm_object_utils(sideband_sequence)
	sideband_sequence_item trans, resp;
	task prebody();
			trans=sideband_sequence_item::type_id::create("trans");
	endtask : prebody
	task body();
		repeat (4) begin
			send_sb_pattern();
			if(!resp.pattern_detected)
				wait_for_1_m_sec();
			else begin
				break;
			end
		end
		if(resp.pattern_detected)
			send_four_more_iterations();
//		else 
//			train_error() 
		send_sb_out_of_reset_msg();
		sb_done_handshake();
	endtask : body
	/*------------------------------------------------------------------------------
	--task that is used for sending sideband pattern packets   
	------------------------------------------------------------------------------*/
	task send_sb_pattern();
		int count=0; //used to count the number of packets that has been sent and
					// we can't send more than 8334 as this represents 1msec
		`uvm_info( "sideband sequence" , "sideband pattern sending has started" ,	UVM_MEDIUM);
		send_pattern(0);
		while (~resp.pattern_detected && count != 8334) begin
			send_pattern(0);
			count++;
		end
		`uvm_info( "sideband sequence" , "sideband pattern sending has finished" ,	UVM_MEDIUM);
	endtask : send_sb_pattern
	/*------------------------------------------------------------------------------
	--wait for 1 msec task  
	------------------------------------------------------------------------------*/
	task wait_for_1_m_sec();
		int count=0; //used to count the number of packets that has been sent and
					// we can't send more than 8334 as this represents 1msec
		`uvm_info( "sideband sequence" , "waititng for 1 msec has started" ,	UVM_MEDIUM);
		while (~resp.pattern_detected && count != 8334) begin
			send_pattern(1);
			count++;
		end
	endtask : wait_for_1_m_sec
	/*------------------------------------------------------------------------------
	--task that sends four more patterns   
	------------------------------------------------------------------------------*/
	task send_four_more_iterations();
		`uvm_info( "sideband sequence" , "sending last four iterations" ,	UVM_MEDIUM);
		repeat(4) begin
			send_pattern(0);
		end
	endtask : send_four_more_iterations
	/*------------------------------------------------------------------------------
	--task that is used for sending an empty packet or sideband pattern packet  
	------------------------------------------------------------------------------*/
	task send_pattern(input bit empty_pattern);
		trans=sideband_sequence_item::type_id::create("trans");
		start_item(trans);
			if(empty_pattern)
				trans.data={64{1'b0}};
			else 
				trans.data={32{2'b10}};
			trans.pattern_packet=1'b1;
		finish_item(trans);
		get_response(resp);
		if(~empty_pattern)
			`uvm_info( "sideband sequence" , "a pattern packet has been sent" ,	UVM_MEDIUM);
	endtask : send_pattern
	/*------------------------------------------------------------------------------
	--task that sends the sb out of reset msg  
	-----sends out of reset message until it detects the same message 
	------------------------------------------------------------------------------*/
	task send_sb_out_of_reset_msg();
		// bit out_of_reset_req_recieved=0;
		`uvm_info( "sideband sequence" , "sideband out of reset request sending has started" ,	UVM_MEDIUM);
		if(resp.req_detected)begin
			`uvm_info( "sideband sequence" , "request was already detected" ,	UVM_MEDIUM);
			send_sb_message(8'h91,8'h00,5'b10010,16'h0000,1'b1);
		end else begin
			send_sb_message(8'h91,8'h00,5'b10010,16'h0000,1'b1);
			`uvm_info( "sideband sequence" ,$sformatf("sent the first out of reset and the request flag = %0b",resp.req_detected)
			  ,	UVM_MEDIUM);
			while (~resp.req_detected) begin
				send_sb_message(8'h91,8'h00,5'b10010,16'h0000,1'b1);
			end
		end
	endtask : send_sb_out_of_reset_msg
	/*------------------------------------------------------------------------------
	--task that is responsible for the done hand shake 
	-----sends done requese first as it start after right detection of pattern immediately 
	-----and then it checks if the remote partner sent reqeuset so it sends the response for this req  
	------------------------------------------------------------------------------*/
	task sb_done_handshake();
		`uvm_info("sideband sequence" , "done handshake has started ", UVM_MEDIUM);
			if(resp.req_detected)begin
				send_sb_message(8'h95,8'h01,5'b10010,16'h0000,1'b0);
				send_sb_message(8'h9A,8'h01,5'b10010,16'h0000,1'b0);
			end else begin
				send_sb_message(8'h95,8'h01,5'b10010,16'h0000,1'b0);
				if(resp.req_detected)
					send_sb_message(8'h9A,8'h01,5'b10010,16'h0000,1'b0);
			end
			if(resp.resp_detected) 
				`uvm_info("sideband sequence" , "sideband done hand shake has finished",UVM_MEDIUM)
	endtask : sb_done_handshake
	/*------------------------------------------------------------------------------
	--send out of reset request message   
	------------------------------------------------------------------------------*/
	task send_sb_message(
		input logic [7:0] msg_code,msg_subcode,
		input logic [4:0] opcode,
		input logic [15:0]msg_info , 
		input logic separate_packet //if i will send consecutive packes without waiting for respond 
								  //to a packet to send the next packet 
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
			trans.opcode= opcode;
			trans.dp=1'b0;
			trans.cp= ^{trans.src_id , trans.dst_id , trans.msg_info , trans.msg_code 
					   ,trans.msg_subcode , trans.opcode};
			//flags
			trans.pattern_packet=1'b0;
			trans.data_packet=1'b0;
			trans.control_packet=1'b1;
			trans.pattern_packet=1'b0;
			trans.separate_packet=separate_packet;
		finish_item(trans);
		get_response(resp);
		`uvm_info( "sideband sequence" , "sideband message has been sent ",UVM_MEDIUM);
		if(resp.req_detected) 
			`uvm_info( "sideband sequence" , "detection of recieved reqeuset",UVM_MEDIUM);
		if(resp.resp_detected) 
			`uvm_info( "sideband sequence" , "detection of recieved response",UVM_MEDIUM);			
	endtask : send_sb_message
endclass : sideband_sequence

/*--------------------------------------------------------------------------------------------------------
-- ******************************************mbinit seqeunce********************************************** 
--------------------------------------------------------------------------------------------------------*/
class MBINIT_sequence extends  uvm_sequence #(sideband_sequence_item);
	`uvm_object_utils(MBINIT_sequence)
	sideband_sequence_item trans, resp;
	task prebody();
			trans=sideband_sequence_item::type_id::create("trans");
	endtask : prebody
	task body();
		// mbinit_param();
		// mbinit_cal();
		// mbinit_repair_clk_init_hs();
		//here should be a sequence that starts on the  mainband which will be done using virtual sequencer
		// mbinit_repair_clk_result_done_hs();
		// mbinit_repair_val_init_hs();
		// mbinit_repair_val_result_done_hs();
		// mbinit_reversal_mb();
		// mbinit_reversal_mb_result_hs();
	//	mbinit_reversal_mb_done_hs();
	//	mbinit_repairmb_init_hs();
	endtask : body
	/*------------------------------------------------------------------------------
	--PARAM substate  
	------------------------------------------------------------------------------*/
	task mbinit_param();
		bit clock_phase ,clock_mode;
		bit [4:0] voltage_swing ;
		bit [3:0] max_link_speed;
		bit [63:0] data;
		`uvm_info("MBINIT sequence" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************param substate has started**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			clock_phase=0;
			clock_mode=1;
			voltage_swing=4'b0111;
			max_link_speed=4'b0011;
			data[10:0]  = {  clock_phase , clock_mode , voltage_swing , max_link_speed };
			data[63:11] = 53'b0;
			send_sb_message_with_data(8'hA5,8'h00,16'h0000,data);
			if(resp.req_detected) begin
				data[10:0]  = {  clock_phase , clock_mode , 4'b0000 , max_link_speed };
				data[63:11] = 53'b0;
				send_sb_message_with_data(8'hAA,8'h00,16'h0000,data);
			end
			if(resp.resp_detected) begin
				`uvm_info("MBINIT sequence" , "param substate has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("MBINIT sequence" , "param substate has been finished",UVM_MEDIUM)
			end
	endtask : mbinit_param
	/*------------------------------------------------------------------------------
	--CAL substate  
	------------------------------------------------------------------------------*/
	task mbinit_cal();
		`uvm_info("MBINIT sequence" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************cal substate has started**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hA5,8'h02,16'h0000);
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hAA,8'h02,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("MBINIT sequence" , "cal substate has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("MBINIT sequence" , "cal substate has been finished",UVM_MEDIUM)
			end
	endtask : mbinit_cal
	/*------------------------------------------------------------------------------
	-- repair clock init handshake  
	------------------------------------------------------------------------------*/
	task mbinit_repair_clk_init_hs();
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************repair clock substate has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
		send_sb_message_without_data(8'hA5,8'h03,16'h0000);
		if(resp.req_detected) begin
			send_sb_message_without_data(8'hAA,8'h03,16'h0000,1);
		end else begin
			recieved_last_respone=1;
			wait_for_request();
			send_sb_message_without_data(8'hAA,8'h03,16'h0000,1);
		end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("MBINIT sequence" , "repair clock init hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence" , "repair clock init hand shake has finished",UVM_MEDIUM)
		end
	endtask : mbinit_repair_clk_init_hs
	/*------------------------------------------------------------------------------
	--repair clock result request and result response   
	------------------------------------------------------------------------------*/
	task mbinit_repair_clk_result_done_hs();
		bit first_time=1;
		bit [15:0] msg_info=16'h0007;
		bit [7:0]msg_subcode=8'h04;
		int count =3;
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence" ,
			"
			*************************************************************************************************************************************
			**********************************************repair clock substate result request has started***************************************
			************************************************************************************************************************************* 
			",UVM_MEDIUM);
		send_sb_message_without_data(8'hA5,8'h04,16'h0000);
		for (int i = 0; i < count; i++) begin
			if(resp.req_detected && msg_subcode != 12) begin
				if(msg_subcode==8)
					send_sb_message_without_data(8'hAA,msg_subcode,msg_info,1);
				else 
					send_sb_message_without_data(8'hAA,msg_subcode,msg_info,0);
				msg_subcode=msg_subcode+4;
				msg_info=16'h0000;
			end else if(resp.resp_detected && first_time) begin
				first_time=0;
				send_sb_message_without_data(8'hA5,8'h08,16'h0000);
			end else if (!resp.resp_detected) begin
				`uvm_info("MBINIT sequence" , "calling the wait for response task ", UVM_MEDIUM);
				wait_for_response();
				count++;
			end else if(!resp.req_detected) begin
				`uvm_info("MBINIT sequence" , "calling the wait for request task ", UVM_MEDIUM);				
				wait_for_request();
				count++;
				//the next code is used to store that we have recieved the done response
				//if (first time = 0) then this means that we have send the done request 
				// if we enter this else if so that means that we recieved a response and of coures it's the done 
				// response because if it's the result response then it would enter seconde else if 
				if(!first_time) begin
					recieved_last_respone=1;
				end
			end
		end

		if(recieved_last_respone) begin
				`uvm_info("MBINIT sequence" , "repair clock last response has been recieved and substate has finished", UVM_MEDIUM);
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence" , "repair clock last response has been recieved and substate has finished", UVM_MEDIUM);
		end
	endtask : mbinit_repair_clk_result_done_hs
	/*------------------------------------------------------------------------------
	--repair val init hasndshaked  
	------------------------------------------------------------------------------*/
	task mbinit_repair_val_init_hs();
		bit recieved_last_respone=0;
		`uvm_info("MBINIT sequence" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************repair val substate has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
		// if(resp.req_detected) begin //if request is detected in the previous task so i will send req and resp immediately
		// 	send_sb_message_without_data(8'hA5,8'h09,16'h0000);
		// 	if(resp.resp_detected) 
		// 		recieved_last_respone=1;
		// 	send_sb_message_without_data(8'hAA,8'h09,16'h0000);
		// end
		// else begin 
			send_sb_message_without_data(8'hA5,8'h09,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hAA,8'h09,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hAA,8'h09,16'h0000);
			end
		// end 
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("MBINIT sequence" , "repair val init hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence" , "repair val init hand shake has finished",UVM_MEDIUM)
		end
	endtask : mbinit_repair_val_init_hs
	/*------------------------------------------------------------------------------
	--repair val result and done request   
	------------------------------------------------------------------------------*/
	task mbinit_repair_val_result_done_hs();
		bit first_time=1;
		bit unanswered_req;
		bit [15:0] msg_info=16'h0001;
		bit [7:0]msg_subcode=8'h0A;
		int count =3;
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence" ,
			"
			*************************************************************************************************************************************
			**********************************************repair val substate result request has started***************************************
			************************************************************************************************************************************* 
			",UVM_MEDIUM);
		// if(resp.req_detected) begin
		// 	send_sb_message_without_data(8'hAA,msg_subcode,msg_info);
		// 	if(resp.req_detected) 
		// 		unanswered_req=1;
		// 	send_sb_message_without_data(8'hA5,8'h0A,16'h0000);
		// 	msg_subcode=msg_subcode+2;
		// 	msg_info=16'h0000;
		// 	count--;
		// end else 
		send_sb_message_without_data(8'hA5,8'h0A,16'h0000);
		for (int i = 0; i < count; i++) begin
			if( (resp.req_detected) && msg_subcode != 14) begin
				if(msg_subcode==8'h0A)
					send_sb_message_without_data(8'hAA,msg_subcode,msg_info);
				else 
					send_sb_message_without_data(8'hAA,msg_subcode,msg_info,1);
				msg_subcode=msg_subcode+2;
				msg_info=16'h0000;
			end else if(resp.resp_detected && first_time) begin
				first_time=0;
				send_sb_message_without_data(8'hA5,8'h0C,16'h0000);
			end else if (!resp.resp_detected) begin //case that should never happens
				`uvm_info("MBINIT sequence" , "calling the wait for response task ", UVM_MEDIUM);
				wait_for_response();
				count++;
			end else if(!resp.req_detected) begin //condition can also be resp.resp_detected && !first time which means that we reciebved the last response 
 				`uvm_info("MBINIT sequence" , "calling the wait for request task ", UVM_MEDIUM);				
				wait_for_request();
				count++;
				//the next code is used to store that we have recieved the done response
				//if (first time = 0) then this means that we have send the done request 
				// if we enter this else if so that means that we recieved a response and of coures it's the done 
				// response because if it's the result response then it would enter seconde else if 
				// if(!first_time) begin // this condition isn't needed as if it's the first time it will enter the prev if 
					recieved_last_respone=1;
				// end
			end
		end

		if(recieved_last_respone) begin
				`uvm_info("MBINIT sequence" , "repair val last response has been recieved and substate has finished", UVM_MEDIUM);
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence" , "repair val last response has been recieved and substate has finished", UVM_MEDIUM);
		end
	endtask : mbinit_repair_val_result_done_hs
		/*------------------------------------------------------------------------------
	--repair val result and done request   
	------------------------------------------------------------------------------*/
	task mbinit_reversal_mb();
		bit first_time=1;
		bit [7:0]msg_subcode=8'h0D;
		int count =3;
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence:reversal MB" ,
			"
			*************************************************************************************************************************************
			**********************************************reversal mb substate result request has started***************************************
			************************************************************************************************************************************* 
			",UVM_MEDIUM);
		send_sb_message_without_data(8'hA5,8'h0D,16'h0000);
		for (int i = 0; i < count; i++) begin
			if( (resp.req_detected) && msg_subcode != 8'h0F) begin
				if(msg_subcode==8'h0D)
					send_sb_message_without_data(8'hAA,msg_subcode,16'h0000);
				else 
					send_sb_message_without_data(8'hAA,msg_subcode,16'h0000,1);
				msg_subcode=msg_subcode+1;
			end else if(resp.resp_detected && first_time) begin
				first_time=0;
				send_sb_message_without_data(8'hA5,8'h0E,16'h0000);
			end else if (!resp.resp_detected) begin //case that should never happens
				`uvm_info("MBINIT sequence:reversal MB" , "calling the wait for response task ", UVM_MEDIUM);
				wait_for_response();
				count++;
			end else if(!resp.req_detected) begin //condition can also be resp.resp_detected && !first time which means that we reciebved the last response 
 				`uvm_info("MBINIT sequence:reversal MB" , "calling the wait for request task ", UVM_MEDIUM);				
				wait_for_request();
				count++;
				recieved_last_respone=1;
			end
		end

		if(recieved_last_respone || resp.resp_detected) begin
				`uvm_info("MBINIT sequence:reversal MB" , "reversal mb last response has been recieved and substate has finished", UVM_MEDIUM);
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence:reversal MB" , "reversal mb last response has been recieved and substate has finished", UVM_MEDIUM);
		end
	endtask : mbinit_reversal_mb
	/*------------------------------------------------------------------------------
	-- reversal MB result handshake  
	------------------------------------------------------------------------------*/
	task mbinit_reversal_mb_result_hs();
		bit recieved_last_respone;
		bit [63:0] data;
		data[16:0]=16'hFFFF;
		`uvm_info("MBINIT sequence" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************reversal MB result handshake has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
		send_sb_message_without_data(8'hA5,8'h0F,16'h0000);
		if(resp.req_detected) begin
			send_sb_message_with_data(8'hAA,8'h0F,16'h0000,data,1);
		end else begin
			recieved_last_respone=1;
			wait_for_request();
			send_sb_message_with_data(8'hAA,8'h0F,16'h0000,data,1);
		end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("MBINIT sequence" , "reversal MB result hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence" , "reversal MB result hand shake has finished",UVM_MEDIUM)
		end
	endtask : mbinit_reversal_mb_result_hs
	/*------------------------------------------------------------------------------
	-- reversal MB done handshake  
	------------------------------------------------------------------------------*/
	task mbinit_reversal_mb_done_hs();
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************reversal MB done handshake has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
		send_sb_message_without_data(8'hA5,8'h10,16'h0000);
		if(resp.req_detected) begin
			send_sb_message_without_data(8'hAA,8'h10,16'h0000,1);
		end else begin
			recieved_last_respone=1;
			wait_for_request();
			send_sb_message_without_data(8'hAA,8'h10,16'h0000,1);
		end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("MBINIT sequence" , "reversal MB done  hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence" , "reversal MB  done hand shake has finished",UVM_MEDIUM)
		end
	endtask : mbinit_reversal_mb_done_hs
	/*------------------------------------------------------------------------------
	-- reversal MB done handshake  
	------------------------------------------------------------------------------*/
	task mbinit_repairmb_init_hs();
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************repair MB done init handshake has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
		send_sb_message_without_data(8'hA5,8'h11,16'h0000);
		if(resp.req_detected) begin
			send_sb_message_without_data(8'hAA,8'h11,16'h0000,1);
		end else begin
			recieved_last_respone=1;
			wait_for_request();
			send_sb_message_without_data(8'hAA,8'h11,16'h0000,1);
		end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("MBINIT sequence" , "reversal MB done  hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence" , "reversal MB  done hand shake has finished",UVM_MEDIUM)
		end
	endtask : mbinit_repairmb_init_hs
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
endclass : MBINIT_sequence

