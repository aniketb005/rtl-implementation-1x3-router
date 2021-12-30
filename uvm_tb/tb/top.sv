/************************************************************************

 Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
 
 www.maven-silicon.com
 
 All Rights Reserved
   
 This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
 It is not to be shared with or used by any third parties who have not enrolled for our
 paid training courses or received any written authorization from Maven Silicon.

Filename:	top.sv   

Version:	1.0

************************************************************************/

module top;
       import test_pkg::*;
 	import uvm_pkg::*;
bit clock;

always
begin
#10 clock= ! clock;
end

router_if in(clock);
router_if in0(clock);
router_if in1(clock);
router_if in2(clock);

router DUV(.clock(clock),.data_in(in.data_in),.resetn(in.resetn),.pkt_valid(in.pkt_valid),.err(in.err),.busy(in.busy),.data_out_0(in0.data_out),.data_out_1(in1.data_out),.data_out_2(in2.data_out),.vld_out_0(in0.vld_out),.vld_out_1(in1.vld_out),.vld_out_2(in2.vld_out),.read_enb_0(in0.read_enb),.read_enb_1(in1.read_enb),.read_enb_2(in2.read_enb) );   


initial
begin
uvm_config_db #(virtual router_if) :: set(null,"*", "vif",in);
uvm_config_db #(virtual router_if) :: set(null,"*", "vif0",in0);
uvm_config_db #(virtual router_if) :: set(null,"*", "vif1",insss);
uvm_config_db #(virtual router_if) :: set(null,"*", "vif2",in2);

run_test();
end
endmodule  
   
  
