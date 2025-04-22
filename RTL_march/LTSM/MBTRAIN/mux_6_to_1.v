module mux_6_to_1 (
	input sel_0,sel_1,sel_2,
	input [3:0] in_1 , in_2 , in_3 , in_4, in_5,in_6,
	output reg [3:0] out
);
always @(*) begin 
	case ({sel_2,sel_1,sel_0})
		3'b000 : out=in_1 ;
		3'b001 : out=in_2 ;
		3'b010 : out=in_3 ;
		3'b011 : out=in_4 ;
		3'b100 : out=in_5 ;
		3'b101 : out=in_6 ;
		default: out=4'b0000;
	endcase
end
endmodule 

