class MBINIT_base_class extends   uvm_sequence #(sideband_sequence_item);
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
endclass : MBINIT_base_class
/*------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------*/
// class  extends MBINIT_base_class;
// 	`uvm_object_utils()
// 	task body();

// 	endtask : body
// endclass : 
/*------------------------------------------------------------------------------
-- mbinit_param
------------------------------------------------------------------------------*/
class mbinit_param extends MBINIT_base_class;
	`uvm_object_utils(mbinit_param)
	task body();
		bit clock_phase ,clock_mode;
		bit [4:0] voltage_swing ;
		bit [3:0] max_link_speed;
		bit [63:0] data;
		`uvm_info("MBINIT sequence:param substate" ,
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
				`uvm_info("MBINIT sequence:param substate" , "param substate has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("MBINIT sequence:param substate" , "param substate has been finished",UVM_MEDIUM)
			end

	endtask : body
endclass : mbinit_param
/*------------------------------------------------------------------------------
-- mbinit_cal
------------------------------------------------------------------------------*/
class mbinit_cal extends MBINIT_base_class;
	`uvm_object_utils(mbinit_cal)
	task body();
		`uvm_info("MBINIT sequence:cal substae" ,
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
				`uvm_info("MBINIT sequence:cal substae" , "cal substate has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("MBINIT sequence:cal substae" , "cal substate has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbinit_cal
/*------------------------------------------------------------------------------
-- mbinit_repair_clk_init_hs
------------------------------------------------------------------------------*/
class mbinit_repair_clk_init_hs extends MBINIT_base_class;
	`uvm_object_utils(mbinit_repair_clk_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence:repair clock" ,
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
			`uvm_info("MBINIT sequence:repair clock" , "repair clock init hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence:repair clock" , "repair clock init hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : mbinit_repair_clk_init_hs
/*------------------------------------------------------------------------------
-- mbinit_repair_clk_result_done_hs
------------------------------------------------------------------------------*/
class mbinit_repair_clk_result_done_hs extends MBINIT_base_class;
	`uvm_object_utils(mbinit_repair_clk_result_done_hs)
	task body();
		bit first_time=1;
		bit [15:0] msg_info=16'h0007;
		bit [7:0]msg_subcode=8'h04;
		int count =3;
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence:repair clock" ,
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
				`uvm_info("MBINIT sequence:repair clock" , "calling the wait for response task ", UVM_MEDIUM);
				wait_for_response();
				count++;
			end else if(!resp.req_detected) begin
				`uvm_info("MBINIT sequence:repair clock" , "calling the wait for request task ", UVM_MEDIUM);				
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
				`uvm_info("MBINIT sequence:repair clock" , "repair clock last response has been recieved and substate has finished", UVM_MEDIUM);
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence:repair clock" , "repair clock last response has been recieved and substate has finished", UVM_MEDIUM);
		end
	endtask : body
endclass : mbinit_repair_clk_result_done_hs
/*------------------------------------------------------------------------------
-- mbinit_repair_val_init_hs
------------------------------------------------------------------------------*/
class mbinit_repair_val_init_hs extends MBINIT_base_class;
	`uvm_object_utils(mbinit_repair_val_init_hs)
	task body();
		bit recieved_last_respone=0;
		`uvm_info("MBINIT sequence:repair val" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************repair val substate has started**********************************************************
			********************************************************************************************************************************************************** 
			",UVM_MEDIUM);
			send_sb_message_without_data(8'hA5,8'h09,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hAA,8'h09,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hAA,8'h09,16'h0000);
			end
		if(resp.resp_detected || recieved_last_respone) begin 
			`uvm_info("MBINIT sequence:repair val" , "repair val init hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence:repair val" , "repair val init hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : mbinit_repair_val_init_hs
/*------------------------------------------------------------------------------
-- mbinit_repair_val_result_done_hs
------------------------------------------------------------------------------*/
class mbinit_repair_val_result_done_hs extends MBINIT_base_class;
	`uvm_object_utils(mbinit_repair_val_result_done_hs)
	task body();
		bit first_time=1;
		bit unanswered_req;
		bit [15:0] msg_info=16'h0001;
		bit [7:0]msg_subcode=8'h0A;
		int count =3;
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence:repair val" ,
			"
			*************************************************************************************************************************************
			**********************************************repair val substate result request has started***************************************
			************************************************************************************************************************************* 
			",UVM_MEDIUM);
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
				`uvm_info("MBINIT sequence:repair val" , "calling the wait for response task ", UVM_MEDIUM);
				wait_for_response();
				count++;
			end else if(!resp.req_detected) begin //condition can also be resp.resp_detected && !first time which means that we reciebved the last response 
 				`uvm_info("MBINIT sequence:repair val" , "calling the wait for request task ", UVM_MEDIUM);				
				wait_for_request();
				count++;
				//the next code is used to store that we have recieved the done response
				//if (first time = 0) then this means that we have send the done request 
				// if we enter this else if so that means that we recieved a response and of coures it's the done 
				// response because if it's the result response then it would enter seconde else if 
					recieved_last_respone=1;
			end
		end

		if(recieved_last_respone) begin
				`uvm_info("MBINIT sequence:repair val" , "repair val last response has been recieved and substate has finished", UVM_MEDIUM);
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence:repair val" , "repair val last response has been recieved and substate has finished", UVM_MEDIUM);
		end
	endtask : body
endclass : mbinit_repair_val_result_done_hs
/*------------------------------------------------------------------------------
-- mbinit_reversal_mb
------------------------------------------------------------------------------*/
class mbinit_reversal_mb  extends MBINIT_base_class;
	`uvm_object_utils(mbinit_reversal_mb)
	task body();
		bit first_time=1;
		bit [7:0]msg_subcode=8'h0D;
		int count =3;
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence:reversal mb" ,
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
				`uvm_info("MBINIT sequence:reversal mb" , "calling the wait for response task ", UVM_MEDIUM);
				wait_for_response();
				count++;
			end else if(!resp.req_detected) begin //condition can also be resp.resp_detected && !first time which means that we reciebved the last response 
 				`uvm_info("MBINIT sequence:reversal mb" , "calling the wait for request task ", UVM_MEDIUM);				
				wait_for_request();
				count++;
				recieved_last_respone=1;
			end
		end

		if(recieved_last_respone || resp.resp_detected) begin
				`uvm_info("MBINIT sequence:reversal mb" , "reversal mb last response has been recieved and substate has finished", UVM_MEDIUM);
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence:reversal mb" , "reversal mb last response has been recieved and substate has finished", UVM_MEDIUM);
		end
	endtask : body
endclass : mbinit_reversal_mb

/*------------------------------------------------------------------------------
-- mbinit_reversal_mb_result_hs
------------------------------------------------------------------------------*/
class mbinit_reversal_mb_result_hs extends MBINIT_base_class;
	`uvm_object_utils(mbinit_reversal_mb_result_hs)
	task body();
		bit recieved_last_respone;
		bit [63:0] data;
		data[16:0]=16'hFFFF;
		`uvm_info("MBINIT sequence:reversal mb" ,
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
			`uvm_info("MBINIT sequence:reversal mb" , "reversal MB result hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence:reversal mb" , "reversal MB result hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : mbinit_reversal_mb_result_hs
/*------------------------------------------------------------------------------
-- mbinit_reversal_mb_done_hs
------------------------------------------------------------------------------*/
class mbinit_reversal_mb_done_hs  extends MBINIT_base_class;
	`uvm_object_utils(mbinit_reversal_mb_done_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence:reversal mb" ,
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
			`uvm_info("MBINIT sequence:reversal mb" , "reversal MB done  hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence:reversal mb" , "reversal MB  done hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : mbinit_reversal_mb_done_hs
/*------------------------------------------------------------------------------
-- repair MB done handshake  
------------------------------------------------------------------------------*/
class mbinit_repair_mb_init_hs extends MBINIT_base_class;
	`uvm_object_utils(mbinit_repair_mb_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("MBINIT sequence:repair mb" ,
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
			`uvm_info("MBINIT sequence:repair mb" , "repair MB init hand shake has finished",UVM_MEDIUM)
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence:repair mb" , "repair MB init hand shake has finished",UVM_MEDIUM)
		end
	endtask : body
endclass : mbinit_repair_mb_init_hs
/*------------------------------------------------------------------------------
--repair mb apply degrade and done hs 
------------------------------------------------------------------------------*/
class mbinit_repair_mb_done_hs extends MBINIT_base_class;
	`uvm_object_utils(mbinit_repair_mb_done_hs)
	task body();
bit first_time=1;
		bit [7:0]msg_subcode=8'h14;
		int count =3;
		bit recieved_last_respone;
		bit [15:0] msg_info;
		`uvm_info("MBINIT sequence:repair mb" ,
			"
			*************************************************************************************************************************************
			********************************************** apply deggrade and done handshakes  has started*************************************************
			************************************************************************************************************************************* 
			" ,UVM_MEDIUM);
		msg_info[2:0]=3'b011; //valid lane and accumulative result
		send_sb_message_without_data(8'hA5,8'h14,msg_info);
		for (int i = 0; i < count; i++) begin
			if( (resp.req_detected) && msg_subcode != 8'h12) begin
				if(msg_subcode==8'h14)
					send_sb_message_without_data(8'hAA,msg_subcode,16'h0000);
				else 
					send_sb_message_without_data(8'hAA,msg_subcode,16'h0000,1);
				msg_subcode=msg_subcode-1;
			end else if(resp.resp_detected && first_time) begin
				first_time=0;
				send_sb_message_without_data(8'hA5,8'h13,16'h0000);       // Edited by yahya
			end else if (!resp.resp_detected) begin //case that should never happens
				`uvm_info("MBINIT sequence:repair mb" , "calling the wait for response task ", UVM_MEDIUM);
				wait_for_response();
				count++;
			end else if(!resp.req_detected) begin //condition can also be resp.resp_detected && !first time which means that we reciebved the last response 
 				`uvm_info("MBINIT sequence:repair mb" , "calling the wait for request task ", UVM_MEDIUM);				
				wait_for_request();
				count++;
				recieved_last_respone=1;
			end
		end

		if(recieved_last_respone || resp.resp_detected) begin
				`uvm_info("MBINIT sequence:repair mb" , "mbinit repair mainband apply degrade and done handshakes last response has been recieved and substate has finished", UVM_MEDIUM);
		end else begin
			wait_for_response();
			`uvm_info("MBINIT sequence:repair mb" , "mbinit repair mainband apply degrade and done handshakes last response has been recieved and substate has finished", UVM_MEDIUM);
		end
	endtask : body
endclass : mbinit_repair_mb_done_hs