# 1. Library setup and compilation
vlib work
vlog ./TB_LTSM_SB_MB.sv
vlog ./LTSM_SB_MB.v 
vlog ../../LTSM/MBINIT/*.v
vlog ../../LTSM/MBTRAIN/*.v
vlog ../../LTSM/PHYRETRAIN/TX_PHYRETRAIN.v
vlog ../../LTSM/PHYRETRAIN/RX_PHYRETRAIN.v
vlog ../../LTSM/PHYRETRAIN/PHYRETRAIN_WRAPPER.v
vlog ../../LTSM/SBINIT/TX_SBINIT.v
vlog ../../LTSM/SBINIT/RX_SBINIT.v
vlog ../../LTSM/SBINIT/SBINIT_WRAPPER.v
vlog ../../LTSM/TRAINERROR/TX_TRAINERROR_HS.v
vlog ../../LTSM/TRAINERROR/RX_TRAINERROR_HS.v
vlog ../../LTSM/TRAINERROR/TRAINERROR_HS_WRAPPER.v
vlog ../../LTSM/TOP/LTSM_TOP.v
vlog ../../LTSM/SHARED_MODULE/nedege_detector.v
vlog ../../LTSM/SHARED_MODULE/*.v
vlog ../../MB_Blocks/*/*.v
vlog ../../MB_Blocks/clock_tx_rx/clock_generator.v
vlog ../../MB_Blocks/clock_tx_rx/clock_detector.v
vlog ../../RX_D2C_POINT_TEST/rx_initiated_point_test_tx.v
vlog ../../RX_D2C_POINT_TEST/rx_initiated_point_test_rx.v
vlog ../../RX_D2C_POINT_TEST/rx_initiated_point_test_wrapper.v
vlog ../../TX_D2C_POINT_TEST/tx_initiated_point_test_tx.v
vlog ../../TX_D2C_POINT_TEST/tx_initiated_point_test_rx.v
vlog ../../TX_D2C_POINT_TEST/tx_initiated_point_test_wrapper.v
vlog ../../synchronizers/*.v
vlog ../../SB_RTL/ANALOG_MODELLING/*.sv
vlog ../../SB_RTL/SIDEBAND_TX/*.sv
vlog ../../SB_RTL/SIDEBAND_RX/*.sv
vlog ../../SB_RTL/SIDEBAND_TOP_WRAPPER/*.sv
vlog ../../Full_UVM_Env/SB_intf.sv
vlog ../../Full_UVM_Env/MB_interface.sv
vlog ../../Full_UVM_Env/pack1.sv
vlog ../../Full_UVM_Env/top.sv

# 2. Test list configuration
set test_names {
    "PHY_test"
    "linkspeed_speed_degrade_vs_done_test"
    "linkspeed_done_vs_speed_degrade_test"
    "linkspeed_done_vs_repair_test"
    "linkspeed_done_vs_phyretrain_test"
    "linkspeed_repair_vs_done_test"
    "linkspeed_repair_vs_repair_test"
    "linkspeed_repair_vs_speed_degrade_test"
    "linkspeed_repair_vs_phyretrain_test"
    "linkspeed_speed_degrade_vs_repair_test"
    "linkspeed_speed_degrade_vs_phyretrain_test"
    "linkspeed_speed_degrade_vs_speed_degrade_test"
    
}

# "linkspeed_done_vs_speed_degrade_test"
#     "linkspeed_done_vs_repair_test"
#     "linkspeed_done_vs_phyretrain_test"
#     "linkspeed_repair_vs_done_test"
#     "linkspeed_repair_vs_repair_test"
#     "linkspeed_repair_vs_speed_degrade_test"
#     "linkspeed_repair_vs_phyretrain_test"
#     "linkspeed_speed_degrade_vs_repair_test"
#     "linkspeed_speed_degrade_vs_phyretrain_test"
#     "linkspeed_speed_degrade_vs_speed_degrade_test"

# 3. Directory setup
file mkdir log_files
file mkdir coverage_files
file mkdir merged_coverage
file mkdir tests_bugs

# New procedure to extract UVM Report Summary from log files
proc extract_uvm_summaries {} {
    set bugs_file [open "tests_bugs.txt" w]
    puts $bugs_file "UVM Report Summaries for All Tests\n"
    puts $bugs_file "============================================\n"
    
    foreach logfile [glob -nocomplain log_files/*.log] {
        # Extract test name from filename
        set test_name [file rootname [file tail $logfile]]
        
        # Find and extract the UVM Report Summary section
        set log_content [read [open $logfile r]]
        set start_idx [string first "# --- UVM Report Summary ---" $log_content]
        set end_idx [string first "# ** Report counts by id" $log_content]

        if {$start_idx != -1} {
            if {$end_idx == -1} {
                set end_idx [string length $log_content]
            }
            
            set summary [string range $log_content $start_idx [expr {$end_idx - 1}]]
            
            # Write to bugs file
            puts $bugs_file "Test: $test_name"
            puts $bugs_file $summary
            puts $bugs_file "\n--------------------------------------------\n"
        } else {
            puts $bugs_file "Test: $test_name - No UVM Report Summary found"
            puts $bugs_file "\n--------------------------------------------\n"
        }
    }
    
    close $bugs_file
    echo "UVM Report Summaries extracted to tests_bugs.txt"
}

# 4. Enhanced test runner procedure
proc run_single_test {test_name} {
    echo "\n============================================"
    echo "Starting test: $test_name"
    echo "Start time: [clock format [clock seconds] -format {%T on %b %d,%Y}]"
    
    # Start simulation with coverage
    if {[catch {
        vsim -coverage -voptargs="+acc" -onfinish stop -sv_seed random \
             +UVM_TESTNAME=$test_name work.top \
             +UVM_VERBOSITY=UVM_MEDIUM \
             -l log_files/${test_name}.log
        
        # Run configuration
        onbreak {resume}
        run -all
        
        # Save coverage data
        coverage save coverage_files/${test_name}.ucdb
        
        # Get simulation results
        set status [runStatus]
        set sim_time [examine sim_time]
        
        # Close simulation
        quit -sim -f
        
        return [list $status $sim_time]
    } error]} {
        echo "ERROR during test $test_name: $error"
        return [list "ERROR" 0]
    }
}

# 5. Main test execution loop
set start_time [clock seconds]
set failed_tests 0

foreach test $test_names {
    set test_start [clock seconds]
    
    if {[catch {set results [run_single_test $test]} error]} {
        echo "CRITICAL ERROR in test $test: $error"
        incr failed_tests
        continue
    }
    
    lassign $results status sim_time
    
    # Calculate test duration
    set test_end [clock seconds]
    set duration [expr {$test_end - $test_start}]
    set formatted_duration [format {%02d:%02d:%02d} \
        [expr {$duration / 3600}] \
        [expr {($duration % 3600) / 60}] \
        [expr {$duration % 60}]]
    
    # Report test results
    echo "\nTest $test completed with status: $status"
    echo "Simulation time: $sim_time"
    echo "Wall clock duration: $formatted_duration"
    echo "============================================"
    
    # Small delay between tests
    after 1000
}

# 6. Coverage merging and reporting
echo "\nMerging coverage data from all tests..."
set coverage_files [glob -nocomplain coverage_files/*.ucdb]

if {[llength $coverage_files] > 0} {
    set merged_file "merged_coverage/all_tests_merged.ucdb"
    
    # Create merged coverage
    if {[catch {
        exec vcover merge $merged_file {*}$coverage_files
    } error]} {
        echo "ERROR merging coverage: $error"
    } else {
        # Generate detailed coverage report
        if {[catch {
            set report_file "merged_coverage/coverage_report.txt"
            exec vcover report -details $merged_file > $report_file
            echo "Coverage report generated: $report_file"
            
            # Generate additional metrics
            exec vcover report $merged_file > merged_coverage/coverage_metrics.txt
            echo "Coverage metrics saved"
        } error]} {
            echo "ERROR generating coverage report: $error"
        }
    }
} else {
    echo "WARNING: No coverage files found to merge"
}

# 7. Extract UVM summaries after all tests complete
extract_uvm_summaries

# 8. Final summary
set total_tests [llength $test_names]
set passed_tests [expr {$total_tests - $failed_tests}]
set end_time [clock seconds]
set total_duration [expr {$end_time - $start_time}]

echo "\n\n============================================"
echo "TEST SUITE SUMMARY"
echo "============================================"
echo "Start time:    [clock format $start_time -format {%T on %b %d,%Y}]"
echo "End time:      [clock format $end_time -format {%T on %b %d,%Y}]"
echo "Total duration: [format {%02d:%02d:%02d} \
    [expr {$total_duration / 3600}] \
    [expr {($total_duration % 3600) / 60}] \
    [expr {$total_duration % 60}]]"
echo "Tests run:     $total_tests"
echo "Tests passed:  $passed_tests"
echo "Tests failed:  $failed_tests"
echo "Coverage data: merged_coverage/all_tests_merged.ucdb"
echo "============================================"