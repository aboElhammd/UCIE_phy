module nedege_detector (
	input clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input i_busy,
	output  o_busy_negedge_detected
);
	reg i_busy_reg;
	always @(posedge clk or negedge rst_n) begin : proc_i_busy_reg
		if(~rst_n) begin
			i_busy_reg <= 0;
		end else begin
			i_busy_reg <= i_busy;
		end
	end

	assign o_busy_negedge_detected=~i_busy  && i_busy_reg; 
endmodule 
