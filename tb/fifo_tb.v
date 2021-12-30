module fifo_router_tb();
parameter width=9;
reg lfd_state;
reg [width-2:0] data_in;
reg clock,resetn,read_enb,write_enb,soft_reset;
wire[width-2:0] data_out;
integer i;

parameter cycle = 10;

fifo dut(.clock(clock),.resetn(resetn),.data_in(data_in),.read_enb(read_enb),.write_enb(write_enb),.data_out(data_out),.full(full),.empty(empty),.lfd_state(lfd_state),.soft_reset(soft_reset));

//clock
always
begin
  #(cycle/2) clock=1'b0;
  #(cycle/2) clock=1'b1;
end

//soft_reset
task soft_resetf;
begin
  @(negedge clock);
  soft_reset= 1'b1;
  @(negedge clock);
  soft_reset= 1'b0;
end
endtask

//initialize
task initialize;
begin
  read_enb=0;
  write_enb=0;
end
endtask

//reset
task resetf;
begin
  @(negedge clock);
  resetn= 1'b0;
  @(negedge clock);
  resetn= 1'b1;
end
endtask

task pkt_gen;

reg[7:0]payload_data,parity,header;
reg[5:0]payload_len;
reg[1:0]addr;

begin
  @(negedge clock);
  payload_len=6'd4;
  addr=2'b01;
  header={payload_len,addr};
  data_in=header;
  lfd_state=1'b1;write_enb=1;

  for(i=0;i<payload_len;i=i+1)
  begin
    @(negedge clock);
    lfd_state=0;
    payload_data={$random}%256;
    data_in=payload_data;
  end

  @(negedge clock);
  parity={$random}%256;
  data_in=parity;
end
endtask

initial
begin
  initialize;
  resetf;
  soft_resetf;
  pkt_gen;
  repeat(2)
  @(negedge clock);
  read_enb=1'b1;
  @(negedge clock);
  wait(empty)
  @(negedge clock);
  read_enb=1'b0;
end

initial
begin
  $dumpfile("dump.vcd");
  $dumpvars();
  #1000 $finish;
end

initial
  $monitor("soft_reset=%b, lfd_state=%b, full=%b, empty=%b, data_in=%b, data_out=%b, resetn=%b, read_enb=%b, write_enb=%b",soft_reset,lfd_state,full,empty,data_in,data_out,resetn,read_enb,write_enb);

endmodule


