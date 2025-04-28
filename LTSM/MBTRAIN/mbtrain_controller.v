
module mbtrain_controller (
    //inputs
    	//main control signals 
    	input clk,
    	input rst_n,
    	input i_en, 
	    //input signal from phyretrain after resolving 
	    input [1:0] i_phyretrain_resolved_state, 
	    //input signal from mbinit 
	    input [2:0] i_highest_common_speed,
	    input       i_first_8_tx_lanes_are_functional_mbinit , i_second_8_tx_lanes_are_functional_mbinit,
	    input		i_first_8_rx_lanes_are_functional_mbinit , i_second_8_rx_lanes_are_functional_mbinit,
	    //talking with linkspeed and repair 
	    input       i_first_8_tx_lanes_are_functional_linkspeed , i_second_8_tx_lanes_are_functional_linkspeed,
	    input		i_first_8_rx_lanes_are_functional_repair , i_second_8_rx_lanes_are_functional_repair,
	    //next state flags
		input	i_phy_retrain_req_was_sent_or_received,   i_error_req_was_sent_or_received, 
			    i_speed_degrade_req_was_sent_or_received, i_repair_req_was_sent_or_received,
	    //enable for each substate 
	    input  i_valvref_ack             ,i_data_vref_ack        , i_speed_idle_ack             , i_tx_self_cal_ack   ,
		input  i_rx_clk_cal_ack          ,i_val_train_center_ack , i_val_train_vref_ack         , i_data_train_center_1_ack   ,
		input  i_data_train_vref_ack     ,i_rx_deskew_ack        , i_data_train_center_2_ack    , i_link_speed_ack ,i_repair_ack ,
		input  i_coming_from_L1,
    //outputs 
	    //enable for each substate 
	    output reg  o_valvref_en            ,o_data_vref_en        , o_speed_idle_en             , o_tx_self_cal_en   ,
		output reg  o_rx_clk_cal_en         ,o_val_train_center_en , o_val_train_vref_en         , o_data_train_center_1_en   ,
		output reg  o_data_train_vref_en    ,o_rx_deskew_en        , o_data_train_center_2_en    , o_link_speed_en , o_repair_en , 
		//deciding what to test main band or valid lane 
		output reg o_mainband_or_valtrain_test,
		//phy_retrain_enable
		output reg o_phyretrain_en ,
		//communicating with sideband 
		output reg [3:0] o_sideband_substate ,
		//communicating with pattern generators and detectors 
		output reg       o_first_8_tx_lanes_are_functional , o_second_8_tx_lanes_are_functional,
	    output reg		 o_first_8_rx_lanes_are_functional , o_second_8_rx_lanes_are_functional,
	    //mux sele
	    output reg [2:0] o_mux_sel, //000 vref cal 001 selfcal 010 linkspeed 011 repair 100 train center 101 rx cal 
	    //finishing ack
	    output reg o_mbtrain_ack,
	    //communicating with linkspeed to tell it that a repair was done 
	    output o_comming_from_repair ,
	    //communicating with pll
	    output reg [2:0] o_curret_operating_speed 
);
/*------------------------------------------------------------------------------
-- sideband messages    
------------------------------------------------------------------------------*/
 
