/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_rd_driver.sv   

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


   // Extend ram_rd_driver from uvm driver parameterized by read_xtn
	class rd_driver extends uvm_driver #(read_xtn);

   // Factory Registration

	`uvm_component_utils(rd_driver)

   // Declare virtual interface handle with RDR_MP as modport
   	virtual router_if.RDR_MP vif;

   // Declare the ram_wr_agent_config handle as "m_cfg"
        rd_agent_config m_cfg;



//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
     	
	extern function new(string name ="rd_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(read_xtn duv_xtn);
	extern function void report_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//
 
	 function rd_driver::new (string name ="rd_driver", uvm_component parent);
   	   super.new(name, parent);
 	 endfunction : new

//-----------------  build() phase method  -------------------//
 	function void rd_driver::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
          super.build_phase(phase);
         
// get the config object using uvm_config_db 
         
	  if(!uvm_config_db #(rd_agent_config)::get(this,"","rd_agent_config",m_cfg)) 
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
        endfunction

//-----------------  connect() phase method  -------------------//
	// in connect phase assign the configuration object's virtual interface
	// to the driver's virtual interface instance(handle --> "vif")
 	function void rd_driver::connect_phase(uvm_phase phase);
          
          vif = m_cfg.vif;
        endfunction

//-----------------  run() phase method  -------------------//
	 // In forever loop
	    // Get the sequence item using seq_item_port
            // Call send_to_dut task 
            // Get the next sequence item using seq_item_port  

	task rd_driver::run_phase(uvm_phase phase);
               	forever begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
		end
	endtask


//-----------------  task send_to_dut() method  -------------------//


task rd_driver::send_to_dut (read_xtn duv_xtn);

fork: a1
begin
@(vif.read_driver_cb);
wait( vif.read_driver_cb.vld_out)
repeat(duv_xtn.no_of_clocks) 
@(vif.read_driver_cb);
vif.read_driver_cb.read_enb <= 1'b1;

wait(! vif.read_driver_cb.vld_out)
vif.read_driver_cb.read_enb <= 1'b0;
end

begin
repeat(95) 
@(vif.read_driver_cb);
end
join_any

//duv_xtn.print();
disable a1;




endtask 

  // UVM report_phase
  function void rd_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: RAM read driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
  endfunction 





   







