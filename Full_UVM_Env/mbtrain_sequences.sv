class MBTRAIN_base_class extends   uvm_sequence #(sideband_sequence_item);
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
endclass : MBTRAIN_base_class
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain valvref  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain valvref init hs
------------------------------------------------------------------------------*/
class mbtrain_valvref_init_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_valvref_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_valvref:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain valvref init handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h00,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h00,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h00,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_valvref:" , "mbtrain valvref init handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_valvref:" , "mbtrain valvref init handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_valvref_init_hs
/*------------------------------------------------------------------------------
-- mbtrain valvref done hs
------------------------------------------------------------------------------*/
class mbtrain_valvref_done_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_valvref_done_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_valvref:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain valvref done handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h01,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h01,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h01,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_valvref:" , "mbtrain valvref done handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_valvref:" , "mbtrain valvref done handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_valvref_done_hs
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain datavref  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain datavref init hs
------------------------------------------------------------------------------*/
class mbtrain_datavref_init_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_datavref_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_datavref:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain datavref init handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h02,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h02,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h02,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_datavref:" , "mbtrain datavref init handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_datavref:" , "mbtrain datavref init handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_datavref_init_hs
/*------------------------------------------------------------------------------
-- mbtrain datavref done hs
------------------------------------------------------------------------------*/
class mbtrain_datavref_done_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_datavref_done_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_datavref:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain datavref done handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h03,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h03,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h03,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_datavref:" , "mbtrain datavref done handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_datavref:" , "mbtrain datavref done handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_datavref_done_hs
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain speed_idle  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain speed_idle hs
------------------------------------------------------------------------------*/
class mbtrain_speed_idle_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_speed_idle_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_speed_idle:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain speed_idle handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h04,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h04,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h04,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_speed_idle:" , "mbtrain speed_idle handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_speed_idle:" , "mbtrain speed_idle handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_speed_idle_hs
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain tx_self_cal  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain tx_self_cal hs
------------------------------------------------------------------------------*/
class mbtrain_tx_self_cal_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_tx_self_cal_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_tx_self_cal:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain tx_self_cal handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h05,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h05,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h05,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_tx_self_cal:" , "mbtrain tx_self_cal handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_tx_self_cal:" , "mbtrain tx_self_cal handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_tx_self_cal_hs
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain rx_clk_cal  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain rx_clk_cal hs
------------------------------------------------------------------------------*/
class mbtrain_rx_clk_cal extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_rx_clk_cal)
	task body();
		bit first_time=1;
		bit [15:0] msg_info=16'h0000;
		bit [7:0]msg_subcode=8'h06;
		int count =3;
		bit recieved_last_respone;
		`uvm_info("MBTRAIN sequence : rx clk cal" ,
			"
			*************************************************************************************************************************************
			**********************************************rx clk cal substate result request has started***************************************
			************************************************************************************************************************************* 
			",UVM_MEDIUM);
		send_sb_message_without_data(8'hB5,8'h06,16'h0000);
		for (int i = 0; i < count; i++) begin
			if( (resp.req_detected) && msg_subcode != 8'h08) begin
				if(msg_subcode==8'h0A)
					send_sb_message_without_data(8'hBA,msg_subcode,msg_info);
				else 
					send_sb_message_without_data(8'hBA,msg_subcode,msg_info,1);
				msg_subcode=msg_subcode+1;
			end else if(resp.resp_detected && first_time) begin
				first_time=0;
				send_sb_message_without_data(8'hB5,8'h07,16'h0000);
			end else if (!resp.resp_detected) begin //case that should never happens
				`uvm_info("MBTRAIN sequence : rx clk cal" , "calling the wait for response task ", UVM_MEDIUM);
				wait_for_response();
				count++;
			end else if(!resp.req_detected) begin //condition can also be resp.resp_detected && !first time which means that we reciebved the last response 
 				`uvm_info("MBTRAIN sequence : rx clk cal" , "calling the wait for request task ", UVM_MEDIUM);				
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
				`uvm_info("MBTRAIN sequence : rx clk cal" , "rx clk cal last response has been recieved and substate has finished", UVM_MEDIUM);
		end else begin
			wait_for_response();
			`uvm_info("MBTRAIN sequence : rx clk cal" , "rx clk cal last response has been recieved and substate has finished", UVM_MEDIUM);
		end
	endtask : body
endclass : mbtrain_rx_clk_cal
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain val_center  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain val_center init hs
------------------------------------------------------------------------------*/
class mbtrain_val_center_init_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_val_center_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_val_center:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain val_center init handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h08,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h08,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h08,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_val_center:" , "mbtrain val_center init handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_val_center:" , "mbtrain val_center init handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_val_center_init_hs
/*------------------------------------------------------------------------------
-- mbtrain val_center done hs
------------------------------------------------------------------------------*/
class mbtrain_val_center_done_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_val_center_done_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_val_center:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain val_center done handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h09,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h09,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h09,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_val_center:" , "mbtrain val_center done handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_val_center:" , "mbtrain val_center done handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_val_center_done_hs
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain valtrain_vref  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain valtrain_vref init hs
------------------------------------------------------------------------------*/
class mbtrain_valtrain_vref_init_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_valtrain_vref_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_valtrain_vref:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain valtrain_vref init handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h0A,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h0A,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h0A,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_valtrain_vref:" , "mbtrain valtrain_vref init handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_valtrain_vref:" , "mbtrain valtrain_vref init handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_valtrain_vref_init_hs
/*------------------------------------------------------------------------------
-- mbtrain valtrain_vref done hs
------------------------------------------------------------------------------*/
class mbtrain_valtrain_vref_done_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_valtrain_vref_done_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_valtrain_vref:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain valtrain_vref done handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h0B,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h0B,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h0B,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_valtrain_vref:" , "mbtrain valtrain_vref done handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_valtrain_vref:" , "mbtrain valtrain_vref done handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_valtrain_vref_done_hs
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain datatrain_center_1  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain datatrain_center_1 init hs
------------------------------------------------------------------------------*/
class mbtrain_datatrain_center_1_init_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_datatrain_center_1_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_datatrain_center_1:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain datatrain_center_1 init handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h0C,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h0C,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h0C,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_datatrain_center_1:" , "mbtrain datatrain_center_1 init handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_datatrain_center_1:" , "mbtrain datatrain_center_1 init handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_datatrain_center_1_init_hs
/*------------------------------------------------------------------------------
-- mbtrain datatrain_center_1 done hs
------------------------------------------------------------------------------*/
class mbtrain_datatrain_center_1_done_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_datatrain_center_1_done_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_datatrain_center_1:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain datatrain_center_1 done handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h0D,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h0D,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h0D,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_datatrain_center_1:" , "mbtrain datatrain_center_1 done handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_datatrain_center_1:" , "mbtrain datatrain_center_1 done handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_datatrain_center_1_done_hs
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain datatrain_vref  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain datatrain_vref init hs
------------------------------------------------------------------------------*/
class mbtrain_datatrain_vref_init_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_datatrain_vref_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_datatrain_vref:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain datatrain_vref init handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h0E,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h0E,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h0E,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_datatrain_vref:" , "mbtrain datatrain_vref init handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_datatrain_vref:" , "mbtrain datatrain_vref init handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_datatrain_vref_init_hs
/*------------------------------------------------------------------------------
-- mbtrain datatrain_vref done hs
------------------------------------------------------------------------------*/
class mbtrain_datatrain_vref_done_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_datatrain_vref_done_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_datatrain_vref:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain datatrain_vref done handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h10,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h10,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h10,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_datatrain_vref:" , "mbtrain datatrain_vref done handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_datatrain_vref:" , "mbtrain datatrain_vref done handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_datatrain_vref_done_hs
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain rx_deskew  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain rx_deskew init hs
------------------------------------------------------------------------------*/
class mbtrain_rx_deskew_init_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_rx_deskew_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_rx_deskew:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain rx_deskew init handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h11,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h11,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h11,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_rx_deskew:" , "mbtrain rx_deskew init handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_rx_deskew:" , "mbtrain rx_deskew init handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_rx_deskew_init_hs
/*------------------------------------------------------------------------------
-- mbtrain rx_deskew done hs
------------------------------------------------------------------------------*/
class mbtrain_rx_deskew_done_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_rx_deskew_done_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_rx_deskew:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain rx_deskew done handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h12,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h12,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h12,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_rx_deskew:" , "mbtrain rx_deskew done handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_rx_deskew:" , "mbtrain rx_deskew done handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_rx_deskew_done_hs
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain datatrain_center_2  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain datatrain_center_2 init hs
------------------------------------------------------------------------------*/
class mbtrain_datatrain_center_2_init_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_datatrain_center_2_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_datatrain_center_2:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain datatrain_center_2 init handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h13,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h13,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h13,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_datatrain_center_2:" , "mbtrain datatrain_center_2 init handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_datatrain_center_2:" , "mbtrain datatrain_center_2 init handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_datatrain_center_2_init_hs
/*------------------------------------------------------------------------------
-- mbtrain datatrain_center_2 done hs
------------------------------------------------------------------------------*/
class mbtrain_datatrain_center_2_done_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_datatrain_center_2_done_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_datatrain_center_2:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain datatrain_center_2 done handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h14,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h14,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h14,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_datatrain_center_2:" , "mbtrain datatrain_center_2 done handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_datatrain_center_2:" , "mbtrain datatrain_center_2 done handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_datatrain_center_2_done_hs
/*----------------------------------------------------------------------------------------------------------------------
--                                                 mbtrain linkspeed  
----------------------------------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------
-- mbtrain linkspeed init hs
------------------------------------------------------------------------------*/
class mbtrain_linkspeed_init_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_linkspeed_init_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_linkspeed:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain linkspeed init handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h15,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h15,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h15,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_linkspeed:" , "mbtrain linkspeed init handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_linkspeed:" , "mbtrain linkspeed init handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_linkspeed_init_hs
/*------------------------------------------------------------------------------
-- mbtrain linkspeed done hs
------------------------------------------------------------------------------*/
class mbtrain_linkspeed_done_hs extends MBTRAIN_base_class;
	`uvm_object_utils(mbtrain_linkspeed_done_hs)
	task body();
		bit recieved_last_respone;
		`uvm_info("mbtrain_linkspeed:" ,
			"
			**********************************************************************************************************************************************************
			************************************************************************mbtrain linkspeed done handshake**********************************************************
			********************************************************************************************************************************************************** 
			", UVM_MEDIUM);
			send_sb_message_without_data(8'hB5,8'h19,16'h0000);
			if(resp.resp_detected) 
				recieved_last_respone=1;
			if(resp.req_detected) begin
				send_sb_message_without_data(8'hBA,8'h19,16'h0000);
			end else begin
				wait_for_request();
				send_sb_message_without_data(8'hBA,8'h19,16'h0000);
			end
			if(resp.resp_detected) begin
				`uvm_info("mbtrain_linkspeed:" , "mbtrain linkspeed done handshake has been finished",UVM_MEDIUM)
			end else begin
				wait_for_response();
				`uvm_info("mbtrain_linkspeed:" , "mbtrain linkspeed done handshake has been finished",UVM_MEDIUM)
			end
	endtask : body
endclass : mbtrain_linkspeed_done_hs