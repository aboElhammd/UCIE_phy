module SB_TX_FSM_Modelling (
    input i_clk,    // Clock
    input i_rst_n,  // Asynchronous reset active low
    input i_ser_done, // Serialization done signal
    input i_empty, // FIFO empty signal
    input i_packet_finished, // Packet finished signal
    input i_read_enable_sampled,
    output reg o_read_enable, // Read enable signal
    output reg o_clk_en // Clock enable signal
);

reg read_enable_comb; // Read enable signal
reg clk_en_comb; // Clock enable signal

localparam IDLE = 2'b00;
localparam SENDING_PACK = 2'b01;
localparam SLEEPING = 2'b10;

reg [1:0] cs, ns; // Current state and next state

// Next state logic
always @(*) begin 
    case (cs)
        IDLE: begin
            if (~i_empty) // not fifo empty
                ns = SENDING_PACK;
            else 
                ns = IDLE;
        end

        SENDING_PACK: begin
            if (i_ser_done)
                ns = SLEEPING;
            else 
                ns = SENDING_PACK;
        end 

        SLEEPING: begin
            if (!i_empty && !i_packet_finished)
                ns = SENDING_PACK;
            else 
                ns = SLEEPING;
        end

        default: ns = IDLE;
    endcase
end

// // Output logic
// always @(*) begin 
//     // Default values for outputs
//     read_enable_comb = 0;
//     clk_en_comb = 0;

//     case (cs)
//         // IDLE: begin
//         //     if (ns == SENDING_PACK)
//         //         read_enable_comb = 1; 
//         // end

//         SENDING_PACK: begin
//             if (ns == SENDING_PACK) begin 
//                 clk_en_comb = 1;
//             end
//             else if (ns == SLEEPING) begin
//                 clk_en_comb = 0;
//             end
//         end 

//         // SLEEPING: begin
//         //     if (ns == SENDING_PACK)
//         //         read_enable_comb = 1;
//         // end

//     endcase
// end

// State transition (update current state)
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n)
        cs <= IDLE;
    else
        cs <= ns;
end

always @(posedge i_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		o_clk_en <= 0;
	end else if((cs == SENDING_PACK && ns == SENDING_PACK) && i_read_enable_sampled) begin
		o_clk_en <= 1;
	end
	else begin
		o_clk_en <= 0;
	end
end

always @(posedge i_clk or negedge i_rst_n) begin 
	if(~i_rst_n) begin
		o_read_enable <= 0;
	end else if((cs == IDLE || cs == SLEEPING) && ns == SENDING_PACK) begin
		o_read_enable <= 1;
	end
	else if (i_read_enable_sampled) begin
		o_read_enable <= 0;
	end
end



endmodule : SB_TX_FSM_Modelling