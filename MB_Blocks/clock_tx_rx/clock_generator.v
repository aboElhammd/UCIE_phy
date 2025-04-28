module clock_generator (
    input                           i_pll_clk,
    input                           i_local_ckp,    // pll clock / 2
    input                           i_local_ckn,
    input                           i_dig_clk,      // pll clock /32 --> local ckp/16
    input                           i_rst_n,        // should be synchronous to dig_clk
    input                           i_start_clk_training,
    input                           i_ltsm_in_reset,
    output  reg                     o_CKP,
    output  reg                     o_CKN,
    output  reg                     o_TRACK,
    output  reg                     o_done
);
/********************************************************************************
* Internal wires and registers
********************************************************************************/
reg [6:0] iteration_counter;
reg [4:0] gating_counter;
reg [1:0] CS,NS;
reg EN;
reg start_traning_reg;
/********************************************************************************
* FSM States
********************************************************************************/
localparam [1:0] IDLE         = 2'b00;
localparam [1:0] NORMAL_STATE = 2'b01;
localparam [1:0] TRAIN_STATE  = 2'b11;
/********************************************************************************
* Assign Statments
********************************************************************************/
wire o_CKP_comb   = (CS == IDLE)? 1'b0 : (CS == NORMAL_STATE)? i_local_ckp : (i_local_ckp & EN);
wire o_CKN_comb   = (CS == IDLE)? 1'b0 : (CS == NORMAL_STATE)? i_local_ckn : (i_local_ckn & EN);
wire o_TRACK_comb = o_CKP_comb;
always @ (posedge i_pll_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        o_CKP   <= 0;
        o_CKN   <= 0;
        o_TRACK <= 0;
    end else begin
        o_CKP   <= o_CKP_comb;
        o_CKN   <= o_CKN_comb;
        o_TRACK <= o_TRACK_comb;        
    end
end
/********************************************************************************
* State memory
********************************************************************************/
always @ (posedge i_dig_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        CS <= IDLE;
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
        IDLE: begin
            NS = (i_start_clk_training && ~ start_traning_reg)? TRAIN_STATE : IDLE;
        end
        NORMAL_STATE: begin
            NS = (i_ltsm_in_reset)? IDLE : NORMAL_STATE;
        end

        TRAIN_STATE: begin
            NS = (&iteration_counter)? NORMAL_STATE : TRAIN_STATE;
        end
        endcase
end
/********************************************************************************
* Counters logic
********************************************************************************/
always @ (posedge i_local_ckp or negedge i_rst_n) begin
    if (~i_rst_n) begin
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
            end else if (gating_counter <= 22) begin
                gating_counter <= gating_counter + 1;
                EN <= 1'b0;
            end else begin
                gating_counter <= 5'b00000;
            end
            /*-----------------------------
            * adjusting iteration counter
            -----------------------------*/
            if (gating_counter == 22) begin
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