`ifndef FIFO_SEQUENCE_ITEM_INCLUDED_
`define FIFO_SEQUENCE_ITEM_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: fifo_sequence_item
// <Description_here>
//--------------------------------------------------------------------------------------------
class fifo_sequence_item #(int ADDRESS_WIDTH=32,DATA_WIDTH=128) extends uvm_sequence_item;
  //packet declaration
  rand bit wr_en;
  rand bit rd_en;
  rand bit full;
  rand bit empty;
  bit [127:0] wr_data;
  bit [127:0] rd_data;

  const logic [7:0] sop=8'b01010101;
  const logic [7:0] eop=8'b10101011;
  //packet = [];
  enum bit [2:0] {axi_fifo_write_address_enable=0,
                           axi_fifo_write_data_enable1=1,
                           axi_fifo_read_address_enable=2,
                           axi_fifo_read_data_enable=3,
                           axi_fifo_response_enable=4} type_of_axi;
  
  //write Address Channel
  //rand bit [3:0] fifo_id;
  rand bit [3:0] fifo_awid;
  rand bit [ADDRESS_WIDTH-1:0] fifo_awaddr;
  rand bit [3:0] fifo_awlen;
  rand bit [2:0] fifo_awsize;
  rand bit [1:0] fifo_awburst;
  rand bit [1:0] fifo_awlock;
  rand bit [1:0] fifo_awcache;
  rand bit [2:0] fifo_awprot;
  //rand bit [3:0] awqos;
  //rand bit [3:0] awregion;
  //logic awuser;
  //logic awvalid;
  //logic awready;

  //Write data channel
  rand bit [3:0] fifo_wid;
  rand bit [DATA_WIDTH-1:0] fifo_wdata;
  rand bit [(DATA_WIDTH/8)-1:0] fifo_wstrb;
  rand bit fifo_wlast;
  //logic [3:0] fifo_wuser;
  //logic fifo_wvalid;
  //logic fifo_wready;

  //Write response channel
  rand bit [3:0] fifo_bid;
  rand bit [1:0] fifo_bresp;
  //rand bit [3:0] fifo_buser;
  //rand  bit fifo_bvalid ;
  //rand bit fifo_bready;

  //Read Address channel
  rand bit [3:0] fifo_arid;
  rand bit [ADDRESS_WIDTH-1:0] fifo_araddr;
  rand bit [3:0] fifo_arlen;
  rand bit [2:0] fifo_arsize;
  rand bit [1:0] fifo_arburst;
  rand bit [1:0] fifo_arlock;
  rand bit [1:0] fifo_arcache;
  rand bit [2:0] fifo_arprot;
  //rand bit [3:0] fifo_arqos;
  //rand bit [3:0] fifo_arregion;
  //rand bit [3:0] fifo_aruser;
  //logic arvalid;
  //logic arready;

  //Read data channel
  rand bit [3:0] fifo_rid;
  rand bit [DATA_WIDTH-1:0] fifo_rdata;
  rand bit [1:0] fifo_rresp;
  rand bit fifo_rlast;
  //logic [3:0] ruser;
  //logic rvalid;
  //logic rready;

  `uvm_object_param_utils_begin(fifo_sequence_item#(ADDRESS_WIDTH,DATA_WIDTH))
  
  `uvm_field_int(fifo_awid,UVM_ALL_ON)
  `uvm_field_int(fifo_awaddr,UVM_ALL_ON)
  `uvm_field_int(fifo_awlen,UVM_ALL_ON)
  `uvm_field_int(fifo_awsize,UVM_ALL_ON)
  `uvm_field_int(fifo_awburst,UVM_ALL_ON)
  `uvm_field_int(fifo_awlock,UVM_ALL_ON )
  `uvm_field_int(fifo_awcache,UVM_ALL_ON)
  `uvm_field_int(fifo_awprot,UVM_ALL_ON)
  //`uvm_field_int(awqos,UVM_ALL_ON)
  //`uvm_field_int(awregion,UVM_ALL_ON)
  
  `uvm_field_int(fifo_wid,UVM_ALL_ON)
  `uvm_field_int(fifo_wdata,UVM_ALL_ON)
  `uvm_field_int(fifo_wstrb,UVM_ALL_ON)
  `uvm_field_int(fifo_wlast,UVM_ALL_ON)
  //`uvm_field_array_int(wuser,UVM_ALL_ON)
  //`uvm_field_array_int(wvalid,UVM_ALL_ON)
  //`uvm_field_array_int(wready,UVM_ALL_ON)

  `uvm_field_int(fifo_bid,UVM_ALL_ON)
  `uvm_field_int(fifo_bresp,UVM_ALL_ON)
  //`uvm_field_int(buser,UVM_ALL_ON)
  //`uvm_field_int(bvalid,UVM_ALL_ON)
  //`uvm_field_int(bready,UVM_ALL_ON)

  `uvm_field_int(fifo_arid,UVM_ALL_ON)
  `uvm_field_int(fifo_araddr,UVM_ALL_ON)
  `uvm_field_int(fifo_arlen,UVM_ALL_ON)
  `uvm_field_int(fifo_arsize,UVM_ALL_ON)
  `uvm_field_int(fifo_arburst,UVM_ALL_ON)
  `uvm_field_int(fifo_arlock,UVM_ALL_ON)
  `uvm_field_int(fifo_arcache,UVM_ALL_ON)
  `uvm_field_int(fifo_arprot,UVM_ALL_ON)
  //`uvm_field_int(arqos,UVM_ALL_ON)
  //`uvm_field_int(arrigion,UVM_ALL_ON)
  //`uvm_field_int(aruser,UVM_ALL_ON)
  //`uvm_field_int(arvalid,UVM_ALL_ON)
  //`uvm_field_int(arready,UVM_ALL_ON)

  `uvm_field_int(fifo_rid,UVM_ALL_ON)
  `uvm_field_int(fifo_rdata,UVM_ALL_ON)
  `uvm_field_int(fifo_rresp,UVM_ALL_ON)
  `uvm_field_int(fifo_rlast,UVM_ALL_ON)
  //`uvm_field_int(rvalid,UVM_ALL_ON)
  //`uvm_field_int(rready,UVM_ALL_ON)

  `uvm_object_utils_end

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "fifo_sequence_item");
endclass : fifo_sequence_item

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
//  name - fifo_sequence_item
//--------------------------------------------------------------------------------------------
function fifo_sequence_item::new(string name = "fifo_sequence_item");
  super.new(name);
endfunction : new

`endif
