module CHECKER_PARAM_Partner (
	input 				CLK,
	input 				rst_n,
	input 				i_Enable_Ehecker,
	input [4:0] 		i_voltage_swing,
	input [2:0]			i_Max_DataRate,
	input 				i_Clock_Mode,i_Phase_Clock,

	output reg [2:0]	o_Max_DataRate_AfterChecker,
	output reg 			o_Clock_Mode_AfterChecker,
	output reg 			o_Phase_Clock_AfterChecker,
	output reg 			o_Finish_Checker
);
	wire [2:0]			Max_DataRate_REG;
	wire [1:0]			Clock_Mode_REG;
	wire [1:0] 			Phase_Clock_REG;

	reg [2:0]			Max_DataRate_AfterChecker;
	reg 				Clock_Mode_AfterChecker;
	reg 				Phase_Clock_AfterChecker;
	reg 				Finish_Checker;

	PARAM_REG_CAB u_PARAM_REG_CAB (
		.CLK(CLK),
		.rst_n(rst_n),
		.i_Enable_Ehecker(i_Enable_Ehecker),
		.i_Voltage_swing(i_voltage_swing),
		.o_Max_DataRate(Max_DataRate_REG),
		.o_Clock_Mode(Clock_Mode_REG),
		.o_Phase_Clock(Phase_Clock_REG)
	);

	always @(*) begin
		if (i_Enable_Ehecker) begin
			// Max DataRate PARM
			Max_DataRate_AfterChecker = (Max_DataRate_REG <= i_Max_DataRate) ? Max_DataRate_REG : i_Max_DataRate;
			// Clock Mode PARM
			case (Clock_Mode_REG)
				2'b00: Clock_Mode_AfterChecker = i_Clock_Mode; // freerunning or strobe mode
				2'b01: Clock_Mode_AfterChecker = 1; // free running
				default: Clock_Mode_AfterChecker = i_Clock_Mode; // reserved
			endcase
			// Phase Clock PARM
			case (Phase_Clock_REG)
				2'b00: Phase_Clock_AfterChecker = 0; // Differential only
				2'b01: Phase_Clock_AfterChecker = i_Phase_Clock; // both differentially or quad
				default: Phase_Clock_AfterChecker = i_Phase_Clock; // reserved
			endcase
			Finish_Checker = 1;
		end else begin
			Finish_Checker = 0;
			Clock_Mode_AfterChecker = 0;
			Phase_Clock_AfterChecker = 0;
			Max_DataRate_AfterChecker = 0;
		end
	end
	always @(posedge CLK or negedge rst_n) begin 
		if(~rst_n) begin
			o_Finish_Checker<=0;
			o_Clock_Mode_AfterChecker<=0;
			o_Phase_Clock_AfterChecker<=0;
			o_Max_DataRate_AfterChecker<=0;
		end else begin
			if (i_Enable_Ehecker) begin
				o_Finish_Checker<=Finish_Checker;
				o_Clock_Mode_AfterChecker<=Clock_Mode_AfterChecker;
				o_Phase_Clock_AfterChecker<=Phase_Clock_AfterChecker;
				o_Max_DataRate_AfterChecker<=Max_DataRate_AfterChecker;				
			end
		end
	end

endmodule 