/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_rd_agt_top.sv   

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

   // Extend ram_rd_agt_top from uvm_env;
	class rd_agt_top extends uvm_env;

   // Factory Registration
	`uvm_component_utils(rd_agt_top)
    
   // Create the agent handle
      	 rd_agent agnth[];
        env_config m_cfg;
     //------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "rd_agt_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
  endclass
//-----------------  constructor new method  -------------------//
   // Define Constructor new() function
   	function rd_agt_top::new(string name = "rd_agt_top" , uvm_component parent);
		super.new(name,parent);
	endfunction

    
//-----------------  build() phase method  -------------------//
       	function void rd_agt_top::build_phase(uvm_phase phase);
     		super.build_phase(phase);
// Create the instance of ram_rd_agent
             
               	if(! uvm_config_db #(env_config)::get(this," ","env_config",m_cfg))
                  	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
        agnth=new[m_cfg.no_of_read_agents];


        foreach(m_cfg.m_rd_agent_cfg[i]) begin
               	agnth[i]= rd_agent::type_id::create($sformatf("agnth[%0d]",i),this);
$display("READ AGENT ADDR IS **********************************************%0d",agnth[i]);

                uvm_config_db #(rd_agent_config) :: set(this, $sformatf("agnth[%0d]*",i),"rd_agent_config",m_cfg.m_rd_agent_cfg[i]);
   	           end
       
	endfunction


//-----------------  run() phase method  -------------------//
       // Print the topology
	task rd_agt_top::run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask   


