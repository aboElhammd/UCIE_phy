/**************************************************
* File name: bit_synchronizer.v
* Description: This module is a bit synchronizer.
* Date: 22/4/2025
* author : sa3dany
**************************************************/
module bit_synchronizer (
    input               i_clk,
    input               i_rst_n,
    input               i_data_in,
    output   reg        o_data_out
);

reg data_stage_1;

always @ (posedge i_clk or negedge i_rst_n) begin
    if (! i_rst_n) begin
        data_stage_1 <= 0;
        o_data_out   <= 0;
    end else begin
        data_stage_1 <= i_data_in;
        o_data_out   <= data_stage_1;
    end
end

endmodule
