module clock_div_32 (
    input                 i_clk, // Clock input
    input                 i_rst_n, // Reset input
    output                o_div_clk // Divided clock output
 );

localparam [4:0] STAGES = 16;
reg [STAGES-1:0] ff_stages;

always @ (posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        ff_stages <= {STAGES{1'b0}};
    end else begin
        ff_stages <= {~ff_stages[0],ff_stages[STAGES-1:1]};
    end
end

assign o_div_clk = ff_stages[0];

endmodule 