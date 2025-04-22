

module CHECKER_REPAIRMB_Module_Partner (
    input               CLK,
    input               rst_n,
    input               i_start_check,
    input               i_second_check,
    input  [1:0]        i_Functional_Lanes,
    output reg          o_done_check,
    output reg          o_go_to_repeat, 
    output reg          o_go_to_train_error,
    output reg          o_continue
);

    reg [2:0] prev_Functional_Lanes;

    // Registering the Functional Lanes
    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n)
            prev_Functional_Lanes <= 3'b000;
        else if (i_start_check)
            prev_Functional_Lanes <= i_Functional_Lanes;
    end

    // Check Logic
    always @(posedge CLK or negedge rst_n) begin
        if (!rst_n) begin
            o_done_check <= 0;
            o_go_to_repeat <= 0;
            o_go_to_train_error <= 0;
            o_continue <= 0;
        end else if (i_start_check) begin
            o_done_check <= 1;
            if (i_second_check) begin
                if (i_Functional_Lanes != prev_Functional_Lanes) begin
                    o_go_to_train_error <= 1;
                    o_go_to_repeat <= 0;
                    o_continue <= 0; 
                end else begin
                    o_go_to_train_error <= 0;
                    o_go_to_repeat <= 0;
                    o_continue <= 1;
                end
            end else begin
                case (i_Functional_Lanes)
                    3'b000: begin
                        o_go_to_train_error <= 1;
                        o_go_to_repeat <= 0;
                        o_continue <= 0;
                    end
                    3'b001, 3'b010: begin
                        o_go_to_train_error <= 0;
                        o_go_to_repeat <= 1;
                        o_continue <= 0;
                    end
                    3'b011: begin
                        o_go_to_train_error <= 0;
                        o_go_to_repeat <= 0;
                        o_continue <= 1;
                    end
                    default: ; // No action needed
                endcase
            end
        end else begin
            o_done_check <= 0;
            o_go_to_repeat <= 0;
            o_go_to_train_error <= 0;
            o_continue <= 0;
        end
    end
endmodule





    // // Check Logic
    // always @(*) begin
    //     // Default assignments
    //     o_done_check = 0;
    //     o_go_to_repeat = 0;
    //     o_go_to_train_error = 0;

    //     if (i_second_check) begin
    //         o_done_check = 1;
    //         o_go_to_train_error = (i_Functional_Lanes != prev_Functional_Lanes);
    //     end 
    //     else if (i_start_check) begin
    //         case (i_Functional_Lanes)
    //             3'b000: o_go_to_train_error = 1;
    //             3'b001, 3'b010: o_go_to_repeat = 1;
    //             default: ; // No action needed
    //         endcase
    //         o_done_check = 1;
    //     end
    // end

// module CHECKER_REPAIRMB_Module_Partner (
//     input               CLK,
//     input               rst_n,
//     input               i_start_check,
//     input  [2:0]        i_Functional_Lanes,
//     output reg          o_done_check,
//     output reg          o_go_to_repeat, 
//     output reg          o_go_to_train_error
// );

//     reg [2:0] prev_Functional_Lanes;
//     reg       check_phase;

//     // Registering the Functional Lanes
//     always @(posedge CLK or negedge rst_n) begin
//         if (!rst_n) begin
//             prev_Functional_Lanes <= 3'b000;
//             check_phase <= 1'b0;
//         end else if (i_start_check) begin
//             if (check_phase) begin
//                 // Second check phase: Compare with previous value
//                 o_done_check <= 1;
//                 o_go_to_train_error <= (i_Functional_Lanes != prev_Functional_Lanes);
//                 check_phase <= 1'b0; // Reset phase
//             end else begin
//                 // First check phase: Store the value
//                 prev_Functional_Lanes <= i_Functional_Lanes;
//                 check_phase <= 1'b1;
                
//                 case (i_Functional_Lanes)
//                     3'b000: o_go_to_train_error <= 1;
//                     3'b001, 3'b010: o_go_to_repeat <= 1;
//                     default: ; // No action needed
//                 endcase

//                 o_done_check <= 1;
//             end
//         end
//     end

// endmodule

