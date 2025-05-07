package pack1;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	




	/*------------------------------------------------------------------------------
	-- SIDEBAND AGENT
	------------------------------------------------------------------------------*/
	`include "sideband_sequence_item.sv"
	`include "sequence.sv"
	`include "point_test_seqeunces.sv"
	`include "mbinit_sequences.sv"
	`include "mbtrain_sequences.sv"
	`include "sideband_sequencer.sv"
	`include "sideband_driver.sv"
	`include "sideband_monitor.sv"
	`include "sideband_agent.sv"
	
	
	
	

	/*------------------------------------------------------------------------------
	-- MAINBAND AGENT
	------------------------------------------------------------------------------*/
	`include "MB_sequence_item.sv"
	`include "MB_sequence.sv"
	`include "MB_sequencer.sv"
	`include "MB_driver.sv"
	`include "MB_monitor.sv"
	`include "MB_agent.sv"

	/*------------------------------------------------------------------------------
	-- Vsqr & Vseq
	------------------------------------------------------------------------------*/
	`include "vsequencer.sv"
	`include "vsequence_base.sv"
	`include "Vsequence.sv"




	`include "sideband_scoreboard.sv"
	`include "sideband_subscriber.sv"
	`include "PHY_env.sv"
	`include "PHY_test.sv"
	// `include "linkspeed_done_vs_phyretrain_test.sv"
	// `include "linkspeed_done_vs_repair_test.sv"
	// `include "linkspeed_done_vs_speed_degrade_test.sv"
	// `include "linkspeed_repair_vs_done_test.sv"
	// `include "linkspeed_repair_vs_phyretrain_test.sv"
	// `include "linkspeed_repair_vs_repair_test.sv"
	// `include "linkspeed_repair_vs_speed_degrade_test.sv"
	`include "linkspeed_speed_degrade_vs_done_test.sv"
	 `include "linkspeed_speed_degrade_vs_phyretrain_test.sv"
	 `include "linkspeed_speed_degrade_vs_repair_test.sv"
	// `include "linkspeed_speed_degrade_vs_speed_degrade_test.sv"


endpackage : pack1
