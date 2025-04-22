/**************************************
 * modelling channel transfer delay
**************************************/
// Module
reg [63:0] mod_tx_data_reg1;
reg [63:0] mod_tx_data_reg2;
reg [63:0] mod_tx_data_reg3;

always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        mod_tx_data_reg1 <= 0;
        mod_tx_data_reg2 <= 0;
        mod_tx_data_reg3 <= 0;
    end else begin
        if (TX_module_data != 0) begin
            mod_tx_data_reg1 <= TX_module_data;
        end
            mod_tx_data_reg2 <= mod_tx_data_reg1;
            mod_tx_data_reg3 <= mod_tx_data_reg2;
    end
end

assign RX_module_data =  mod_tx_data_reg3; // output from module , input to partner after 3 clk cycles

// partner
reg [63:0] partner_tx_data_reg1;
reg [63:0] partner_tx_data_reg2;
reg [63:0] partner_tx_data_reg3;

always @ (posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        partner_tx_data_reg1 <= 0;
        partner_tx_data_reg2 <= 0;
        partner_tx_data_reg3 <= 0;
    end else begin
        if (TX_partner_data != 0) begin
            partner_tx_data_reg1 <= TX_partner_data;
        end 
            partner_tx_data_reg2 <= partner_tx_data_reg1;
            partner_tx_data_reg3 <= partner_tx_data_reg2;            
    end
end

assign RX_partner_data = partner_tx_data_reg3; // output from partner , input to module after 3 clk cycles