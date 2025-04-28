module clock_detector (
    input               i_dig_clk,
    input               i_half_pll_clk,
    input               i_rst_n,        
    input               i_RCLK,          
    input               i_start_clk_training,
    input               i_clear_results,
    output  reg         o_result
);
/********************************************************************************
* Internal wires and registers
********************************************************************************/
reg [7:0] iteration_counter; // increment when a pattern is detected
reg [4:0] receiving_counter;
reg [3:0] local_counter;
reg [2:0] pattern_in_zeros_sync;
reg pattern_in_zeros;
/********************************************************************************
 * Receiving counter using received clock
********************************************************************************/
always @ (posedge i_RCLK or negedge i_rst_n) begin
    if (~i_rst_n) begin
        receiving_counter <= 5'b00000;
        pattern_in_zeros  <= 1'b0;
    end else if (i_start_clk_training) begin
        if (receiving_counter == 5'd15) begin
            pattern_in_zeros <= 1; // m3naha en khalas el 16'b101010.. pattern khls w handkhul fi el 8'b00000000
            receiving_counter <= 5'b00000;
        end else if (receiving_counter == 5'd1 && pattern_in_zeros) begin // m3anaha en bad2na nkhush fi el 16'b101010... pattern tany fa safr el zeros flag
            pattern_in_zeros <= 0;                                        // 34an ana kol eli 3ayzo en elflag dh yb2a b wa7d bas fi 7alt el zeros 34an 23dhum
            receiving_counter <= receiving_counter + 1;
        end else begin
            receiving_counter <= receiving_counter + 1;
        end
    end
end
/********************************************************************************************
 * synchronizing the flag that tells us that the clock pattern (101010.. cycles) is captured
********************************************************************************************/
always @ (posedge i_half_pll_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        pattern_in_zeros_sync <= 3'b000;
    end else begin
        pattern_in_zeros_sync <= {pattern_in_zeros_sync[1:0],pattern_in_zeros}; // takes from 2 ~ 3 clk cycles
    end
end
/********************************************************************************************
 * synchronizing the flag that tells us that the clock pattern (101010.. cycles) is captured
********************************************************************************************/
always @ (posedge i_half_pll_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        local_counter <= 4'h0;
        iteration_counter <= 5'b00000;
    end else if (pattern_in_zeros_sync[1]) begin // as long as the pattern is in zeros phase still counting
        local_counter <= local_counter + 1;
    end else if (pattern_in_zeros_sync[2] & ~pattern_in_zeros_sync[1]) begin // @ negedge of pattern_in_zeros_sync check on local counter value
        if (local_counter == 4'hA) begin // 4'hA msh 4'h8 34an el flag eli bytfr3 foo2 dh aslun (pattern_in_zeros) eli byb3er 3n el zeros phase bytrf3 badre one cycle w bynzl mt2kher one cycle ghasb 3nii fa badi ll local counter msa7a 
            iteration_counter <= iteration_counter + 1; 
        end else begin
            iteration_counter <= 0;
        end
        local_counter <= 0;
    end 
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// elfekra hena bbsata en kol haga mo3tmda 3ala b3d fi el detection w lw ay haga fihum 3amlt violition msh ha consider en dh          //                                                                                                         
// successfull detection ... tb ezay b722 dh ?                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                                                                                                                          
// 1) el (receiving_counter) dh mdam wsl l 15 fdh m3nah enu mya fi elmya estlm el 10101010... 16 mara sa7 w ela kan mumken y miss     //                                                                          
// 3ada fi elnus lw 7asl ay mushkela w sa3tha b2a el (pattern_in_zeros_sync) kan 3omro ma hayrf3 bwa7d l2nu mo3tmd asasn 3ala         //                                                                                                                       
// en el (receiving_counter) ykun wsl l 15 w sa3tha hwa yrf3 l wa7d .. w b3d kdh el flag dh ysbt 3ala wa7d di l2n e mafrood fi el     //
// gooz2 eltany mn el pattern eli hwa 8'b00000000 mafish clock tkhli el counter ye3d foo2 el 15                                       //                                                                       
// ---------------------------------------------------------------------------------------------------------------------------------- //                                                                                                                         
// 2) el local counter eli mas2ool 3ala counting el nus el tany mn el pattern eli hwa elzeros dh 3omro mhystghal ela lw ana estlmt    //                                                                                                                         
// 101010 16 mara yaani el (receiving_counter) wsl l 16 y3ni el (pattern_in_zeros_sync) raf3 l wa7d ,, sa3tha abd2 ashghal            //                                                                                                                  
// counter ye3d 8 clock cycles bnafs el clock blzbt eli gaylna .. hat2oli tb ma mumken fi wst el zeros di yege one ghalt mn el lane   //
// h2olk sa3tha dh hay3ml increment ll (receiving_counter) w msh hyb2a b 16 w beltaly el (pattern_in_zeros_sync) hynzl w bltaly       //
// el local_counter haytsfer w el iteration counter msh hay3d el 3ada di                                                              //
// ---------------------------------------------------------------------------------------------------------------------------------- //
// 3) blnsba b2a ll iteration counter .. lw wsl l 16 f dh m3nah 100% en el 16 counting dool kano consecutive l2ni lw 7asl ay mushkela //
// fi el detection bsafro aslun w byrg3 ye3d mn elawel tany w bltaly 3omro mahywsl l 16 ela lw kano wara b3d kolohm sa7               //                                                                                                          
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/********************************************************************************
* logging/clearing results
********************************************************************************/
always @ (posedge i_dig_clk or negedge i_rst_n) begin
    if (~ i_rst_n) begin
        o_result <= 1'b0;
    end else begin
        if (i_clear_results) begin
            o_result <= 1'b0;
        end else begin
            if (iteration_counter >= 16) o_result <= 1'b1;
        end
    end
end
endmodule 