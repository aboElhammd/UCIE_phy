module Functional_Lane_Setup ( 
    input               CLK,
    input               rst_n,
    input               start_setup,
    input  [15:0]       i_Transmitter_initiated_Data_to_CLK_Result,
    output reg [1:0]    o_Functional_Lanes,
    output reg          done_setup 
);

always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        o_Functional_Lanes <= 2'b11;
        done_setup <= 1'b0;
    end else begin
        if (start_setup) begin  
            if (&i_Transmitter_initiated_Data_to_CLK_Result) 
                o_Functional_Lanes <= 2'b11;
            else if (&i_Transmitter_initiated_Data_to_CLK_Result[15:8]) 
                o_Functional_Lanes <= 2'b10;
            else if (&i_Transmitter_initiated_Data_to_CLK_Result[7:0]) 
                o_Functional_Lanes <= 2'b01;
            done_setup <= 1'b1;
        end
    end
end
endmodule
