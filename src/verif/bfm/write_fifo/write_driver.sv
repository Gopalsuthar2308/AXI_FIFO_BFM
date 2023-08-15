`ifndef WRITE_FIFO_DRIVER_INCLUDED_
`define WRITE_FIFO_DRIVER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: write_fifo_driver
// <Description_here>
//--------------------------------------------------------------------------------------------
class write_fifo_driver extends uvm_driver#(fifo_sequence_item);
  `uvm_component_utils(write_fifo_driver)

  //variable intf
  //DEfining virtual interface
  virtual fifo_if intf;

  //variable pkt
  //Declaring sequence item handle
  fifo_sequence_item pkt;

  bit[127:0] queue0[$];
  bit[127:0] queue1[$];
  bit[127:0] queue2[$];
  bit[127:0] queue3[$];
  bit[127:0] queue4[$];

  bit [1095:0] packet;

  int j=0,k=127;
  int i;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "write_fifo_driver", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset();
  extern virtual task drive(fifo_sequence_item pkt);
endclass : write_fifo_driver

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - write_fifo_driver
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function write_fifo_driver::new(string name = "write_fifo_driver",
                                 uvm_component parent = null);
  super.new(name, parent);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void write_fifo_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  uvm_config_db#(virtual fifo_if)::get(this,"","vif",intf);
  
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void write_fifo_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction : connect_phase

  task write_fifo_driver::reset();
    wait(!intf.rst);
    intf.wr_data<=0;
    intf.wr_en<=0;
    intf.rd_en<=0;
    wait(intf.rst);
  endtask

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task write_fifo_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);

    reset();
      forever begin
      pkt=fifo_sequence_item#()::type_id::create("pkt");
      seq_item_port.get_next_item(pkt);
      drive(pkt);
      seq_item_port.item_done();
      $display("DRIVER");
      
      `uvm_info("WRITE_FIFO_DRIVER", $sformatf("Data send to fifo_interface  wr_en : %0d , rd_en : %0d",pkt.wr_en,pkt.rd_en), UVM_NONE);
      `uvm_info("WRITE_FIFO_DRIVER test", $sformatf("type of axi : %0d ",pkt.type_of_axi), UVM_NONE);
    end
  endtask

  task write_fifo_driver::drive(fifo_sequence_item pkt);
    
    @(posedge intf.clk);
    intf.wr_en<=pkt.wr_en;
    intf.rd_en<=pkt.rd_en;
    //intf.wr_data<=pkt.wr_data;  //new updated
    //intf.wr_data<=packet;  //new updated
    // Write Address Channel
    
    /*
    if(pkt.type_of_axi == 0) begin
      packet = {pkt.sop, pkt.type_of_axi, pkt.awid, pkt.awlen, pkt.awsize, pkt.awburst, pkt.awaddr , pkt.eop};
      queue0.push_back(pkt.awaddr);
    end

// Write Data Channel
if(pkt.type_of_axi == 1) begin
      packet = {pkt.sop, pkt.type_of_axi, pkt.wid, pkt.wstrb, pkt.wdata, pkt.wlast, pkt.eop};
        queue1.push_back(pkt.wdata);
        intf.wr_data <= queue1[0];
        queue1.pop_front();
      end

// Read Address Channel
if(pkt.type_of_axi == 2) begin
      packet = {pkt.sop, pkt.type_of_axi, pkt.arid, pkt.arlen, pkt.arsize, pkt.arburst, pkt.araddr, pkt.eop};
       queue2.push_back(pkt.araddr);
     end

// Read Data Channel
if(pkt.type_of_axi == 3) begin
     packet = {pkt.sop, pkt.type_of_axi, pkt.rid, pkt.rresp, pkt.rlast, pkt.rdata , pkt.eop};
      queue3.push_back(pkt.rdata);
    end
// Write Response Channel
if(pkt.type_of_axi == 4) begin
     packet = {pkt.sop, pkt.type_of_axi, pkt.bid, pkt.bresp, pkt.eop};
     queue4.push_back(pkt.bresp);
   end
   */

  //Packet = {SOP (8 bits) + TXN_ID (4 bits) + ADDR (32 bits) + LEN (4 bits) + SIZE (3 bits) + BURST (2 bits) + LOCK (2 bits) + CACHE (2 bits) + PROT (3 bits) + STROBE (4 bits) + DATA (1024 bits) + EOP (8 bits)}
   //pkt.type_of_axi = 1;
  //pkt.type_of_axi=pkt.type_of_axi.next;
    if(pkt.type_of_axi == 0) begin
      //packet = {pkt.sop, pkt.type_of_axi, pkt.fifo_awid, pkt.fifo_awlen, pkt.fifo_awsize, pkt.fifo_awburst, pkt.fifo_awaddr , pkt.eop};
      packet = {pkt.sop,pkt.fifo_awid, pkt.fifo_awaddr, pkt.fifo_awlen, pkt.fifo_awsize, pkt.fifo_awburst, pkt.fifo_awlock, pkt.fifo_awcache, pkt.fifo_awprot, pkt.fifo_wstrb,40'b0000000000000000000000000000000000000000, pkt.eop};
      queue0.push_back(packet);
      //queue0.push_back(pkt.fifo_awaddr);
      //intf.wr_data <= packet;
      intf.wr_data <= queue0[0];
       queue0.pop_front();
      //queue0.push_back(packet);
    end

      `uvm_info("WRITE_FIFO_DRIVER packet [0]", $sformatf("packet : %0h  awaddr = %0h awsize = %0h awlen = %0h",packet,pkt.fifo_awaddr,pkt.fifo_awsize,pkt.fifo_awlen), UVM_NONE);

      // Write Data Channel
