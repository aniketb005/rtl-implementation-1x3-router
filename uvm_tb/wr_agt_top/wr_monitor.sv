/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	ram_wr_monitor.sv   

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

   // Extend ram_wr_monitor from uvm_monitor

class wr_monitor extends uvm_monitor;

  // Factory Registration
	`uvm_component_utils(wr_monitor)

  // Declare virtual interface handle with WMON_MP as modport
   	virtual router_if.WMON_MP vif;

  // Declare the ram_wr_agent_config handle as "m_cfg"
        wr_agent_config m_cfg;

  // Analysis TLM port to connect the monitor to the scoreboard for lab09
  	uvm_analysis_port #(write_xtn) monitor_port;
    
int d[];

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "wr_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
extern function void report_phase(uvm_phase phase);

endclass 
//-----------------  constructor new method  -------------------//
	function wr_monitor::new(string name = "wr_monitor", uvm_component parent);
		super.new(name,parent);
		// create object for handle monitor_port using new
 		monitor_port = new("monitor_port", this);

  	endfunction

//-----------------  build() phase method  -------------------//
 	function void wr_monitor::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
          super.build_phase(phase);
	// get the config object using uvm_config_db 
	  if(!uvm_config_db #(wr_agent_config)::get(this,"","wr_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
        endfunction

//-----------------  connect() phase method  -------------------//
	// in connect phase assign the configuration object's virtual interface
	// to the monitor's virtual interface instance(handle --> "vif")
 	function void wr_monitor::connect_phase(uvm_phase phase);
          vif = m_cfg.vif;
        endfunction


//-----------------  run() phase method  -------------------//
	

        // In forever loop
        // Call task collect_data
       task wr_monitor::run_phase(uvm_phase phase);
        forever
        // Call collect data task
       collect_data();     
       endtask


   // Collect Reference Data from DUV IF 
  task wr_monitor::collect_data();
  write_xtn data_sent;
  data_sent= write_xtn :: type_id :: create("data_sent",this);
 
  data_sent.payload= new[data_sent.header[7:2]];
 @(vif.write_monitor_cb);
  wait( ! vif.write_monitor_cb.busy && vif.write_monitor_cb.pkt_valid )
   data_sent.header = vif.write_monitor_cb.data_in; 
 @(vif.write_monitor_cb);
 foreach(data_sent.payload[i])
 begin
 wait( ! vif.write_monitor_cb.busy)
 data_sent.payload[i] = vif.write_monitor_cb.data_in;
 @(vif.write_monitor_cb);
 end
 
 @(vif.write_monitor_cb);
 wait(!vif.write_monitor_cb.busy && !vif.write_monitor_cb.pkt_valid)
 data_sent.parity =  vif.write_monitor_cb.data_in;

monitor_port.write(data_sent);
       endtask

// UVM report_phase
  function void wr_monitor::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: RAM Write Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
  endfunction 

