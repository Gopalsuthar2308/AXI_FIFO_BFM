`ifndef READ_FIFO_MONITOR_INCLUDED_
`define READ_FIFO_MONITOR_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: read_fifo_monitor
// <Description_here>
//--------------------------------------------------------------------------------------------
class read_fifo_monitor extends uvm_component;
  `uvm_component_utils(read_fifo_monitor)
  
  //variable :cgf_h
  //Declaring the read agent

  fifo_sequence_item pkt;

  virtual fifo_if intf;

  uvm_analysis_port #(fifo_sequence_item)item_collected_port1;

  function new(string name="read_fifo_monitor",uvm_component parent);
     super.new(name,parent);

    item_collected_port1=new("item_collected_port1",this);

endfunction

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  //extern function new(string name = "read_fifo_monitor", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : read_fifo_monitor
  
  function void read_fifo_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual fifo_if)::get(this, "", "vif", intf);
  endfunction


   task read_fifo_monitor::run_phase(uvm_phase phase);
     pkt=fifo_sequence_item#()::type_id::create("pkt");

    // @(posedge intf.clk);
    // @(posedge intf.clk);

     forever begin
       @(posedge intf.clk);

       pkt.wr_en<=intf.wr_en;
       pkt.rd_en<=intf.rd_en;

       pkt.rd_data<=intf.rd_data;
       //pkt.fifo_cnt<=intf.fifo_cnt;
       pkt.empty<=intf.empty;
       pkt.full<=intf.full;
       $display("MONITOR_2");

       item_collected_port1.write(pkt);


       end
       endtask

`endif

