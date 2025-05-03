interface sideband_interface(input clk);
	// Inputs
	logic [63:0] deser_data;     // parallel data output from deserializer 
	logic de_ser_done;           // indication for deser_data 
	// Outputs
	logic TXCKSB;                // clock to be sent
	logic [63:0] fifo_data_out;  // parallel output from fifo to bs serialized
	logic clk_ser_en;            // indication to beging serializing
	logic pack_finished;         // level signal for 32 clock (sleep time between sending packet and next packet)
	logic de_ser_done_sampled;   // ack for sampling de_ser_done signal as they are from different clock domains
	// clocking cb_driver @(posedge clk) ;
	// 	default output #1step  ;
	// 	output 		 deser_data;
	// 	output  	   de_ser_done;
	// endclocking
	clocking cb_monitor @(posedge clk) ;
		default input #0 ;
		input        TXCKSB;                
		input 		 fifo_data_out;  
		input 		 clk_ser_en;            
		input 		 pack_finished;         
		input 		 de_ser_done_sampled;   
	endclocking
endinterface : sideband_interface