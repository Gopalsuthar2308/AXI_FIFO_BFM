`ifndef WRITE_FIFO_MONITOR_INCLUDED_
`define WRITE_FIFO_MONITOR_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: write_fifo_monitor
// <Description_here>
//--------------------------------------------------------------------------------------------
class write_fifo_monitor extends uvm_component;
  `uvm_component_utils(write_fifo_monitor)

   //variable intf
   //Defining virtual interface
   virtual fifo_if intf;

   //variable pkt
   //Instantiating a sequence item packet
   fifo_sequence_item pkt;

   uvm_analysis_port #(fifo_sequence_item)item_collected_port;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "write_fifo_monitor", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  //extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  //extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : write_fifo_monitor

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - write_fifo_monitor
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function write_fifo_monitor::new(string name = "write_fifo_monitor",
                                 uvm_component parent = null);
  super.new(name, parent);
  item_collected_port=new("item_collected_port",this);

endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void write_fifo_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uvm_config_db#(virtual fifo_if)::get(this,"","vif",intf);
  `uvm_info("MONITOR", $sformatf("Data from fifo_interface  wr_en : %0d , rd_en : %0d",intf.wr_en,intf.rd_en), UVM_NONE    );
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void write_fifo_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task write_fifo_monitor::run_phase(uvm_phase phase);

  super.run_phase(phase);
  pkt=fifo_sequence_item#()::type_id::create("pkt");
  @(posedge intf.clk);
  forever begin
  @(posedge intf.clk);
  pkt.wr_en<=intf.wr_en;
  pkt.rd_en<=intf.rd_en;
  pkt.wr_data<=intf.wr_data;
  item_collected_port.write(pkt);
  $display("Monitor received the data");
  `uvm_info("MONITOR", $sformatf("Data received  wr_en : %0d , rd_en : %0d",pkt.wr_en,pkt.rd_en), UVM_NONE    );
end

endtask : run_phase

`endif

