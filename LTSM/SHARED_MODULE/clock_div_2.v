module clock_div_2 (
    input           i_clk,
    input           i_rst_n,
    output reg      o_div_clk
);

always @ (posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        o_div_clk <= 0;
    end else begin
        o_div_clk <= ~ o_div_clk;     
    end
end
endmodule 