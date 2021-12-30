/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_rd_seqs.sv   

Version:	1.0

************************************************************************/

//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

 
  // Extend ram_rbase_seq from uvm_sequence parameterized by read_xtn 
	class rbase_seq extends uvm_sequence #(read_xtn);  
	
  // Factory registration using `uvm_object_utils

	`uvm_object_utils(rbase_seq)  
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
        extern function new(string name ="rbase_seq");
	endclass
//-----------------  constructor new method  -------------------//
	function rbase_seq::new(string name ="rbase_seq");
		super.new(name);
	endfunction

//------------------------------------------------------------------------------
//
// SEQUENCE: Ram Single address read Transactions   
//
//------------------------------------------------------------------------------


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


  // Extend ram_ten_rd_xtns from ram_rbase_seq;
	class rd_xtns_seq extends rbase_seq;

  	
  // Factory registration using `uvm_object_utils
  	`uvm_object_utils(rd_xtns_seq)

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
        extern function new(string name ="rd_xtns_seq");
        extern task body();
	endclass

	function rd_xtns_seq::new(string name = "rd_xtns_seq");
		super.new(name);
	endfunction

	  
//-----------------  task body method  -------------------//
      	// read the random data on memory address locations consecutively from 0 to 9
       // Hint use create req, start item, assert for randomization with in line
      //  constraint (with) finish item inside repeat's begin end block    
	
       task rd_xtns_seq ::body();
 
	super.body();
   //	repeat(1) begin
	req=read_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {no_of_clocks< 30;} );
	finish_item(req);

	//end
       endtask


