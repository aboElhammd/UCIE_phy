module mux_4_to_1 (
	input sel_0,sel_1,
	input [3:0] in_1 , in_2 , in_3 , in_4,
	output reg [3:0] out
);
always @(*) begin 
	case ({sel_1,sel_0})
		2'b00 : out=in_1 ;
		2'b01 : out=in_2 ;
		2'b10 : out=in_3 ;
		2'b11 : out=in_4 ;	
	endcase
end
endmodule 
