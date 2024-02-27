module router_sync (input clock,resetn,input [1:0]data_in,input detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,output reg [2:0]write_enb,output reg fifo_full,output vld_out_0,vld_out_1,vld_out_2,output reg soft_reset_0,soft_reset_1,soft_reset_2 );

reg [4:0]counter_0,counter_1,counter_2;
reg [1:0]addr;

always@(posedge clock)
 begin
  if(detect_add)
    addr<=data_in;
 end

always@(*)
 begin
 if(~resetn)
  fifo_full=0;
 else
  begin
	  fifo_full=0;
    case(addr)
     2'b00: fifo_full<=full_0;
     2'b01: fifo_full<=full_1;
     2'b10: fifo_full<=full_2;
    endcase 
  end
 end

assign vld_out_0= ~empty_0;

assign vld_out_1= ~empty_1;

assign vld_out_2= ~empty_2;

always@(*)
 begin
 if(~resetn)
  write_enb=0;
 else
  begin
  write_enb =3'b0;
  if(write_enb_reg)
   begin  
    case(addr)
     2'b00: write_enb=3'b001;
     2'b01: write_enb=3'b010;
     2'b10: write_enb=3'b100;
    endcase
   end
 end
end  

/*always@(posedge clock)
begin
	if(~resetn)
		begin
		counter_0<=0;
		soft_reset_0<=0;
		end
		else begin
			if(vld_out_0)
	                        	begin:X
			                if(~read_enb_0)
				                    begin:Y		
				                  if(counter_0==5'd29)
				                begin:Z
					          soft_reset_0<=1'b1;
			               		  counter_0<=0;
				                end:Z
				               else
				                 begin:T
					        soft_reset_0<=0;
				              	counter_0<=counter_0+1;
				                end:T
				              end:Y
		end
end*/



always@(posedge clock)
begin
if(!resetn)
begin
counter_0 <=0;
soft_reset_0 <=0;

end

else

begin

if(vld_out_0==1)

begin
case(read_enb_0)
1'b0: begin
      if(counter_0!=29)
      counter_0<=counter_0+1;
      else
      soft_reset_0<=1;
      end
default:counter_0<=0;
endcase

end
end

end


/*always@(posedge clock)
begin
	if(~resetn)
		begin
		counter_1<=0;
		soft_reset_1<=0;
		end
	else if(vld_out_1)
		begin
			if(~read_enb_1)
				begin		
				if(counter_1==5'd29)
				    begin
					soft_reset_1<=1'b1;
					counter_1<=0;
				    end
				else
				    begin
					soft_reset_1<=0;
					counter_1<=counter_1+1;
				    end
				end
		end
end*/



always@(posedge clock)
begin
if(!resetn)
begin
counter_1 <=0;
soft_reset_1 <=0;

end

else

begin

if(vld_out_1==1)

begin
case(read_enb_1)
1'b0: begin
      if(counter_1!=29)
      counter_1<=counter_1+1;
      else
      soft_reset_1<=1;
      end
default:counter_1<=0;
endcase

end
end

end














/*always@(posedge clock)
begin
	if(~resetn)
		begin
		counter_2<=0;
		soft_reset_2<=0;
		end
	else if(vld_out_2)
		begin
			if(~read_enb_2)
				begin		
				if(counter_2==5'd29)
				    begin
					soft_reset_2<=1'b1;
					counter_2<=0;
				    end
				else
				    begin
					soft_reset_2<=0;
					counter_2<=counter_2+1;
				    end
				end
		end
end
*/

always@(posedge clock)
begin
if(!resetn)
begin
counter_2 <=0;
soft_reset_2 <=0;

end

else

begin

if(vld_out_2==1)

begin
case(read_enb_2)
1'b0: begin
      if(counter_2!=29)
      counter_2<=counter_2+1;
      else
      soft_reset_2<=1;
      end
default:counter_2<=0;
endcase

end
end

end
endmodule


