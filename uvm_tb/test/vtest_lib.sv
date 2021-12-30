/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_vtest_lib.sv   

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


   // Extend ram_base_test from uvm_test;
	class base_test extends uvm_test;

   // Factory Registration
	`uvm_component_utils(base_test)

  
         // Handles for ram_tb & ram_env_config
    	 tb envh;
         env_config m_tb_cfg;
         // LAB : Declare dynamic array of handles for ram_wr_agent_config & ram_rd_agent_config 
         //as m_wr_cfg[] & m_rd_cfg[]
         wr_agent_config m_wr_cfg;
         rd_agent_config m_rd_cfg[];

	// Declare no_of_duts, has_ragent, has_wagent as int which are local
	// variables to this test class

         int has_ragent = 1;
         int has_wagent = 1;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
//	extern function void config_ram();
        endclass
//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
   	function base_test::new(string name = "base_test" , uvm_component parent);
		super.new(name,parent);
	endfunction

	function void base_test::build_phase(uvm_phase phase);
               	m_tb_cfg = env_config::type_id::create("m_tb_cfg");
                if(has_wagent)begin
	    //    m_tb_cfg.m_wr_agent_cfg = new[1];
              //  m_wr_cfg= new[1];
              //  foreach( m_wr_cfg[i]) begin
                m_wr_cfg= wr_agent_config :: type_id :: create("m_wr_cfg",this);
                m_wr_cfg.is_active= UVM_ACTIVE;
              
                if(!uvm_config_db #(virtual router_if) :: get(this, " ","vif",m_wr_cfg.vif))
              	`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 

                m_tb_cfg.m_wr_agent_cfg=  m_wr_cfg;

                
               end
                if(has_ragent) begin
                m_tb_cfg.m_rd_agent_cfg = new[3];
                m_rd_cfg=new[3];
                foreach(m_rd_cfg[i]) begin

                m_rd_cfg[i]= rd_agent_config :: type_id :: create($sformatf("m_rd_cfg[%0d]",i));

                m_rd_cfg[i].is_active= UVM_ACTIVE;

                if(!uvm_config_db #(virtual router_if) :: get(this," ",$sformatf("vif%0d",i), m_rd_cfg[i].vif))
                `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 
                m_tb_cfg.m_rd_agent_cfg[i]= m_rd_cfg[i];
                    end
                end
	m_tb_cfg.has_wagent= has_wagent;
                m_tb_cfg.has_ragent= has_ragent;

       	 	uvm_config_db #(env_config)::set(this,"*","env_config",m_tb_cfg);
     	
                super.build_phase(phase);
		
		envh=tb::type_id::create("envh", this);
	endfunction

	

class test_1 extends base_test;
	`uvm_component_utils(test_1)

seq_1 seqrh1;


	extern function new(string name = "test_1" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------
function test_1 ::new(string name = "test_1" , uvm_component parent);
  super.new(name,parent);
endfunction

function void test_1::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task test_1::run_phase(uvm_phase phase);
$display("-------------TEST RUN PHASE--------------------------------------");
seqrh1 = seq_1 :: type_id :: create( "seqrh1") ;
phase.raise_objection(this);
seqrh1.start(envh.v_sequencer);
phase.drop_objection(this);
endtask
