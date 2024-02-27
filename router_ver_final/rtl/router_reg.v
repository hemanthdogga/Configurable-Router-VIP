module router_reg(input clock,resetn,pkt_valid,input[7:0]data_in,input fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,output reg error,parity_done,low_packet_valid,output reg [7:0]dout);

reg [7:0]hold_header_byte,fifo_full_byte,internal_parity,packet_parity;

always@(posedge clock)
 begin
  parity_done<=0;
  if(ld_state&&~fifo_full&&~pkt_valid&&resetn&&~detect_add)
    parity_done<=1;
  else if(laf_state&&low_packet_valid&&~parity_done&&resetn&&~detect_add)
    parity_done<=1;
 end

always@(posedge clock)
 begin
  low_packet_valid<=0;
  if(ld_state&&~pkt_valid&&~rst_int_reg&&resetn)
   low_packet_valid<=1;
 end

always@(posedge clock)
 begin
  if(~resetn)
   dout<=0;
  else
   begin
     if(lfd_state)
       dout<=hold_header_byte;
     else if(ld_state&&~fifo_full)
       dout<=data_in;
     else if(laf_state)
       dout<=fifo_full_byte;
   end
 end

 always@(posedge clock)
begin
	if(!resetn)
	begin
		hold_header_byte<=0;
		fifo_full_byte<=0;
	end
	else 
	begin	if(detect_add && pkt_valid && data_in[1:0]!=2'b11) 
		hold_header_byte<=data_in;

		if(ld_state && fifo_full)
		fifo_full_byte<=data_in;
	end
end

always@(posedge clock)
begin
	if(~resetn || detect_add)
		internal_parity<=0;
	else if(lfd_state && pkt_valid && data_in[1:0]!=2'b11)
		internal_parity<=internal_parity^hold_header_byte;
	else if(ld_state && ~full_state && pkt_valid)
		internal_parity<=internal_parity^data_in;
	else 
		internal_parity<=internal_parity;
end

always@(posedge clock)
begin
	if(!resetn || detect_add)
		packet_parity<=0;
	else if((~fifo_full && ~pkt_valid && ld_state)||
		(laf_state && low_packet_valid && ~parity_done))
		packet_parity<=data_in;
	else 
		packet_parity<=packet_parity;
end

always@(posedge clock)
 begin
  error<=0;
  
    if(!resetn||detect_add)
     error<=0;
    else if(parity_done)
     begin
      if(internal_parity!=packet_parity)
         error<=1;
     end
 
 end

endmodule

