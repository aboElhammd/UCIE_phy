module pulse_synchronizer (
    input               i_slow_clock,
    input               i_slow_rst_n,
    input               i_fast_clock,
    input               i_fast_rst_n,
    input               i_fast_pulse,
    output              o_slow_pulse
);

reg [2:0] sync_stages;
reg toggle_flop;


// toggle flop
always @ (posedge i_fast_clock or negedge i_fast_rst_n) begin
    if (!i_fast_rst_n) begin
        toggle_flop <= 0;
    end else if (i_fast_pulse) begin
        toggle_flop <= ~ toggle_flop;
    end
end

// 3-flop synchronizer
always @ (posedge i_slow_clock or negedge i_slow_rst_n) begin
    if (!i_slow_rst_n) begin
        sync_stages <= 0;
    end else begin
        sync_stages <= {sync_stages[1:0],toggle_flop};
    end
end

assign o_slow_pulse = sync_stages [2] ^ sync_stages [1];

endmodule