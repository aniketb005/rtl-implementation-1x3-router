/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_wr_driver.sv   

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------


   // Extend ram_wr_driver from uvm driver parameterized by write_xtn
	class wr_driver extends uvm_driver #(write_xtn);

   // Factory Registration

	`uvm_component_utils(wr_driver)

   // Declare virtual interface handle with WDR_MP as modport
   	virtual router_if.WDR_MP vif;

   // Declare the ram_wr_agent_config handle as "m_cfg"
        wr_agent_config m_cfg;



//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
     	
	extern function new(string name ="wr_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(write_xtn xtn);
	extern function void report_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
	function wr_driver::new(string name ="wr_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

//-----------------  build() phase method  -------------------//
 	function void wr_driver::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
          super.build_phase(phase);
	// get the config object using uvm_config_db 
	  if(!uvm_config_db #(wr_agent_config)::get(this,"","wr_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
        endfunction

//-----------------  connect() phase method  -------------------//
	// in connect phase assign the configuration object's virtual interface
	// to the driver's virtual interface instance(handle --> "vif")
 	function void wr_driver::connect_phase(uvm_phase phase);
          vif = m_cfg.vif;
        endfunction


//-----------------  run() phase method  -------------------//
	 // In forever loop
	    // Get the sequence item using seq_item_port
            // Call send_to_dut task 
            // Get the next sequence item using seq_item_port  

	task wr_driver::run_phase(uvm_phase phase);
               	forever begin
		seq_item_port.get_next_item(req);

		send_to_dut(req);
		seq_item_port.item_done();
		end
	endtask

//-----------------  task send_to_dut() method  -------------------//

   // Add task send_to_dut(write_xtn handle as an input argument)
	
	task wr_driver::send_to_dut(write_xtn xtn);
		// Print the transaction
                   // Add the write logic
`uvm_info("FROM WRITE DRIVER",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW) 
   

   
@(vif.write_driver_cb);
  vif.write_driver_cb.resetn <=1'b0;
@(vif.write_driver_cb);
 vif.write_driver_cb.resetn <=1'b1;

@(vif.write_driver_cb);
wait( ! vif.write_driver_cb.busy)


vif.write_driver_cb.pkt_valid <= 1'b1;
vif.write_driver_cb.data_in <= xtn.header;

@(vif.write_driver_cb);
foreach(xtn.payload[i])
begin
wait(! vif.write_driver_cb.busy)
vif.write_driver_cb.data_in <= xtn.payload[i];
@(vif.write_driver_cb);
end

wait(! vif.write_driver_cb.busy)
vif.write_driver_cb.data_in <= xtn.parity;
vif.write_driver_cb.pkt_valid <= 1'b0; 


m_cfg.drv_data_sent_cnt ++ ;
//req.print();
$display(" drv_data_sent_cnt= %d", m_cfg.drv_data_sent_cnt);
//$display(" uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");


         endtask

  // UVM report_phase
  function void wr_driver::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: RAM write driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
  endfunction



	


