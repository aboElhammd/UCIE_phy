module clock_generator (
    input                           i_local_ckp,    // pll clock / 2
    input                           i_local_ckn,
    input                           i_sys_clk,      // pll clock /32 --> local ckp/16
    input                           i_rst_n,        // should be synchronous to dig_clk
    input                           i_rst_ckp_n,    // should be synchronous to local_ckp
    input                           i_start_clk_training,
    output                          o_CKP,
    output                          o_CKN,
    output                          o_TRACK,
    output  reg                     o_done
);
/********************************************************************************
* Internal wires and registers
********************************************************************************/
reg [6:0] iteration_counter;
reg [4:0] gating_counter;
reg CS,NS;
reg EN;
reg start_traning_reg;
/********************************************************************************
* FSM States
********************************************************************************/
localparam NORMAL_STATE = 1'b0;
localparam TRAIN_STATE  = 1'b1;
/********************************************************************************
* Assign Statments
********************************************************************************/
assign o_CKP   = (CS == NORMAL_STATE)? i_local_ckp : (i_local_ckp & EN);
assign o_CKN   = (CS == NORMAL_STATE)? i_local_ckn : (i_local_ckn & EN);
assign o_TRACK = o_CKP;
//assign o_done  = (&iteration_counter);
/********************************************************************************
* State memory
********************************************************************************/
always @ (posedge i_sys_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        CS <= NORMAL_STATE;
        start_traning_reg <= 0;
    end else begin
        CS <= NS;
        start_traning_reg <= i_start_clk_training;
    end
end
/********************************************************************************
* Next state logic
********************************************************************************/
always @ (*) begin
    case(CS)
        NORMAL_STATE: begin
            NS = (i_start_clk_training && ~ start_traning_reg)? TRAIN_STATE : NORMAL_STATE;
        end

        TRAIN_STATE: begin
            NS = (&iteration_counter)? NORMAL_STATE : TRAIN_STATE;
        end
        endcase
end
/********************************************************************************
* Counters logic
********************************************************************************/
always @ (posedge i_local_ckp or negedge i_rst_ckp_n) begin
    if (~i_rst_ckp_n) begin
        gating_counter <= 5'b00000;
        iteration_counter <= 7'b0000000;
        o_done <= 0;
        EN <= 1'b0;
    end else begin
        if (CS == TRAIN_STATE) begin
            /*-----------------------------
            * adjusting gating counter
            -----------------------------*/
            if (gating_counter <= 15) begin
                gating_counter <= gating_counter + 1;
                EN <= 1'b1;
            end else if (gating_counter <= 23) begin
                gating_counter <= gating_counter + 1;
                EN <= 1'b0;
            end else begin
                gating_counter <= 5'b00000;
            end
            /*-----------------------------
            * adjusting iteration counter
            -----------------------------*/
            if (gating_counter == 23) begin
                iteration_counter <= iteration_counter + 1;
            end
            
        end else begin
            gating_counter <= 5'b00000;
            iteration_counter <= 7'b0000000;
        end
        o_done <= (&iteration_counter)? 1 : (~i_start_clk_training && start_traning_reg)? 0 : o_done;
    end
end
endmodule