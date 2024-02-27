module router_fsm (input clock,resetn,pkt_valid,input [1:0]data_in,input fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid,output write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

reg [2:0]state,next_state;
reg [1:0] int_addr_reg;

parameter DECODE_ADDRESS  =  3'b000,
          LOAD_FIRST_DATA =  3'b001,
          LOAD_DATA       =  3'b010,
          LOAD_PARITY     =  3'b011,
	  FIFO_FULL_STATE =  3'b100,
          LOAD_AFTER_FULL =  3'b101,
	  WAIT_TILL_EMPTY =  3'b110,
	  CHECK_PARITY_ERROR=3'b111;

//logic for storing address
always@(posedge clock)
begin
	if(!resetn ||  soft_reset_0 || soft_reset_1 || soft_reset_2 )
		int_addr_reg<=2'b00;
	else if(pkt_valid)
		int_addr_reg<=data_in;
end

always@(posedge clock)
 begin
  if(~resetn)
    state<=DECODE_ADDRESS;
  else if((soft_reset_0 && (data_in==2'd0))||(soft_reset_1 && (data_in==2'd1))||(soft_reset_2 && (data_in==2'd2)))
    state<=DECODE_ADDRESS;
  else
    state<=next_state;
 end

always@(*)
 begin
    case(state)
     DECODE_ADDRESS : begin
                       if((pkt_valid & (data_in[1:0]==0)& ~fifo_empty_0)|(pkt_valid & (data_in[1:0]==1)& ~fifo_empty_1)|(pkt_valid & (data_in[1:0]==2)& ~fifo_empty_2))
                            next_state=WAIT_TILL_EMPTY;
                       else if ((pkt_valid & (data_in[1:0]==0)& fifo_empty_0)|(pkt_valid & (data_in[1:0]==1)& fifo_empty_1)|(pkt_valid & (data_in[1:0]==2)& fifo_empty_2))
                            next_state=LOAD_FIRST_DATA;
		      else
			    next_state=DECODE_ADDRESS;
                      end
     LOAD_FIRST_DATA: next_state=LOAD_DATA;
     LOAD_DATA      : begin
                       if(~fifo_full&&~pkt_valid)
                            next_state=	LOAD_PARITY;
                       else if(fifo_full)
                            next_state=FIFO_FULL_STATE;
		       else 
			    next_state=LOAD_DATA;
                      end
     LOAD_PARITY    : next_state=CHECK_PARITY_ERROR; 
     FIFO_FULL_STATE: begin
                       if(~fifo_full)
                            next_state=LOAD_AFTER_FULL;
		       else
			     next_state=FIFO_FULL_STATE;
                      end
     LOAD_AFTER_FULL: begin
                        if(parity_done)
                            next_state=DECODE_ADDRESS;
                       else if(!parity_done & low_pkt_valid)
                               next_state=LOAD_PARITY;
                       else if(!parity_done & !low_pkt_valid)
                               next_state=LOAD_DATA;
		       else
			       next_state=LOAD_AFTER_FULL;                         
                      end
     WAIT_TILL_EMPTY: begin
	       	     if(~fifo_empty_0 | ~fifo_empty_1 | ~fifo_empty_2)
                            next_state=	WAIT_TILL_EMPTY;
                       else if (fifo_empty_0 | fifo_empty_1 | fifo_empty_2)
                            next_state= LOAD_FIRST_DATA;
		       else 
			    next_state=WAIT_TILL_EMPTY;
                      end
     CHECK_PARITY_ERROR : begin
                             if(~fifo_full)
                                 next_state= DECODE_ADDRESS;
                             else if(fifo_full)
                                 next_state=FIFO_FULL_STATE;
			     else 
 				 next_state=CHECK_PARITY_ERROR;
                          end
   endcase
 end

assign write_enb_reg= ((state==LOAD_DATA)|| (state==LOAD_PARITY)|| (state==LOAD_AFTER_FULL))? 1'b1:1'b0;

assign detect_add= (state==DECODE_ADDRESS)? 1'b1:1'b0;

assign ld_state= (state==LOAD_DATA)? 1'b1:1'b0;

assign laf_state= (state==LOAD_AFTER_FULL) ? 1'b1:1'b0;

assign lfd_state= (state==LOAD_FIRST_DATA)? 1'b1:1'b0;

assign full_state= (state==FIFO_FULL_STATE)? 1'b1:1'b0;

assign rst_int_reg= (state==CHECK_PARITY_ERROR)? 1'b1:1'b0;

assign busy=((state==LOAD_FIRST_DATA)|| (state==LOAD_PARITY)|| (state==FIFO_FULL_STATE)||(state==LOAD_AFTER_FULL)||(state==WAIT_TILL_EMPTY)||(state==CHECK_PARITY_ERROR))? 1'b1:1'b0;


endmodule
