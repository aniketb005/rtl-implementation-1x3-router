/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_wr_agt_top.sv   

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

   // Extend ram_wr_agt_top from uvm_env;
	class wr_agt_top extends uvm_env;

   // Factory Registration
	`uvm_component_utils(wr_agt_top)
    
   // Create the agent handle
      	 wr_agent agnth;
         env_config m_cfg;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "wr_agt_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
  endclass
//-----------------  constructor new method  -------------------//
   // Define Constructor new() function
   	function wr_agt_top::new(string name = "wr_agt_top" , uvm_component parent);
		super.new(name,parent);
	endfunction

    
//-----------------  build() phase method  -------------------//
       	function void wr_agt_top::build_phase(uvm_phase phase);
     		super.build_phase(phase);
        	if(! uvm_config_db  #(env_config) :: get(this," ","env_config",m_cfg))
                  `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
       	agnth=wr_agent::type_id::create("agnth",this);
        uvm_config_db #(wr_agent_config) :: set(this,"*","wr_agent_config",m_cfg.m_wr_agent_cfg);
// Create the instance of ram_wr_agent
   	           
	endfunction


//-----------------  run_phase method  -------------------//
       // Print the topology
	task wr_agt_top::run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask   


