/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_wr_sequencer.sv   

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


// Extend ram_wr_sequencer from uvm_sequencer parameterized by write_xtn
	class wr_sequencer extends uvm_sequencer #(write_xtn);

// Factory registration using `uvm_component_utils
	`uvm_component_utils(wr_sequencer)

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "wr_sequencer",uvm_component parent);
	endclass
//-----------------  constructor new method  -------------------//
	function wr_sequencer::new(string name="wr_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction



