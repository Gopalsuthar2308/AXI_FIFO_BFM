package write_fifo_pkg;
  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------
  `include "write_agent.sv"
  `include "write_driver.sv"
  `include "write_monitor.sv"
  `include "write_sequencer.sv"
  `include "write_fifo_seq_item.sv"
endpackage
