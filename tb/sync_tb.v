module sync_router_tb();

reg clock,resetn,data_in,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2;
wire vld_out_0,vld_out_1,vld_out_2,soft_reset_0,soft_reset_1,soft_reset_2;

wire[2:0] write_enb;
wire fifo_full;
reg [1:0]data;

parameter cycle=10;

sync dut(clock,resetn,data_in,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,fifo_full,vld_out_0,vld_out_1,vld_out_2,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,write_enb);

//clock
always
begin
  #(cycle/2) clock=1'b0;
  #(cycle/2) clock=1'b1;
end

//reset
task resetf;
begin
  @(negedge clock);
  resetn= 1'b0;
  @(negedge clock);
  resetn= 1'b1;
end
endtask

task initialize();
begin

  data_in=2'b0;
  detect_add=1'b0;
  full_0=1'b0;
  full_1=1'b0;
  full_2=1'b0;
  empty_0=1'b0;
  empty_1=1'b0;
  empty_2=1'b0;
  write_enb_reg=1'b0;
  read_enb_0=1'b0;
  read_enb_1=1'b0;
  read_enb_2=1'b0;
end
endtask

initial
begin
  resetf;
  initialize;
  #10
  read_enb_0=1'b1;
  empty_0=1'b0;
  
  #10
  read_enb_0=1'b0;
  empty_0=1'b1;
  
  #10
  read_enb_0=1'b1;
  empty_0=1'b1;
  
  #10
  read_enb_0=1'b0;
  empty_0=1'b0;
end

initial
  $monitor("read_enb_0=%b, vld_out_0=%b, soft_reset_0=%b",read_enb_0, vld_out_0,soft_reset_0);


initial
begin
  $dumpfile("sync.vcd");
  $dumpvars();
  #1000 $finish;
end
endmodule
