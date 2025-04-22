`timescale 1ns/1ps

typedef enum logic [2:0] {RESET, SBINIT, MBINIT, MBTRAIN, LINKINIT, ACTIVE, PYHRETRAIN} e_state;
parameter logic [63:0] CORRECT_PATTERN = 64'hAAAAAAAAAAAAAAAA;
integer correct_count = 0;
integer error_count = 0;

class pattern_rand;
    rand logic i_rst_n;
    rand logic [63:0] i_de_ser_data;
    rand logic i_de_ser_valid;
    rand e_state i_state;

    constraint state_rand {
        i_state dist {RESET := 4, SBINIT := 5, [MBINIT:PYHRETRAIN] := 1};
    }

    constraint rst_rand {
        i_rst_n dist {1 := 9, 0 := 1};
    }

    constraint valid_rand {
        i_de_ser_valid dist {1 := 7, 0 := 3};
    }

    constraint pattern_rand {
        i_de_ser_data dist {CORRECT_PATTERN := 8, [0:64'hFFFFFFFFFFFFFFFF] :/ 5};
    }

endclass : pattern_rand

module SB_PATTERN_DETECTOR_tb;
    // Inputs
    bit i_clk;
    logic i_rst_n;
    logic [63:0] i_de_ser_data;
    logic i_de_ser_valid;
    e_state i_state; // Single state, not an array

    // Outputs
    logic o_rx_sb_pattern_samp_done;
    logic [63:0] o_pattern_out;
    logic o_pattern_out_valid;
    logic o_rx_sb_start_pattern;

    // Internal 
    pattern_rand pkt;
    reg count;

    // Instantiate the Design
    SB_PATTERN_DETECTOR dut (.*);

    // Clock generation
    always #5 i_clk = ~i_clk; // 10ns clock period

    initial begin
        // Initialize inputs
        Initialize();
        // Reset 
        Reset();
        // Handle from randomized packet
        pkt = new();

        // Randomize and apply inputs
        repeat (100) begin
            assert(pkt.randomize());
            //i_rst_n = pkt.i_rst_n;
            i_de_ser_data = pkt.i_de_ser_data;
            i_de_ser_valid = 1;
            i_state = pkt.i_state;
            @(negedge i_clk);
            check();
            $display("Time: %0t | State: %s | Data: %h | Valid: %b | Pattern Done: %b | Message Out: %h | Message Valid: %b",
                     $time, i_state, i_de_ser_data, i_de_ser_valid, o_rx_sb_pattern_samp_done, o_pattern_out, o_pattern_out_valid);
        end

        $display("--------------------------- Report Phase -----------------------------");
        $display("Correct Trials = %0d, Failed Trials = %0d", correct_count , error_count);
        $stop;
    end

    task Initialize();
        i_de_ser_data = 0;
        i_de_ser_valid = 0;
        count = 0;
        i_state = RESET;
    endtask : Initialize

    task Reset();
        i_rst_n = 0;
        repeat(5) @(negedge i_clk);
        i_rst_n = 1;
    endtask : Reset

    task check();
        if (i_state == RESET) begin
            if (i_de_ser_data == CORRECT_PATTERN) begin
                count++;
                if (!count) begin
                    if (o_rx_sb_start_pattern) begin
                        correct_count++ ;
                    end
                    else begin
                        error_count++ ;
                        $display("Error: Time: %0t | State: %s | Data: %h | Valid: %b | Pattern Done to LTSM: %b | Message Out: %h | Message Valid: %b",
                                 $time, i_state, i_de_ser_data, i_de_ser_valid, o_rx_sb_pattern_samp_done, o_pattern_out, o_pattern_out_valid);
                    end
                end
                else begin
                    if (!o_rx_sb_start_pattern) begin
                        correct_count++ ;
                    end
                    else begin
                        error_count++ ;
                        $display("Error: Time: %0t | State: %s | Data: %h | Valid: %b | Pattern Done to LTSM: %b | Message Out: %h | Message Valid: %b",
                                 $time, i_state, i_de_ser_data, i_de_ser_valid, o_rx_sb_pattern_samp_done, o_pattern_out, o_pattern_out_valid);
                    end
                end
            end     
        end
        else if (i_state == SBINIT) begin
            if (i_de_ser_data == CORRECT_PATTERN) begin
                count++;
                if (!count) begin
                    if (o_rx_sb_pattern_samp_done) begin
                        correct_count++ ;
                    end
                    else begin
                        error_count++ ;
                        $display("Error: Time: %0t | State: %s | Data: %h | Valid: %b | Pattern Done to pattern gen: %b | Message Out: %h | Message Valid: %b",
                                 $time, i_state, i_de_ser_data, i_de_ser_valid, o_rx_sb_start_pattern, o_pattern_out, o_pattern_out_valid);
                    end
                end
                else begin
                    if (!o_rx_sb_pattern_samp_done) begin
                        correct_count++ ;
                    end
                    else begin
                        error_count++ ;
                        $display("Error: Time: %0t | State: %s | Data: %h | Valid: %b | Pattern Done to pattern gen: %b | Message Out: %h | Message Valid: %b",
                                 $time, i_state, i_de_ser_data, i_de_ser_valid, o_rx_sb_start_pattern, o_pattern_out, o_pattern_out_valid);
                    end
                end
            end     
        end
    endtask : check

endmodule
