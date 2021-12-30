/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_rd_agent.sv   

Version:	1.0

************************************************************************/

//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

   // Extend ram_rd_agent from uvm_agent
	class rd_agent extends uvm_agent;

   // Factory Registration
	`uvm_component_utils(rd_agent)

   // Declare handle for configuration object
        rd_agent_config m_cfg;
       
   // Declare handles of ram_wr_monitor,ram_wr_sequencer and ram_wr_driver
	rd_monitor monh;
	rd_sequencer m_sequencer;
	rd_driver drvh;
    rd_agent_config r_cfg;

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
  extern function new(string name = "rd_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : rd_agent
//-----------------  constructor new method  -------------------//

       function rd_agent::new(string name = "rd_agent", 
                               uvm_component parent = null);
         super.new(name, parent);
       endfunction
     
  
//-----------------  build() phase method  -------------------//
         // Call parent build phase
         // Create ram_wr_monitor instance
         // If is_active=UVM_ACTIVE, create ram_wr_driver and ram_wr_sequencer instances
	function void rd_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
                // get the config object using uvm_config_db 
      
               
                
                if(!uvm_config_db #(rd_agent_config) :: get(this, " ", "rd_agent_config", r_cfg ) )
               	`uvm_fatal("CONFIG","cannot get() r_cfg from uvm_config_db. Have you set() it?")
                 monh= rd_monitor :: type_id :: create("monh",this);
                 
                if(r_cfg.is_active== UVM_ACTIVE) 
                 begin
                 drvh= rd_driver :: type_id :: create("drvh",this);
                 m_sequencer= rd_sequencer :: type_id :: create("m_sequencer",this);
                 end
              
	endfunction

      
//-----------------  connect() phase method  -------------------//
	//If is_active=UVM_ACTIVE, 
        //connect driver(TLM seq_item_port) and sequencer(TLM seq_item_export)
      
	function void rd_agent::connect_phase(uvm_phase phase);

              
              
		if(r_cfg.is_active==UVM_ACTIVE)
             	drvh.seq_item_port.connect(m_sequencer.seq_item_export);
              
	endfunction
   

   


