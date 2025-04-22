module MBINIT_FSM (
    input  wire CLK,
    input  wire rst_n,
    input  wire i_MBINIT_Start_en,
    input  wire i_PARAM_end,
    input  wire i_CAL_end,
    input  wire i_REPAIRCLK_end,
    input  wire i_REPAIRVAL_end,
    input  wire i_REVERSALMB_end,
    input  wire i_REPAIRMB_end,
    output reg  o_PARAM_start,
    output reg  o_CAL_start,
    output reg  o_REPAIRCLK_start,
    output reg  o_REPAIRVAL_start,
    output reg  o_REVERSALMB_start,
    output reg  o_REPAIRMB_start,
    output reg  o_Finish_MBINIT
);

// State Encoding
localparam [2:0] 
    IDLE        = 3'b000,
    PARAM       = 3'b001,
    CAL         = 3'b010,
    REPAIRCLK   = 3'b011,
    REPAIRVAL   = 3'b100,
    REVERSALMB  = 3'b101,
    REPAIRMB    = 3'b110,
    DONE        = 3'b111;
reg [2:0] CS, NS;

// State Transition
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n)
        CS <= IDLE;
    else
        CS <= NS;
end

// Next State Logic
always @(*) begin
    case (CS)
        IDLE:        NS = (i_MBINIT_Start_en) ? PARAM : IDLE;
        PARAM:       NS = (i_PARAM_end) ? CAL : PARAM;
        CAL:         NS = (i_CAL_end) ? REPAIRCLK : CAL;
        REPAIRCLK:   NS = (i_REPAIRCLK_end) ? REPAIRVAL : REPAIRCLK;
        REPAIRVAL:   NS = (i_REPAIRVAL_end) ? REVERSALMB : REPAIRVAL;
        REVERSALMB:  NS = (i_REVERSALMB_end) ? REPAIRMB : REVERSALMB;
        REPAIRMB:    NS = (i_REPAIRMB_end) ? DONE : REPAIRMB;
        DONE:        NS = (!i_MBINIT_Start_en)? IDLE : DONE;
        default:     NS = IDLE;
    endcase
end

// Output Logic (Level-sensitive outputs)
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        o_PARAM_start      <= 1'b0;
        o_CAL_start        <= 1'b0;
        o_REPAIRCLK_start  <= 1'b0;
        o_REPAIRVAL_start  <= 1'b0;
        o_REVERSALMB_start <= 1'b0;
        o_REPAIRMB_start   <= 1'b0;
        o_Finish_MBINIT    <= 1'b0;
        
    end else begin
        o_PARAM_start      <= (CS == PARAM);
        o_CAL_start        <= (CS == CAL);
        o_REPAIRCLK_start  <= (CS == REPAIRCLK);
        o_REPAIRVAL_start  <= (CS == REPAIRVAL);
        o_REVERSALMB_start <= (CS == REVERSALMB);
        o_REPAIRMB_start   <= (CS == REPAIRMB);
        o_Finish_MBINIT    <= (CS == DONE);
    end
end
endmodule
