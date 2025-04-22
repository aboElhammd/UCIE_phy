module REPAIRMB_Module_Partner (
    input                 CLK,
    input                 rst_n,
    input                 MBINIT_REVERSALMB_end,
    input                 i_Busy_SideBand,
    input                 i_falling_edge_busy,
    input [3:0]           i_RX_SbMessage,
    input                 i_msg_valid,
    input [1:0]           i_Functional_Lanes, // from rx side band in msginfo
    input                 i_Done_Repeater, // from module REPAIRMB_Module(tx)

    output reg            o_Start_Repeater, // to module REPAIRMB_Module(tx)
    output                o_train_error,
    output reg            o_MBINIT_REPAIRMB_Module_Partner_end,
    output reg            o_ValidOutDatat_REPAIRMB_Module_Partner,
    output reg [3:0]      o_TX_SbMessage,
    output reg            apply_repeater, //send to the module to know that it need to apply repeater do not send any end req
    // output                o_Width_Degrade_en,
    output reg [1:0]      o_Functional_Lanes //to width degrade module 

);


reg [3:0] CS, NS;   // CS current state, NS next state

reg  i_start_check;
reg  i_second_check;
// reg  prepare_the_seconed_check;
wire o_done_check;
wire o_go_to_repeat;
wire o_continue;

reg continue; // to module REPAIRMB_Module(tx) to apply the repeater
CHECKER_REPAIRMB_Module_Partner CHECKER_REPAIRMB_Module_Partner_inst (
    .CLK(CLK),
    .rst_n(rst_n),
    .i_start_check(i_start_check),
    .i_second_check(i_second_check),
    .i_Functional_Lanes(i_Functional_Lanes),
    .o_done_check(o_done_check),
    .o_go_to_repeat(o_go_to_repeat),
    .o_go_to_train_error(o_train_error),
    .o_continue(o_continue)
);


////////////////////////////////////////////////////////////////////////////////
// Sideband messages
////////////////////////////////////////////////////////////////////////////////

localparam MBINIT_REPAIRMB_start_req            = 4'b0001;
localparam MBINIT_REPAIRMB_start_resp           = 4'b0010;
localparam MBINIT_REPAIRMB_apply_degrade_req    = 4'b0101;
localparam MBINIT_REPAIRMB_apply_degrade_resp   = 4'b0110;
localparam MBINIT_REPAIRMB_end_req              = 4'b0011;
localparam MBINIT_REPAIRMB_end_resp             = 4'b0100;



////////////////////////////////////////////////////////////////////////////////
// State machine states MODULE Partner
////////////////////////////////////////////////////////////////////////////////
localparam  IDLE                                = 0;
localparam  REPAIRMB_CHECK_REQ                  = 1;
localparam  REPAIRMB_CHECK_BUSY_START           = 2;
localparam  REPAIRMB_START_RESP                 = 3;
localparam  REPAIRMB_HANDLE_VALID               = 4;
localparam  REPAIRMB_CHECK_WIDTH_DEGRADE        = 5;
localparam  REPAIRMB_APPLY_REAPEAT              = 6;
localparam  REPAIRMB_CHECK_BUSY_DEGRADE_RESP    = 7;
localparam  REPAIRMB_DEGRADE_RESP               = 8;
localparam  REPAIRMB_CHECK_BUSY_END_RESP        = 9;
localparam  REPAIRMB_END_RESP                   = 10;
localparam  REPAIRMB_DONE                       = 11;

////////////////////////////////////////////////////////////////////////////////
// State machine logic for the REPAIRMB_Module_PARTNER
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        CS <= IDLE;
    end else begin
        CS <= NS;
    end
end


////////////////////////////////////////////////////////////////////////////////
// Next state logic for the REPAIRMB_Module_PARTNER
////////////////////////////////////////////////////////////////////////////////
always @(*) begin
    NS = CS; // Default to hold state
    case (CS)
        IDLE: begin
            if (MBINIT_REVERSALMB_end) NS = REPAIRMB_CHECK_REQ;
        end
        REPAIRMB_CHECK_REQ: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (i_RX_SbMessage == MBINIT_REPAIRMB_start_req && i_msg_valid) NS = REPAIRMB_CHECK_BUSY_START;
        end
        REPAIRMB_CHECK_BUSY_START: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REPAIRMB_START_RESP;
        end
        REPAIRMB_START_RESP: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REPAIRMB_HANDLE_VALID;
        end
        REPAIRMB_HANDLE_VALID: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (i_RX_SbMessage == MBINIT_REPAIRMB_apply_degrade_req && i_msg_valid) NS = REPAIRMB_CHECK_WIDTH_DEGRADE;
            else if (i_RX_SbMessage == MBINIT_REPAIRMB_end_req && continue && i_msg_valid) NS = REPAIRMB_CHECK_BUSY_END_RESP;
            else if (apply_repeater) NS = REPAIRMB_APPLY_REAPEAT;
        end
        REPAIRMB_CHECK_WIDTH_DEGRADE: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (o_done_check) begin
                NS = REPAIRMB_CHECK_BUSY_DEGRADE_RESP;
            // if (o_go_to_repeat) NS = REPAIRMB_APPLY_REAPEAT;
            // else if (o_continue) NS = REPAIRMB_CHECK_BUSY_DEGRADE_RESP;
            if (o_train_error) NS = IDLE;
            end
        end
        REPAIRMB_APPLY_REAPEAT: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (i_Done_Repeater) NS = REPAIRMB_HANDLE_VALID; // to wait the second request (seconed request)
        end
        REPAIRMB_CHECK_BUSY_DEGRADE_RESP: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REPAIRMB_DEGRADE_RESP;
        end
        REPAIRMB_DEGRADE_RESP: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REPAIRMB_HANDLE_VALID;
        end
        REPAIRMB_CHECK_BUSY_END_RESP: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (~i_Busy_SideBand) NS = REPAIRMB_END_RESP;
        end
        REPAIRMB_END_RESP: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
            else if (i_falling_edge_busy) NS = REPAIRMB_DONE;
        end
        REPAIRMB_DONE: begin
            if (~MBINIT_REVERSALMB_end) NS = IDLE;
        end
        default: NS = IDLE;
    endcase
