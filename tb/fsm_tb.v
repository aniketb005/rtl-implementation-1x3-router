module fsm_router_tb();

reg  clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid;
wire  write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;
reg [1:0]data_in;
fsm dut(clock,resetn,pkt_valid,data_in,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

parameter cycle=10;

always
begin
  #(cycle/2) clock=1'b0;
  #(cycle/2) clock=1'b1;
end

task resetf;
begin
  @(negedge clock);
  resetn=1'b0;
  @(negedge clock)
  resetn=1'b1;
end
endtask

task stimulusa;
begin
  @(negedge clock);
  pkt_valid=1'b1;
  data_in=2'b00;
  fifo_empty_0=1'b1;
  @(negedge clock);
  @(negedge clock);
  fifo_full=1'b0;
  pkt_valid=1'b0;
  @(negedge clock);
  fifo_full=1'b0;
end
endtask

task stimulusb;
begin
  @(negedge clock);
  pkt_valid=1'b1;
  data_in=2'b00;
  fifo_empty_0=1'b1;
  @(negedge clock);
  @(negedge clock);
  fifo_full=1'b1;
  @(negedge clock);
  fifo_full=1'b0;
  @(negedge clock);
  parity_done=1'b0;
  low_packet_valid=1'b1;
  @(negedge clock);
  fifo_full=1'b0;
end
endtask

initial
begin
  resetf;
  @(negedge clock);
  stimulusa;
  @(negedge clock);
  stimulusb;
end

initial 
begin
  $monitor("pkt_valid=%b,data_in=%b,fifo_empty_0=%b,fifo_full=%b,parity_done=%b,low_packet_valid=%b",pkt_valid,data_in,fifo_empty_0,fifo_full,parity_done,low_packet_valid);
end


initial
begin
  $dumpfile("fsm.vcd");
  $dumpvars();
  #1000 $finish;
end

initial 
$monitor("pkt_valid=%b,data_in=%b,fifo_empty_0=%b,fifo_full=%b,parity_done=%b,low_packet_valid=%b",pkt_valid,data_in,fifo_empty_0,fifo_full,parity_done,low_packet_valid);

endmodule






