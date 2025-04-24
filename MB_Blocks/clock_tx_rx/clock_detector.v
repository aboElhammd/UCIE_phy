module clock_detector (
    input               i_dig_clk,
    input               i_local_ckp,
    input               i_local_ckn,
    input               i_rst_n,         // Active-low reset
    input               i_rst_ckp_n,
    input               i_rst_ckn_n,
    input               i_RCKP,          // Received Clock Positive
    input               i_RCKN,          // Received Clock Negative
    input               i_RTRK,          // Received Track signal
    input               i_clear_results,
    output  reg [2:0]   o_Clock_track_result_logged // [0] CKP , [1] CKN , [2] TRK
);
/********************************************************************************
* Internal wires and registers
********************************************************************************/
reg [4:0] iteration_counter_ckp;
reg [4:0] iteration_counter_ckn;
reg [4:0] iteration_counter_trk;
reg [5:0] shifting_counter_ckp;
reg [5:0] shifting_counter_ckn;
reg [1:0] sync_reg_ckp;
reg [1:0] sync_reg_ckn;
reg [1:0] sync_reg_track;
reg [47:0] sampled_ckp;
reg [47:0] sampled_ckn;
reg [47:0] sampled_track;
reg [17:0] eight_zeros_detect;
reg zeros_found_ckp;
reg zeros_found_ckn;
/********************************************************************************
* Synchronizer to avoid metastability
********************************************************************************/
always @(posedge i_local_ckp or negedge i_rst_ckp_n) begin
    if (~ i_rst_ckp_n) begin
        sync_reg_ckp <= 2'b00;
        eight_zeros_detect <= 18'hffff;
    end else begin
        sync_reg_ckp <= {sync_reg_ckp[0], i_RCKP};
        eight_zeros_detect <= {eight_zeros_detect[16:0],sync_reg_ckp[1]};
    end
end

always @(posedge i_local_ckn or negedge i_rst_ckn_n) begin
    if (~ i_rst_ckn_n) begin
        sync_reg_ckn <= 2'b00;
    end else begin
        sync_reg_ckn <= {sync_reg_ckn[0], i_RCKN};
    end
end

always @(posedge i_local_ckp or negedge i_rst_ckp_n) begin
    if (~ i_rst_ckp_n) begin
        sync_reg_track <= 2'b00;
    end else begin
        sync_reg_track <= {sync_reg_track[0], i_RTRK};
    end
end
/********************************************************************************
* Pattern detection
********************************************************************************/
always @ (posedge i_local_ckp or negedge i_rst_ckp_n) begin
    if (~ i_rst_ckp_n) begin
        iteration_counter_ckp   <= 0;
        iteration_counter_trk   <= 0;
        shifting_counter_ckp    <= 0;
        sampled_ckp             <= 0;
        sampled_track           <= 0;
        zeros_found_ckp         <= 0;
    end else if (~|eight_zeros_detect | zeros_found_ckp) begin
        zeros_found_ckp <= 1;
        sampled_ckp     <= {sampled_ckp[46:0],sync_reg_ckp[1]};
        sampled_track   <= {sampled_track[46:0],sync_reg_track[1]};

        if (i_clear_results) begin 
            shifting_counter_ckp <= 0;
            zeros_found_ckp      <= 0;
        end else if (shifting_counter_ckp == 49) begin
            shifting_counter_ckp <= 0;
            if (sampled_ckp == 48'hAAAAAAAA0000) begin
                iteration_counter_ckp <= iteration_counter_ckp + 1;
            end
            if (sampled_track == 48'hAAAAAAAA0000) begin
                iteration_counter_trk <= iteration_counter_trk + 1;
            end
        end else begin
            shifting_counter_ckp <= shifting_counter_ckp + 1;
        end
    end
end

always @ (posedge i_local_ckn or negedge i_rst_ckn_n) begin
    if (~ i_rst_ckn_n) begin
        iteration_counter_ckn   <= 0;
        shifting_counter_ckn    <= 0;
        sampled_ckn             <= 0;
        zeros_found_ckn         <= 0;
    end else if (~|eight_zeros_detect | zeros_found_ckn) begin
        zeros_found_ckn <= 1;
        sampled_ckn     <= {sampled_ckn[46:0],sync_reg_ckn[1]};
        
        if (i_clear_results) begin 
            shifting_counter_ckn <= 0;
            zeros_found_ckn      <= 0;
        end else if (shifting_counter_ckn == 49) begin
            shifting_counter_ckn <= 0;
            if (sampled_ckn == 48'h555555550000) begin
                iteration_counter_ckn <= iteration_counter_ckn + 1;
            end
        end else begin
            shifting_counter_ckn <= shifting_counter_ckn + 1;
        end
    end
end

/********************************************************************************
* logging/clearing results
********************************************************************************/
always @ (posedge i_dig_clk or negedge i_rst_n) begin
    if (~ i_rst_n) begin
        o_Clock_track_result_logged <= 3'b000;
    end else begin
        if (i_clear_results) begin
            o_Clock_track_result_logged <= 3'b000;
        end else begin
            if (iteration_counter_ckp == 16) o_Clock_track_result_logged [0] <= 1'b1;
            if (iteration_counter_ckn == 16) o_Clock_track_result_logged [1] <= 1'b1;
            if (iteration_counter_trk == 16) o_Clock_track_result_logged [2] <= 1'b1;
        end
    end
end


endmodule