`ifndef FIFO_BFM_WR_RD_SEQ_INCLUDED_
`define FIFO_BFM_WR_RD_SEQ_INCLUDED_


class fifo_bfm_wr_rd_seq extends fifo_bfm_base_seq;

`uvm_object_utils(fifo_bfm_wr_rd_seq)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  //extern function new(string name = "fifo_bfm_wr_rd_seq", uvm_component parent = null);
  extern function new(string name = "fifo_bfm_wr_rd_seq");
  extern virtual task body();

endclass:fifo_bfm_wr_rd_seq

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes fifo_bfm_wr_rd_seq class object
//
// Parameters:
//  name - fifo_bfm_wr_rd_seq
//-----------------------------------------------------------------------------

//function fifo_bfm_wr_rd_seq::new(string name="fifo_bfm_wr_rd_seq",uvm_component parent = null);
function fifo_bfm_wr_rd_seq::new(string name="fifo_bfm_wr_rd_seq");
super.new(name);
endfunction:new

//--------------------------------------------------------------------------------------------
// Task: body
// task for fifo wr rd type sequence
//--------------------------------------------------------------------------------------------

task fifo_bfm_wr_rd_seq:: body(); 
begin
  fifo_sequence_item req;
  req=fifo_sequence_item#()::type_id::create("req");
  start_item(req);
  assert(req.randomize()with{req.wr_en==1 && req.rd_en==1;})
  `uvm_info("WR_RD_SEQ", $sformatf("Data send to Driver  wr_en : %0d , rd_en : %0d",req.wr_en,req.rd_en), UVM_NONE);
  finish_item(req);
end
endtask:body

`endif
