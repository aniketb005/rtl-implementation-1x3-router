/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_wr_seqs.sv   

Version:	1.0

************************************************************************/

//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

 
  // Extend ram_wbase_seq from uvm_sequence parameterized by write_xtn 
	class wbase_seq extends uvm_sequence #(write_xtn);  
	
  // Factory registration using `uvm_object_utils

	`uvm_object_utils(wbase_seq)  
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
        extern function new(string name ="wbase_seq");
	endclass
//-----------------  constructor new method  -------------------//
	function wbase_seq::new(string name ="wbase_seq");
		super.new(name);
	endfunction

//------------------------------------------------------------------------------
//
// SEQUENCE: Ram Single address Write Transactions   
//
//------------------------------------------------------------------------------


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


  // Extend ram_single_addr_wr_xtns from ram_wbase_seq;
	class sequence1 extends wbase_seq;

  	
  // Factory registration using `uvm_object_utils
  	`uvm_object_utils(sequence1)

//------------------------------------------
// METHODS
//------------------------------i------------

// Standard UVM Methods:
        extern function new(string name ="sequence1");
        extern task body();
	endclass
//-----------------  constructor new method  -------------------//
	function sequence1::new(string name = "sequence1");
		super.new(name);
	endfunction

	  
//-----------------  task body method  -------------------//
      // Generate 10 sequence items with address always equal to 55
      // Hint use create req, start item, assert for randomization with in line
      //  constraint (with) finish item inside repeat's begin end block 
	
	task sequence1::body();
     

           $display("-------------------------------------------------------SEQUENCE-------");
   	   req= write_xtn :: type_id :: create("req");
	// repeat(1)
	//begin	
	   start_item(req);
   	   assert(req.randomize() with {header[7:2] < 4'd14;} );
	   	   finish_item(req);
	          $display("-------------------------------------------------------SEQUENCE-------");

	 //end 
    	endtask



