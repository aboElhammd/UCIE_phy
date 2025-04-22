/**************************************
 * modelling deserlizar
**************************************/
// to detect that data change and we can take anothe data for rx
always @(Module.rx_wrapper.i_deser_data) begin
    module_de_ser_done = 1;
    repeat(2) @(posedge i_clk);
    module_de_ser_done = 0;
end

always @(Partner.rx_wrapper.i_deser_data) begin
    partner_de_ser_done = 1;
    repeat(2) @(posedge i_clk);
    partner_de_ser_done = 0;
end

/**************************************
 * modelling serelizar 
**************************************/
always @ (posedge Module.tx_wrapper.packet_encoder_dut.gen_dut.o_pattern_valid, posedge Module.tx_wrapper.packet_framing_dut.o_packet_valid) begin
        module_ser_done = 0;
        repeat(2) @(posedge i_clk);
        module_ser_done = 1;

end

always @ (posedge i_clk) begin
    if (Partner.tx_wrapper.packet_encoder_dut.gen_dut.o_pattern_valid || Partner.tx_wrapper.packet_framing_dut.o_packet_valid) begin
        partner_ser_done = 0;
        repeat(2) @(posedge i_clk);
        partner_ser_done = 1;
    end 

end