end

// always @(posedge CLK or negedge rst_n) begin
//     if (~rst_n) begin 
//         prepare_the_seconed_check <= 0;
//     end else begin
//         if (i_Done_Repeater) begin
//             prepare_the_seconed_check <= 1;
//         end else if (prepare_the_seconed_check) begin
//             prepare_the_seconed_check <= 0;
//         end
//     end
// end
////////////////////////////////////////////////////////////////////////////////
// Combinational output logic for the REPAIRMB_Module_Partner
////////////////////////////////////////////////////////////////////////////////
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        o_TX_SbMessage                              <= 4'b0000;
        o_MBINIT_REPAIRMB_Module_Partner_end        <= 0;
        o_ValidOutDatat_REPAIRMB_Module_Partner     <= 0;
        o_Functional_Lanes                          <= 2'b11;
        o_Start_Repeater                            <= 0;
        i_start_check                               <= 0;
        continue                                    <= 0;
        apply_repeater                              <= 0;
    end else begin
        // Default values
        o_TX_SbMessage                              <= 4'b0000;
        o_MBINIT_REPAIRMB_Module_Partner_end        <= 0;
        o_ValidOutDatat_REPAIRMB_Module_Partner     <= 0;
        o_Start_Repeater                            <= 0;
        i_start_check                               <= 0;

        // if (CS == REPAIRMB_CHECK_WIDTH_DEGRADE) begin
        //     if (o_done_check) begin
        //         if (o_go_to_repeat) begin
        //             o_Start_Repeater <= 1'b1;
        //             o_Functional_Lanes <= i_Functional_Lanes; // for setup the rx width
        //         end 
        //     end
        // end
        
        if (CS == REPAIRMB_CHECK_WIDTH_DEGRADE) begin
            if (o_done_check) begin
                if (o_go_to_repeat) begin
                    o_Functional_Lanes <= i_Functional_Lanes; // for setup the rx width
                    apply_repeater <= 1'b1;
                    continue <= 0;
                end 
                else if (o_continue) begin 
                    continue <= 1'b1;
                    apply_repeater <= 0;
                end
            end
        end
            
        case (NS)
            REPAIRMB_START_RESP: begin
                o_ValidOutDatat_REPAIRMB_Module_Partner <= 1'b1;
                o_TX_SbMessage <= MBINIT_REPAIRMB_start_resp;
            end
            REPAIRMB_CHECK_WIDTH_DEGRADE: begin
                i_start_check <= 1'b1;
            end
            REPAIRMB_APPLY_REAPEAT: begin
                o_Start_Repeater <= 1'b1;
                apply_repeater <= 0;
            end
            REPAIRMB_DEGRADE_RESP: begin
                o_ValidOutDatat_REPAIRMB_Module_Partner <= 1'b1;
                o_TX_SbMessage <= MBINIT_REPAIRMB_apply_degrade_resp;
            end
            REPAIRMB_END_RESP: begin
                o_ValidOutDatat_REPAIRMB_Module_Partner <= 1'b1;
                o_TX_SbMessage <= MBINIT_REPAIRMB_end_resp;
                continue <= 0;
                i_second_check <= 0;
            end
            REPAIRMB_DONE: begin
                o_MBINIT_REPAIRMB_Module_Partner_end <= 1;
            end
            default: begin
                o_TX_SbMessage                              <= 4'b0000;
                o_MBINIT_REPAIRMB_Module_Partner_end        <= 0;
                o_ValidOutDatat_REPAIRMB_Module_Partner     <= 0;
                o_Start_Repeater                            <= 0;
                i_start_check                               <= 0;

            end
        endcase
    end
end

always @(posedge CLK or negedge rst_n) begin
    if (! rst_n)
        i_second_check <=0;
    else if(i_Done_Repeater) begin
        i_second_check <=1;        
    end
end

endmodule //REPAIRMB_Module_Partner