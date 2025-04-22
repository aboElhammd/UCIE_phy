module PARAM_REG_CAB (
 	input 				CLK,
  	input 				rst_n,
 	input [4:0]			i_Voltage_swing,
	input               i_Enable_Ehecker,         
	
	output reg [2:0]	o_Max_DataRate,
	output reg [1:0]	o_Clock_Mode,o_Phase_Clock
);
reg [4:0] Voltage_swing;
always @(posedge CLK or negedge rst_n) begin
	if(~rst_n) begin
		o_Max_DataRate		<=0;
		o_Clock_Mode		<=0;
		o_Phase_Clock		<=0;
		Voltage_swing 		<=0;
	end else begin
		o_Max_DataRate		<=3;
		o_Clock_Mode 		<=2'b00;
		o_Phase_Clock 		<=2'b01;
		if (i_Enable_Ehecker)
		Voltage_swing 		<=i_Voltage_swing;
	end
end
endmodule 