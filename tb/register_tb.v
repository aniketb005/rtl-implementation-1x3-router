module register_router_tb();

reg [7:0]data_in;
reg clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg;
wire[7:0]dout;
wire err,parity_done,low_packet_valid;

parameter cycle=10;
integer i;

register dut(clock,resetn,pkt_valid,data_in,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,err,parity_done,low_packet_valid,dout);

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


task initialize;
begin
  {pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg}=0;
end
endtask


task pkt_gen_reg;

reg[7:0]payload_data,parity,header;
reg[5:0]payload_len;
reg[1:0]addr;

begin
  @(negedge clock);
  payload_len=6'd3;
  addr=2'b10;
  pkt_valid=1;detect_add=1;
  header={payload_len,addr};
  parity=0^header;
  data_in=header;@(negedge clock)
  detect_add=0;lfd_state=1;full_state=0;fifo_full=0;laf_state=0;

  for(i=0;i<payload_len;i=i+1)
  begin
    @(negedge clock);
    lfd_state=0;ld_state=1;
    payload_data={$random}%256;
    data_in=payload_data;
  parity=parity^data_in;
  end

  @(negedge clock);
  pkt_valid=0;
  data_in=parity;
  @(negedge clock)
  ld_state=0;
end
endtask

initial
begin
  initialize;
  #10;
  resetf;
  #10;
  pkt_gen_reg;
  #10;
end

initial
begin
  $monitor("pkt_valid=%b,fifo_full=%b,detect_add=%b,ld_state=%b,laf_state=%b,full_state=%b,lfd_state=%b,rst_int_reg=%b,err=%b,parity_done=%b,low_packet_valid=%b,dout=%b,data_in=%b",pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,err,parity_done,low_packet_valid,dout,data_in);
end

initial
begin
  $dumpfile("register.vcd");
  $dumpvars();
  #1000 $finish;
end

endmodule