/*------------------------------------------------------------------------------
-- FSM States   
------------------------------------------------------------------------------*/
parameter IDLE =0;
parameter VALVREF =1;
parameter VALVREF_END=2;
parameter DATAVREF =3;
parameter SPEED_IDLE =4;
parameter SPEED_IDLE_END =5;
parameter TXSELFCAL =6;
parameter TXSELFCAL_END =7;
parameter RXCLKCAL =8;
parameter RXCLKCAL_END=9;
parameter VALTRAINCENTER =10;
parameter VALTRAINCENTER_END =11;
parameter VALTRAINVREF =12;
parameter VALTRAINVREF_END =13;
parameter DATATRAINCENTER1 =14;
parameter DATATRAINCENTER1_END =15;
parameter DATATRAINVREF =16;
parameter DATATRAINVREF_END =17;
parameter RXDESKEW = 18;
parameter RXDESKEW_END =19 ;
parameter DATATRAINCENTER2 =20 ;
parameter LINKSPEED = 21;
parameter REPAIR = 22;
parameter MBTRAIN_FINISH=23;
/*------------------------------------------------------------------------------
-- Variables Declaration  
------------------------------------------------------------------------------*/
reg [4:0] cs, ns;
//the followig variables will be added in order to handle the case that we enter linkspeed and there was a a repiar that has been 
// done before so if we find only 8 lanes are functional we shouldn't go to the repiar 
reg repiar_was_done_in_mbinit;
reg repiar_was_done_in_mbtrain;
/*------------------------------------------------------------------------------
--assign statements   
------------------------------------------------------------------------------*/
assign o_comming_from_repair =repiar_was_done_in_mbinit || repiar_was_done_in_mbtrain;
/*------------------------------------------------------------------------------
-- Current State Update  
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_cs
    if (~rst_n) cs <= 0;
    else  cs <= ns;
end
/*------------------------------------------------------------------------------
-- Next State Logic   
------------------------------------------------------------------------------*/
always @(*) begin
    case (cs)
        IDLE:begin
        	if(i_en) begin
        		if(i_coming_from_L1) 
        			ns=SPEED_IDLE;
        		else 
	        		case (i_phyretrain_resolved_state)
	        			2'b00:ns=VALVREF;
	        			2'b01:ns=TXSELFCAL;
	        			2'b10:ns=REPAIR;
	        			2'b11:ns=SPEED_IDLE;
	        		endcase
        	end else begin
        		ns=IDLE;
        	end
		end
		VALVREF:begin
			if(i_valvref_ack) begin
				ns=VALVREF_END;
			end else begin
				ns=VALVREF;
			end
		end
		VALVREF_END:begin
			if(~i_valvref_ack) begin
				ns=DATAVREF;
			end else begin
				ns=VALVREF_END;
			end
		end
		DATAVREF:begin
			if(i_data_vref_ack) begin
				ns=SPEED_IDLE;
			end else begin
				ns=DATAVREF;
			end
		end
		SPEED_IDLE:begin
			if(i_speed_idle_ack) begin
				ns=SPEED_IDLE_END;
			end else begin
				ns=SPEED_IDLE;
			end		
		end
		SPEED_IDLE_END:begin
			if(~i_speed_idle_ack) begin
				ns=TXSELFCAL;
			end else begin
				ns=SPEED_IDLE_END;
			end
		end
		TXSELFCAL:begin
			if(i_tx_self_cal_ack) begin
				ns=TXSELFCAL_END;
			end else begin
				ns=TXSELFCAL;
			end
		end
		TXSELFCAL_END:begin
			if(~i_tx_self_cal_ack) begin
				ns=RXCLKCAL;
			end else begin
				ns=TXSELFCAL_END;
			end
		end
		RXCLKCAL:begin
			if(i_rx_clk_cal_ack) begin
				ns=RXCLKCAL_END;
			end else begin
				ns=RXCLKCAL;
			end
		end
		RXCLKCAL_END:begin
			if(~i_rx_clk_cal_ack) begin
				ns=VALTRAINCENTER;
			end else begin
				ns=RXCLKCAL_END;
			end
		end
		VALTRAINCENTER:begin
			if(i_val_train_center_ack) begin
				ns=VALTRAINCENTER_END;
			end else begin
				ns=VALTRAINCENTER;
			end
		end
		VALTRAINCENTER_END:begin
			if(~i_val_train_center_ack) begin
				ns=VALTRAINVREF;
			end else begin
				ns=VALTRAINCENTER_END;
			end
		end
		VALTRAINVREF:begin
			if(i_val_train_vref_ack) begin
				ns=VALTRAINVREF_END;
			end else begin
				ns=VALTRAINVREF;
			end
		end
		VALTRAINVREF_END:begin
			if(~i_val_train_vref_ack) begin
				ns=DATATRAINCENTER1;
			end else begin
				ns=VALTRAINVREF_END;
			end
		end
		DATATRAINCENTER1:begin
			if(i_data_train_center_1_ack) begin
				ns=DATATRAINCENTER1_END;
			end else begin
				ns=DATATRAINCENTER1;
			end
		end
		DATATRAINCENTER1_END:begin
			if(~i_data_train_center_1_ack) begin
				ns=DATATRAINVREF;
			end else begin
				ns=DATATRAINCENTER1_END;
			end
		end
		DATATRAINVREF:begin
			if(i_data_train_vref_ack) begin
				ns=DATATRAINVREF_END;
			end else begin
				ns=DATATRAINVREF;
			end
		end
		DATATRAINVREF_END:begin
			if(~i_data_train_vref_ack) begin
				ns=RXDESKEW;
			end else begin
				ns=DATATRAINVREF_END;
			end
		end
		RXDESKEW:begin
			if(i_rx_deskew_ack) begin
				ns=RXDESKEW_END;
			end else begin
				ns=RXDESKEW;
			end
		end
		RXDESKEW_END:begin
			if(~i_rx_deskew_ack) begin
				ns=DATATRAINCENTER2;
			end else begin
				ns=RXDESKEW_END;
			end
		end
		DATATRAINCENTER2:begin
			if(i_data_train_center_1_ack) begin
				ns=LINKSPEED;
			end else begin
				ns=DATATRAINCENTER2;
			end
		end
		LINKSPEED:begin
			if(i_phy_retrain_req_was_sent_or_received && i_link_speed_ack) begin
				ns=MBTRAIN_FINISH;
			end else if(i_error_req_was_sent_or_received && i_link_speed_ack)begin
				if(i_speed_degrade_req_was_sent_or_received && i_link_speed_ack) begin
					ns=SPEED_IDLE;
				end else begin // else if was removed because of latch and there will be no other event than receiveing repair in case
					           // we didn't receive a speed degrade request 
					ns=REPAIR;
				end 
			end
			else if(i_link_speed_ack)  begin
					ns=MBTRAIN_FINISH;
			end else begin
					ns=LINKSPEED;
			end
		end
		REPAIR:begin
			if(i_repair_ack) begin
				ns=TXSELFCAL;
			end else begin
				ns=REPAIR;
			end
		end
		MBTRAIN_FINISH : begin
			if(!i_en) 
				ns=IDLE;
			else 
				ns=MBTRAIN_FINISH;
		end 
        default: ns = cs;
    endcase
