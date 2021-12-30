module register(clock,resetn,pkt_valid,data_in,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,err,parity_done,low_packet_valid,dout);

input [7:0]data_in;
input clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg;

output reg[7:0]dout;
output reg err,parity_done,low_packet_valid;

reg [7:0] full_state_byte,internal_parity,header,packet_parity;

//dout
always@(posedge clock)
begin
  if(!resetn)
  dout<=0;
  else
  begin
   if(~(detect_add))
         begin
           if(~(lfd_state))
             begin
               if(~(ld_state && ~fifo_full))
                  begin
                     if(~(ld_state && fifo_full))
                        begin 
                          if(~(laf_state))
                            dout<=dout;
                          else
                            dout<=full_state_byte;
                        end
                       else
                         dout<=dout;
                   end
                 else
                   dout<=data_in;
             end
           else
              dout<=header;
         end
       else
          dout<=dout; 
  end
end

//fifo_full_byte
always@(posedge clock)
begin
  if(!resetn)
    full_state_byte<=0;
  else 
  begin
     if(ld_state && fifo_full)
          full_state_byte<=data_in;
      else
         full_state_byte<=full_state_byte;
  end
end

//Header
always@(posedge clock)
begin
  if(!resetn)
    header<=0;
  else 
  begin
    if(detect_add && pkt_valid && (data_in[1:0]!=3))
        header<=data_in;
    else
        header<=header;
  end
end

//parity
always@(posedge clock)
begin
  if(!resetn)
     internal_parity<=0;
  else 
  begin
  if(detect_add)
      internal_parity<=0;
  else if(lfd_state)
      internal_parity<= internal_parity ^ header ;
  else
    if(ld_state && pkt_valid && ~full_state)
        internal_parity<= internal_parity ^data_in;
  //else 
  //      internal_parity<=internal_parity;
  end
end

//low_packet_valid
always@(posedge clock)
begin
  if(!resetn)
    low_packet_valid<=0;
  else 
  begin
    if(rst_int_reg)
        low_packet_valid<=1'b0;
    else if(ld_state && ~(pkt_valid))
        low_packet_valid<=1'b1;
    else 
        low_packet_valid <= low_packet_valid;
  end
end


//paritydone
always@(posedge clock)
begin
  if(!resetn)
    parity_done<=0;
  else
  begin
    if(detect_add)
    parity_done <= 0;
    else if( (ld_state && ~(pkt_valid) && ~fifo_full) || (laf_state && (low_packet_valid) && ~parity_done))
          parity_done<=1'b1;
    else
          parity_done<=parity_done;
  end
end

//packet parity
always@(posedge clock)
begin
  if(!resetn)
    packet_parity<=0;
  else if(ld_state && ~pkt_valid)
    packet_parity<=data_in;
  else
    packet_parity<=packet_parity;
end

//error          
always@(posedge clock)
begin
  if(~resetn)
    err <= 0;
  else
    begin  
      if(parity_done)
      begin
        if(internal_parity==packet_parity)
         err<=1'b0;
        else
          err<=1'b1;         
      end
      else
        err<=1'b0;
    end
end


endmodule


