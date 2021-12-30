/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_virtual_seqs.sv   

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------



//------------------------------------------------------------------------------
//
// SEQUENCE: Base RAM virtual sequence - base virtual sequence with objections from which 
// all virtual sequences can be derived
//
//------------------------------------------------------------------------------

  // Extend ram_vbase_seq from uvm_sequence parameterized by uvm_sequence_item;

class vbase_seq extends uvm_sequence #(uvm_sequence_item);

	
  // Factory registration
	`uvm_object_utils(vbase_seq)  
  // LAB : Declare dynamic array of handles for ram_wr_sequencer and ram_rd_sequencer as wr_seqrh[] & rd_seqrh[]
       wr_sequencer wr_seqrh;
        rd_sequencer rd_seqrh[];
  // Declare handle for virtual sequencer
        virtual_sequencer vsqrh;
  // Declare dynamic array of Handles for all the sequences

  // LAB :  Declare handle for ram_env_config
	env_config m_cfg; 

   sequence1 seqrh;
  rd_xtns_seq rd_seq[]; 
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "vbase_seq");
	extern task body();
	endclass :vbase_seq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function vbase_seq::new(string name ="vbase_seq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//


task vbase_seq::body();
 
	  if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
  

  assert($cast(vsqrh,m_sequencer)) else begin
    `uvm_error("BODY", "Error in $cast of virtual sequencer")
  end

 if(m_cfg.has_wagent)
  wr_seqrh = vsqrh.wr_seqrh;
 if(m_cfg.has_ragent) begin
 rd_seqrh= new[m_cfg.no_of_read_agents];
 foreach(rd_seqrh[i])
  rd_seqrh[i] = vsqrh.rd_seqrh[i];
 end
endtask: body

   
class seq_1 extends vbase_seq;
	`uvm_object_utils(seq_1)  



	extern function new(string name = "seq_1");
	extern task body();
endclass :seq_1
 
function seq_1::new(string name ="seq_1");
		super.new(name);
endfunction

task seq_1::body();
super.body();

seqrh= sequence1 :: type_id :: create("seqrh");
rd_seq= new[m_cfg.no_of_read_agents];
foreach(rd_seq[i])
rd_seq[i]= rd_xtns_seq :: type_id :: create($sformatf("rd_seq[%0d]",i));
fork
seqrh.start(wr_seqrh);
fork
rd_seq[0].start(rd_seqrh[0]);
rd_seq[1].start(rd_seqrh[1]);
rd_seq[2].start(rd_seqrh[2]);
join
join
endtask