end
/*------------------------------------------------------------------------------
-- Output Logic  
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_output
    if (~rst_n) begin
    	o_valvref_en                 <=0;
    	o_data_vref_en               <=0;
    	o_speed_idle_en              <=0;
    	o_tx_self_cal_en             <=0;
		o_rx_clk_cal_en              <=0;
		o_val_train_center_en        <=0;
		o_val_train_vref_en          <=0;
		o_data_train_center_1_en     <=0;
		o_data_train_vref_en         <=0;
		o_rx_deskew_en               <=0;
		o_data_train_center_2_en     <=0;
		o_link_speed_en              <=0;
		o_repair_en                  <=0;
		o_mbtrain_ack                <=0;
		repiar_was_done_in_mbtrain   <=0;
		o_mainband_or_valtrain_test  <=0;
    end
    else begin
        case (cs)
            IDLE:begin
            	o_valvref_en                 <=0;
		    	o_data_vref_en               <=0;
		    	o_speed_idle_en              <=0;
		    	o_tx_self_cal_en             <=0;
				o_rx_clk_cal_en              <=0;
				o_val_train_center_en        <=0;
				o_val_train_vref_en          <=0;
				o_data_train_center_1_en     <=0;
				o_data_train_vref_en         <=0;
				o_rx_deskew_en               <=0;
				o_data_train_center_2_en     <=0;
				o_link_speed_en              <=0;
				o_repair_en                  <=0;
				o_mbtrain_ack                <=0;
				repiar_was_done_in_mbtrain   <=0;
            	if(ns==VALVREF) begin
            		o_valvref_en<=1;
       				o_sideband_substate<=0;
       				o_mux_sel<=3'b000;
       				o_mainband_or_valtrain_test  <=1;
            	end else if(ns==TXSELFCAL) begin
					o_tx_self_cal_en<=1;
					o_sideband_substate<=3;
					o_mux_sel<=3'b001;
				end else if(ns==REPAIR) begin
					o_repair_en<=1;
					o_link_speed_en<=0;
					o_sideband_substate<=12;
					o_mux_sel<=3'b011;
					repiar_was_done_in_mbtrain<=1;
				end else if(ns==SPEED_IDLE) begin
					o_data_vref_en<=0;
					o_speed_idle_en<=1;
					o_sideband_substate<=2;
					o_mux_sel<=3'b001;
				end
			end
			VALVREF:begin
				if(ns==VALVREF_END) begin
					o_valvref_en<=0;
				end
			end
			VALVREF_END:begin
				if(ns==DATAVREF) begin
					o_data_vref_en <=1;
					o_sideband_substate<=1;
					o_mux_sel<=3'b000;
					o_mainband_or_valtrain_test  <=0;
				end
			end
			DATAVREF:begin
				if(ns==SPEED_IDLE) begin
					o_data_vref_en<=0;
					o_speed_idle_en<=1;
					o_sideband_substate<=2;
					o_mux_sel<=3'b001;
				end
			end
			SPEED_IDLE:begin
				if(ns==SPEED_IDLE_END) begin
					o_speed_idle_en<=0;	
				end
			end
			SPEED_IDLE_END:begin
				if(ns==TXSELFCAL) begin
					o_tx_self_cal_en<=1;
					o_sideband_substate<=3;
					o_mux_sel<=3'b001;
				end
			end
			TXSELFCAL:begin
				if(ns==TXSELFCAL_END) begin
					o_tx_self_cal_en<=0;
				end
			end
			TXSELFCAL_END:begin
				if(ns==RXCLKCAL) begin
					o_rx_clk_cal_en<=1;
					o_sideband_substate<=4;
					o_mux_sel<=3'b101;
				end				
			end
			RXCLKCAL:begin
				if(ns==RXCLKCAL_END) begin
					o_rx_clk_cal_en<=0;
				end
			end
			RXCLKCAL_END:begin
				if(ns==VALTRAINCENTER) begin
					o_val_train_center_en<=1;
					o_sideband_substate<=5;
					o_mux_sel<=3'b100;
					o_mainband_or_valtrain_test  <=1;
				end
			end
			VALTRAINCENTER:begin
				if(ns==VALTRAINCENTER_END) begin
					o_val_train_center_en<=0;
				end
			end
			VALTRAINCENTER_END:begin
				if(ns==VALTRAINVREF) begin
					o_val_train_vref_en<=1;
					o_sideband_substate<=6;
					o_mux_sel<=3'b000;
					o_mainband_or_valtrain_test  <=1;
				end
			end
			VALTRAINVREF:begin
				if(ns==VALTRAINVREF_END) begin
					o_val_train_vref_en<=0;
				end
			end
			VALTRAINVREF_END:begin
				if(ns==DATATRAINCENTER1) begin
					o_data_train_center_1_en<=1;
					o_sideband_substate<=7;
					o_mux_sel<=3'b100;
					o_mainband_or_valtrain_test  <=0;
				end
			end
			DATATRAINCENTER1:begin
				if(ns==DATATRAINCENTER1_END) begin
					o_data_train_center_1_en<=0;
				end
			end
			DATATRAINCENTER1_END:begin
				if(ns==DATATRAINVREF) begin
					o_data_train_vref_en<=1;
					o_sideband_substate<=8;
					o_mux_sel<=3'b000;
					o_mainband_or_valtrain_test  <=0;
				end
			end
			DATATRAINVREF:begin
				if(ns==DATATRAINVREF_END) begin
					o_data_train_vref_en<=0;
				end
			end
			DATATRAINVREF_END:begin
				if(ns==RXDESKEW) begin
					o_rx_deskew_en<=1;
					o_sideband_substate<=9;
					o_mux_sel<=3'b101;
				end
			end
			RXDESKEW:begin
				if(ns==RXDESKEW_END) begin
					o_rx_deskew_en<=0;
				end
			end
			RXDESKEW_END:begin
				if(ns==DATATRAINCENTER2) begin
					o_data_train_center_2_en<=1;
					o_sideband_substate<=10;
					o_mux_sel<=3'b100;
					o_mainband_or_valtrain_test  <=0;
				end
			end
			DATATRAINCENTER2:begin
				if(ns==LINKSPEED) begin
					o_link_speed_en<=1;
					o_data_train_center_2_en<=0;
					o_sideband_substate<=11;
					o_mux_sel<=3'b010;
					o_mainband_or_valtrain_test  <=0;
				end
			end
			LINKSPEED:begin
				if(ns==REPAIR) begin
					o_repair_en<=1;
					o_link_speed_en<=0;
					o_sideband_substate<=12;
					o_mux_sel<=3'b011;
					repiar_was_done_in_mbtrain<=1;
				end else if(ns==TXSELFCAL) begin
					o_tx_self_cal_en<=1;
					o_link_speed_en<=0;
					o_sideband_substate<=3;
					o_mux_sel<=3'b001;
				end else if(ns==SPEED_IDLE) begin 
					o_speed_idle_en<=1;
					o_link_speed_en<=0;
					o_sideband_substate<=2;
					o_mux_sel<=3'b001;
				end else if(ns==MBTRAIN_FINISH) begin
					o_link_speed_en<=0;
					o_sideband_substate<=0;
				end
				//controling phyretrain 
				if(ns==MBTRAIN_FINISH && i_phy_retrain_req_was_sent_or_received)
					o_phyretrain_en<=1;
				else 
					o_phyretrain_en<=0;
			end
			REPAIR:begin
				if(ns==TXSELFCAL) begin
					o_tx_self_cal_en<=1;
					o_repair_en<=0;
					o_sideband_substate<=3; //changed from repair parameter to 3 that represents tx self cal encoding
					o_mux_sel<=3'b001;
				end
			end
			MBTRAIN_FINISH:begin
				o_mbtrain_ack<=1;
			end
            default: /* default */;
        endcase
    end
