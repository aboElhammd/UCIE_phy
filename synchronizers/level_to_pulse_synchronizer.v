module level_to_pulse_synchronizer (
    input               i_clk,
    input               i_rst_n,
    input               i_level_data,
    output              o_pulse_data
);

reg [3:0] sync_stages;

always @ (posedge i_clk or negedge i_rst_n) begin
    if (! i_rst_n) begin
        sync_stages <= 0;
    end else begin
        sync_stages <= {sync_stages[2:0],i_level_data};
    end
end

assign o_pulse_data = sync_stages [2] && ~sync_stages[3];

endmodule