if(pkt.type_of_axi == 1) begin
      //packet = {pkt.sop, pkt.type_of_axi, pkt.fifo_wid, pkt.fifo_wstrb, pkt.fifo_wdata, pkt.fifo_wlast, pkt.eop};
      //packet = {pkt.sop,pkt.fifo_wid, pkt.fifo_wstrb, pkt.fifo_wdata, pkt.fifo_wlast, pkt.eop};
      packet = {pkt.sop,pkt.fifo_awid, pkt.fifo_awaddr, pkt.fifo_awlen, pkt.fifo_awsize, pkt.fifo_awburst, pkt.fifo_awlock, pkt.fifo_awcache, pkt.fifo_awprot, pkt.fifo_wstrb,pkt.fifo_wdata, pkt.eop};
        //queue1.push_back(packet);
        //queue1.push_back(pkt.fifo_wdata);
        //intf.wr_data <= queue1[0];
        //queue1.pop_front();
        //intf.wr_data <= packet;
       // int j=0,k=127;
        //for(i=0;i<2;i++) begin
          queue1.push_back(packet[127:0]);
          queue1.push_back(packet[255:128]);
          //queue1.push_back(packet[127:0]);
          `uvm_info("WRITE_FIFO_DRIVER packet [1]", $sformatf("Q0 = %0h",queue1[0]), UVM_NONE);
          `uvm_info("WRITE_FIFO_DRIVER packet [1]", $sformatf("Q1 = %0h",queue1[1]), UVM_NONE);
          //queue1.push_back(packet[k:j]);
          //j=j+128;
          //k=k+128;
        //end
          intf.wr_data=queue1.pop_front();
          `uvm_info("WRITE_FIFO_DRIVER packet [1]", $sformatf("intf.wr_data 0 = %0h",intf.wr_data), UVM_NONE);
         // intf.wr_data=queue1.pop_front();
         // `uvm_info("WRITE_FIFO_DRIVER packet [1]", $sformatf("intf.wr_data 1 = %0h",intf.wr_data), UVM_NONE);
      end
      `uvm_info("WRITE_FIFO_DRIVER packet [1]", $sformatf("packet : %0h, sop = %0h, eop = %0h, wid = %0h, wstrb= %0h, wdata =%0h, wlast= %0h",packet,pkt.sop,pkt.eop,pkt.fifo_wid,pkt.fifo_wstrb,pkt.fifo_wdata,pkt.fifo_wlast), UVM_NONE);
// Read Address Channel
if(pkt.type_of_axi == 2) begin
      //packet = {pkt.sop, pkt.type_of_axi, pkt.fifo_arid, pkt.fifo_arlen, pkt.fifo_arsize, pkt.fifo_arburst, pkt.fifo_araddr, pkt.eop};
      packet = {pkt.sop,pkt.fifo_arid, pkt.fifo_araddr, pkt.fifo_arlen, pkt.fifo_arsize, pkt.fifo_arburst, pkt.fifo_arlock, pkt.fifo_arcache, pkt.fifo_arprot, 8'b00000000, pkt.eop};
       //queue2.push_back(pkt.fifo_araddr);
       intf.wr_data <= packet;
     end

      `uvm_info("WRITE_FIFO_DRIVER packet [2]", $sformatf("packet : %0h ",packet), UVM_NONE);
// Read Data Channel
// Packet = {SOP(8 bits) + TXN_ID(4 bits) + READ_DATA(1024 bits) + READ_RESP(4 bits) + EOP(8 bits)}
if(pkt.type_of_axi == 3) begin
     packet = {pkt.sop, pkt.fifo_rid, pkt.fifo_rdata ,pkt.fifo_rresp, pkt.eop};
      //queue3.push_back(pkt.fifo_rdata);
     intf.wr_data <= packet;
    end
      `uvm_info("WRITE_FIFO_DRIVER packet [3]", $sformatf("packet : %0h ",packet), UVM_NONE);
// Write Response Channel
// Packet = {SOP(8 bits) + TXN_ID(4 bits) + WRITE_RESP(4 bits) + EOP(8 bits)}
if(pkt.type_of_axi == 4) begin
     packet = {pkt.sop, pkt.fifo_bid, pkt.fifo_bresp, pkt.eop};
     //queue4.push_back(pkt.fifo_bresp);
     intf.wr_data <= packet;
   end

      `uvm_info("WRITE_FIFO_DRIVER packet [4]", $sformatf("packet : %0h ",packet), UVM_NONE);
  pkt.type_of_axi=pkt.type_of_axi.next;
endtask : drive

`endif

