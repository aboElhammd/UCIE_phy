module mux_based_synchronizer #(
    parameter DATA_WIDTH = 4
)(
    input                           i_clk,
    input                           i_rst_n,
    input                           i_mux_select,
    input       [DATA_WIDTH-1:0]    i_data_bus,
    output  reg [DATA_WIDTH-1:0]    o_data_bus
);

wire sync_mux_select;

bit_synchronizer bit_sync_inst (
    .i_clk      (i_clk),
    .i_rst_n    (i_rst_n),
    .i_data_in  (i_mux_select),
    .o_data_out (sync_mux_select)
);

always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        o_data_bus <= 0;
    end else if (sync_mux_select) begin
        o_data_bus <= i_data_bus;
    end
end

endmodule