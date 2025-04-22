module SB_TX_FIFO (
    input 			 	 i_clk,          
    input 				 i_rst_n,          
    input 		    	 i_write_enable,
    input                i_read_enable,      
    input 	   [63:0]	 i_data_in, 
    output reg [63:0] 	 o_data_out, 
    output reg 			 o_empty,
    output reg           o_ser_done_sampled,
    output               o_full     
);

    // Internal memory for 4 packets (each 64 bits)
    reg [63:0] memory [0:3];
    reg [2:0] write_count;
    reg [2:0] read_count;
    reg o_empty_comb;

    // Empty flag
    assign o_empty_comb = (write_count == read_count);
    // Full flag
    assign o_full = (write_count[1:0] == read_count[1:0] && write_count[2] != read_count[2]);

    always @(posedge i_clk or negedge i_rst_n) begin 
        if(~i_rst_n) begin
            o_empty <= 1;
        end else begin
            o_empty <= o_empty_comb;
        end
    end

    // 
    always @(posedge i_clk or negedge i_rst_n) begin 
        if(~i_rst_n) begin
            o_ser_done_sampled <= 0;
        end else begin
            o_ser_done_sampled <= i_read_enable;
        end
    end

    // Write Operation
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            write_count <= 0;
        end 
        else if (i_write_enable && ~o_full) begin
            memory[write_count[1:0]] <= i_data_in;
            write_count <= write_count + 1;
        end
    end

    // Read Operation
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            read_count <= 0;
            o_data_out <= 64'b0;
        end 
        else if (i_read_enable && ~o_empty_comb) begin
            o_data_out <= memory[read_count[1:0]];
            read_count <= read_count + 1;
        end
    end

endmodule
