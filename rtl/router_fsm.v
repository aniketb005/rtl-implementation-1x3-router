module fsm(clock,resetn,pkt_valid,data_in,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

input [1:0]data_in;

input clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid;

output write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;

parameter DECODE_ADDRESS= 3'b000,
          LOAD_FIRST_DATA= 3'b001,
          WAIT_TILL_EMPTY=3'b010,
          LOAD_DATA=3'b011,
          LOAD_PARITY=3'b100,
          FIFO_FULL_STATE=3'b101,
          LOAD_AFTER_FULL=3'b110,
          CHECK_PARITY_ERROR=3'b111;

reg[2:0] next_state,present_state; 

always@(posedge clock)
begin
  if(~resetn)
    present_state<= DECODE_ADDRESS;
 else if(soft_reset_0 || soft_reset_1 || soft_reset_2)
    present_state<=DECODE_ADDRESS;
  else
     present_state<= next_state;
end
 
always@(*)
begin
  next_state=present_state;
  case(present_state)
  DECODE_ADDRESS: begin
                 if((pkt_valid && (data_in[1:0]==2'd0) && fifo_empty_0) || 
                   (pkt_valid && (data_in[1:0]==2'd1) && fifo_empty_1) ||
                   (pkt_valid && (data_in[1:0]==2'd2) && fifo_empty_2))
                 next_state= LOAD_FIRST_DATA;
                 if((pkt_valid && (data_in[1:0]==2'd0) && ~fifo_empty_0) || 
                   (pkt_valid && (data_in[1:0]==2'd1) && ~fifo_empty_1) ||
                   (pkt_valid && (data_in[1:0]==2'd2) && ~fifo_empty_2))
                  next_state=WAIT_TILL_EMPTY;
                end

  LOAD_FIRST_DATA: next_state= LOAD_DATA;
 
  WAIT_TILL_EMPTY: begin
                 if(fifo_empty_0 || fifo_empty_1 || fifo_empty_2)
                   next_state=LOAD_FIRST_DATA;
                 if(~(fifo_empty_0) || ~(fifo_empty_1) || ~(fifo_empty_2))
                   next_state= WAIT_TILL_EMPTY;
                  end
  LOAD_DATA:  begin
            if(fifo_full==1'b1)
              next_state=FIFO_FULL_STATE;
            if(fifo_full==1'b0 && pkt_valid==1'b0)
              next_state=LOAD_PARITY;  
            end
  LOAD_PARITY: next_state= CHECK_PARITY_ERROR;

  FIFO_FULL_STATE:begin
                 if(fifo_full==1'b0)
                    next_state=LOAD_AFTER_FULL;
                 if(fifo_full==1'b1)
                    next_state=FIFO_FULL_STATE;
                  end
  LOAD_AFTER_FULL:begin 
                if(parity_done==1'b0 && low_packet_valid==1'b1)
                   next_state=LOAD_PARITY;
                 if(parity_done==1'b0 && low_packet_valid==1'b0)
                   next_state=LOAD_DATA;
                 if(parity_done)
                   next_state=DECODE_ADDRESS;
                 end
  CHECK_PARITY_ERROR: begin
                     if(!fifo_full)
                      next_state= DECODE_ADDRESS;
                    if(fifo_full)
                      next_state= FIFO_FULL_STATE; 
                     end
  endcase
end

assign detect_add= (present_state==DECODE_ADDRESS); 

assign lfd_state=(present_state==LOAD_FIRST_DATA);

assign busy= ((present_state==LOAD_FIRST_DATA)||(present_state==LOAD_PARITY)||(present_state==FIFO_FULL_STATE)||(present_state==LOAD_AFTER_FULL)||(present_state==WAIT_TILL_EMPTY)||(present_state==CHECK_PARITY_ERROR));

assign ld_state= (present_state==LOAD_DATA);

assign write_enb_reg= ((present_state==LOAD_DATA)||(present_state==LOAD_PARITY)||(present_state==LOAD_AFTER_FULL));

assign full_state=(present_state==FIFO_FULL_STATE);

assign laf_state=(present_state==LOAD_AFTER_FULL);

assign rst_int_reg=(present_state==CHECK_PARITY_ERROR);

endmodule
