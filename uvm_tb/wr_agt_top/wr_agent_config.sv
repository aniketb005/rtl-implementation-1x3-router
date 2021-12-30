/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_wr_agent_config.sv   

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

// extend ram_wr_agent_config fro uvm_object

class wr_agent_config extends uvm_object;


// UVM Factory Registration Macro
`uvm_object_utils(wr_agent_config)

// Declare the virtual interface handle "vif"

virtual router_if vif;
 


//------------------------------------------
// Data Members
//------------------------------------------
// Is the agent active or passive
uvm_active_passive_enum is_active = UVM_ACTIVE;

// Declare the mon_rcvd_xtn_cnt as static int and initialize it to zero  
static int mon_rcvd_xtn_cnt = 0;

// Declare the drv_data_sent_cnt as static int and initialize it to zero 
static int drv_data_sent_cnt = 0;


//------------------------------------------
// Methods
//------------------------------------------
// Standard UVM Methods:
extern function new(string name = "wr_agent_config");

endclass: wr_agent_config
//-----------------  constructor new method  -------------------//

function wr_agent_config::new(string name = "wr_agent_config");
  super.new(name);
endfunction

 

