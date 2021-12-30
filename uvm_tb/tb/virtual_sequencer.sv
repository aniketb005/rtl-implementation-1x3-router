/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_virtual_sequencer.sv   

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


   
   // Extend ram_virtual_sequencer from uvm_sequencer
	class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item) ;
   
   // Factory Registration
	`uvm_component_utils(virtual_sequencer)

   // LAB : Declare dynamic array of handles for ram_wr_sequencer and ram_rd_sequencer as wr_seqrh[] & rd_seqrh[]
        wr_sequencer wr_seqrh;
	rd_sequencer rd_seqrh[];

   // LAB : Declare handle for ram_env_config 
  	env_config m_cfg;


//------------------------------------------
// METHODS
//------------------------------------------

// Standard OVM Methods:
 	extern function new(string name = "virtual_sequencer",uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass

   // Define Constructor new() function
	function virtual_sequencer::new(string name="virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

   // function void build_phase(uvm_phase phase)
function void virtual_sequencer::build_phase(uvm_phase phase);
if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
if(m_cfg.has_virtual_sequencer)
begin
         if(m_cfg.has_ragent) 
         rd_seqrh= new[m_cfg.no_of_read_agents];
 end        
endfunction
