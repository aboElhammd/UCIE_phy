class sideband_driver extends  uvm_driver #(sideband_sequence_item);
	`uvm_component_utils(sideband_driver)
	virtual sideband_interface sb_vif_intf;
	bit new_req, new_resp , sb_pattern_detected;
	sideband_sequence_item trans,resp;
		int count=0;
	/*------------------------------------------------------------------------------
	--new  
	------------------------------------------------------------------------------*/
	function  new(string name="sideband_driver",uvm_component parent=null);
			super.new(name,parent);
	endfunction : new
	/*------------------------------------------------------------------------------
	--build phase   
	------------------------------------------------------------------------------*/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual sideband_interface)::get(this, "", "my_vif",sb_vif_intf )) 
			`uvm_fatal(get_full_name ,"ERROR")
	endfunction : build_phase
	/*------------------------------------------------------------------------------
	--run phase   
	------------------------------------------------------------------------------*/
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		trans=sideband_sequence_item::type_id::create("trans",this);
		resp=sideband_sequence_item::type_id::create("resp",this);
		fork
			forever begin
				seq_item_port.get_next_item(trans);
				if(trans.wait_for_request ) begin
					`uvm_info(get_full_name , "by order of sequence : waiting for new request " ,UVM_MEDIUM);
					wait(new_req);
					`uvm_info(get_full_name , "new request has come" ,UVM_MEDIUM);
				end else if (trans.wait_for_response ) begin
					`uvm_info(get_full_name , "by order of sequence : waiting for new response " ,UVM_MEDIUM);
					wait(new_resp);
					`uvm_info(get_full_name , "new response has come" ,UVM_MEDIUM);
				end else begin
					// //decoding delay 
					if (!trans.pattern_packet) begin
						repeat(25)
							@(posedge sb_vif_intf.clk);
					end
					drive_item(trans);
					if(~trans.pattern_packet && ~trans.separate_packet && ~trans.end_of_sequence) begin
						`uvm_info(get_full_name , "waiting for new req or new resp" ,UVM_MEDIUM);
						if(~new_req && ~new_resp)
							wait(new_req || new_resp);				
					end else begin
						`uvm_info(get_full_name , "sending a packet that doesn't wait for new request or new response" ,UVM_MEDIUM);
					end

					`uvm_info(get_full_name , "trans has ended " ,UVM_MEDIUM);
				end
				#1
				sample_item(resp, trans.end_of_sequence);
				resp.set_id_info(trans);
				// #5;
				// if(new_req) begin
				// 	new_req=0;
				// end else if(new_resp) begin
				// 	new_resp=0;
				// end
				seq_item_port.item_done(resp);
			end
			check_for_new_request();
			check_for_new_response();
			check_for_sb_pattern_detection();
		join
	endtask : run_phase
	/*------------------------------------------------------------------------------
	--check for requese and responses tasks   
	------------------------------------------------------------------------------*/
	task check_for_new_request();
		forever begin
			wait (sb_vif_intf.clk_ser_en);
			if(sb_vif_intf.fifo_data_out[31:29] == 3'b010 // to be sure that it's not phase 2 and 3 of data packet 
			&& sb_vif_intf.fifo_data_out[14]
			&& sb_vif_intf.fifo_data_out[55:51]==4'b0000) begin
				new_req=1;
			end	
			wait (!sb_vif_intf.clk_ser_en);
		end
	endtask : check_for_new_request
	task check_for_new_response();
		forever begin
			wait(sb_vif_intf.clk_ser_en);
			if(sb_vif_intf.fifo_data_out[31:29] == 3'b010 // to be sure that it's not phase 2 and 3 of data packet 
			&& ~sb_vif_intf.fifo_data_out[14]
			&& sb_vif_intf.fifo_data_out[55:51]==4'b0000) begin
				new_resp=1;
			end
			wait (!sb_vif_intf.clk_ser_en);
		end
	endtask : check_for_new_response
		task check_for_sb_pattern_detection();
		int flag_1=1;
		forever begin
			//wait(sb_vif_intf.clk_ser_en);
			@(posedge  sb_vif_intf.clk)
			if(flag_1&&sb_vif_intf.fifo_data_out=={32{2'b10}} && sb_vif_intf.clk_ser_en) begin
				count++;
				flag_1=0;
			end else if(sb_vif_intf.pack_finished) begin
				flag_1=1;
			end
			if(count>=2) begin
				sb_pattern_detected=1;
			end
			#1;
		end
	endtask : check_for_sb_pattern_detection
	/*------------------------------------------------------------------------------
	--driving task  
	------------------------------------------------------------------------------*/
	task drive_item(sideband_sequence_item trans);
		// //encoding delay 
			if (!trans.pattern_packet) begin
				repeat(25)
					@(posedge sb_vif_intf.clk);
			end

		//waititng for 64 cycle to mimics the serializer delay
			for (int i = 0; i < 64; i++) begin
				@(posedge sb_vif_intf.clk);
			end
		//checks if it's a data packet or control packet
			if(  trans.pattern_packet) begin
				sb_vif_intf.deser_data=trans.data;
			end else begin
				sb_vif_intf.deser_data={ 
										//phase 1 of control word 	
											 trans.dp , trans.cp , 3'b000 , trans.dst_id,
										     trans.msg_info , trans.msg_subcode, 
										//phase 0 of control word
											 trans.src_id , 7'b000_0000 ,trans.msg_code , 9'b0000_0000_0 ,
										     trans.opcode 
	 									};
			end
			sb_vif_intf.de_ser_done=1'b1;
		//32 cycle low that should be between each 2 concsective sideband packet
			for (int i = 0; i < 32; i++) begin
				@(posedge sb_vif_intf.clk);
				if(sb_vif_intf.de_ser_done_sampled )
					sb_vif_intf.de_ser_done=1'b0;
			end

		//additional code to send phase 2 and 3 which represents data part of the packer
			if(trans.data_packet) begin
				// //encoding delay 
					if (!trans.pattern_packet) begin
						repeat(25)
							@(posedge sb_vif_intf.clk);
					end
				//waititng for 64 cycle to mimics the serializer delay
					for (int i = 0; i < 64; i++) begin
						@(posedge sb_vif_intf.clk);
					end
				//sending data 
					sb_vif_intf.deser_data=trans.data;
					sb_vif_intf.de_ser_done=1'b1;
				//waiting 32 cycle low 
					for (int i = 0; i < 32; i++) begin
					@(posedge sb_vif_intf.clk);
					if(sb_vif_intf.de_ser_done_sampled )
						sb_vif_intf.de_ser_done=1'b0;
			end
		end
	endtask : drive_item
	/*------------------------------------------------------------------------------
	--sampling item task   
	------------------------------------------------------------------------------*/
	task sample_item(ref sideband_sequence_item resp, bit end_of_sequence);
		@(sb_vif_intf.cb_monitor)
		resp.msg_code= sb_vif_intf.fifo_data_out[21:14] ;
		resp.msg_subcode=sb_vif_intf.fifo_data_out[39:32];
		resp.pattern_detected=sb_pattern_detected;
		if(~end_of_sequence)begin
			if(new_req) begin
				resp.req_detected=new_req;
				#2 
				new_req=0;
				resp.resp_detected=0;
			end else if (new_resp) begin 
				resp.resp_detected=new_resp;
				#2 
				new_resp=0;
				resp.req_detected=0;
			end
		end else begin
			resp.req_detected=0;
			resp.resp_detected=0;
		end
	endtask : sample_item
endclass : sideband_driver
