module CHECKER_PARAM_Module (
    input 				CLK,
    input 				rst_n,
    input 				i_Enable_Ehecker,
    input [2:0]			i_RX_MaxDataRate,
    input 				i_RX_ClockMode,i_RX_PhaseClock,

    output reg          o_Finish_Checker,
    output reg          o_Successful_Param
);

    wire [4:0]    TX_VoltageSwing_REG;
    wire [2:0]    MaxDataRate_REG;
    wire          TX_ClockMode_REG;
    wire          TX_PhaseClock_REG;          
    reg           Finish_Checker;
    reg           Successful_Param;
    wire [2:0]    i_Final_MaxDataRate;
    wire [2:0]    Final_MaxDataRate;

    PARAM_REG PARAM_REG_inst (
    .CLK(CLK),
    .rst_n(rst_n),
    .i_Enable_Ehecker(i_Enable_Ehecker),
    .i_Final_MaxDataRate(i_Final_MaxDataRate),
    .o_TX_VoltageSwing(TX_VoltageSwing_REG),
    .o_MaxDataRate(MaxDataRate_REG),
    .o_TX_ClockMode(TX_ClockMode_REG),
    .o_TX_PhaseClock(TX_PhaseClock_REG),
    .o_Final_MaxDataRate(Final_MaxDataRate)
    );
    assign i_Final_MaxDataRate = (o_Successful_Param)?i_RX_MaxDataRate:0;
    /// for check;
    always @(*) begin
        if (i_Enable_Ehecker) begin
            if (i_RX_MaxDataRate == MaxDataRate_REG && i_RX_ClockMode==TX_ClockMode_REG && i_RX_PhaseClock== TX_PhaseClock_REG ) begin
                o_Successful_Param=1;
            end else o_Successful_Param=0;
            o_Finish_Checker=1;
        end else begin
            o_Successful_Param=0;
            o_Finish_Checker=0;
        end
    end

	// always @(posedge CLK or negedge rst_n) begin 
	// 	if(~rst_n) begin
    //         o_Successful_Param<=0;
    //         o_Finish_Checker<=0;
	// 	end else begin
    //         if (i_Enable_Ehecker) begin
    //         o_Successful_Param<=Successful_Param;
    //         o_Finish_Checker<=Finish_Checker;
    //     end
	// 	end
	// end

endmodule //CHECKER_PARAM_Module