end
/*------------------------------------------------------------------------------
--handling current operating speed   
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_o_curret_operating_speed
	if(~rst_n) begin
		o_curret_operating_speed <= 0;
	end else if (cs==IDLE && ns == VALVREF)begin
		o_curret_operating_speed <= i_highest_common_speed;
	end else if ( (cs == LINKSPEED || cs==IDLE) && ns==SPEED_IDLE && ~i_coming_from_L1) begin
		o_curret_operating_speed<= o_curret_operating_speed-1;
	end 
end
/*------------------------------------------------------------------------------
--handling widths of the tx and rx lanes  
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_
	if(~rst_n) begin
		o_first_8_tx_lanes_are_functional  <=0;
		o_second_8_tx_lanes_are_functional <=0;
		o_first_8_rx_lanes_are_functional  <=0;
		o_second_8_rx_lanes_are_functional <=0;
	end else if (cs==IDLE && ns==VALVREF) begin
		o_first_8_tx_lanes_are_functional  <=i_first_8_tx_lanes_are_functional_mbinit;
		o_second_8_tx_lanes_are_functional <=i_second_8_tx_lanes_are_functional_mbinit;
		o_first_8_rx_lanes_are_functional  <=i_first_8_rx_lanes_are_functional_mbinit;
		o_second_8_rx_lanes_are_functional <=i_second_8_rx_lanes_are_functional_mbinit;
	end else if(cs==LINKSPEED && ns!=LINKSPEED) begin 
		//in here we decide the tx results as we know it after the point test results so we know now the functional
		//lanes that we can send data on them and this result will no be changed after repair as in the repair i am only 
		//telling the remote partner which lanse will i send data on  
		o_first_8_tx_lanes_are_functional <=i_first_8_tx_lanes_are_functional_linkspeed;
		o_second_8_tx_lanes_are_functional<=i_second_8_tx_lanes_are_functional_linkspeed;
	end else if(cs==REPAIR && ns!=REPAIR) begin
		o_first_8_rx_lanes_are_functional <=i_first_8_rx_lanes_are_functional_repair;
		o_second_8_rx_lanes_are_functional<=i_second_8_rx_lanes_are_functional_repair;
	end
end
/*------------------------------------------------------------------------------
--  handling repair was done signals 
------------------------------------------------------------------------------*/
always @(posedge clk or negedge rst_n) begin : proc_repair_was_done_in_mbinit
	if(~rst_n) begin
		repiar_was_done_in_mbinit <= 0;
	end else if(cs==IDLE && ns==VALVREF && (~i_first_8_tx_lanes_are_functional_mbinit ||  ~i_second_8_tx_lanes_are_functional_mbinit) ) begin
		repiar_was_done_in_mbinit <= 1 ;
	end else if(cs==MBTRAIN_FINISH) 
		repiar_was_done_in_mbinit <= 0 ; 
end
endmodule 