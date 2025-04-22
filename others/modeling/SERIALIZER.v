module SERIALIZER (CLK,RST,P_DATA,SER_EN,SER_DN,SER_OUT);

parameter DATA_WIDTH = 8;
parameter COUNTER_WIDTH=$clog2(DATA_WIDTH)+1;

/*------------------ IN/OUT PORTS -----------------*/
input 							CLK;
input							RST;
input 	[DATA_WIDTH-1:0] 		P_DATA;
input 							SER_EN;
output 							SER_DN;
output reg 						SER_OUT;

/*----------------- COUNTER SIGNALS ---------------*/
reg [COUNTER_WIDTH-1:0] COUNTER;
wire COUNT_DN;


assign COUNT_DN = (COUNTER == DATA_WIDTH)? 1:0;
assign SER_DN   = (COUNT_DN)? 1:0;

/*----------------- SERIALIZING DATA ---------------*/
always @(posedge CLK or negedge RST) begin 
	if(!RST) begin 
		COUNTER  <= 0; 
        SER_OUT  <= 0;
	end 
	else begin
		if(SER_EN && !COUNT_DN) begin
			SER_OUT <= P_DATA [COUNTER];
			COUNTER <= COUNTER + 1;
		end
		else  begin
			COUNTER <= 0;
		end
	end
end

endmodule
