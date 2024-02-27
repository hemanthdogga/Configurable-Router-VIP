module router_fifo(input clock,resetn,soft_reset,write_enb,read_enb,lfd_state,input [7:0] data_in,output full,empty,output reg [7:0] data_out);
	reg [8:0] mem[15:0];//16*9 fifo 
	reg [4:0]wr_ptr,rd_ptr;//read and write poniters
	reg [5:0]counter;//for payload lenght count track
	reg lfd;
	integer i;
	
	//lfd logic
	always@(posedge clock)
	begin
		if(!resetn)
			lfd<=0;
		else
			lfd<=lfd_state;
	end 
	
	//write logic 
	always@(posedge clock)
	begin
		if(!resetn)
		begin
			for(i=0;i<16;i=i+1)
			begin
				mem[i]<=0;
			end
		end
		else if (soft_reset)
		begin
			for(i=0;i<16;i=i+1)
			begin
				mem[i]<=0;
			end
		end		
		else
		begin 
			if(write_enb && !full)
				{mem[wr_ptr[3:0]][8],mem[wr_ptr[3:0]][7:0]}<={lfd,data_in};
		end
	end 
	
	//read logic
	always@(posedge clock)
	begin
		if(!resetn)
			data_out<=0;
		else if (soft_reset)
			data_out<=8'bz;
		else
		begin
			if(counter==0 && data_out!=0)//complete data read out 
				data_out<=8'bz;
			else if (read_enb && !empty)
				data_out<=mem[rd_ptr[3:0]];
		end
	end
	
	//write and read pointers logic
	always@(posedge clock)
	begin
		if(!resetn || soft_reset)
		begin
			wr_ptr<=0;
			rd_ptr<=0;
		end
		else
		begin
			if(read_enb && !empty)
				rd_ptr<=rd_ptr+1;
			if(write_enb && !full)
				wr_ptr<=wr_ptr+1;
		end
	end
	
	//counter logic
	always@(posedge clock)
	begin
		if(mem[rd_ptr[3:0]][8] && read_enb && !empty)
			counter<=mem[rd_ptr[3:0]][7:2]+1;
		else if (read_enb && !empty && counter!=0)
			counter<=counter-1;
			
	end
	
	//empty and full logic
	assign full = ((wr_ptr[4]!=rd_ptr[4])&&(wr_ptr[3:0]==rd_ptr[3:0]));
	assign empty = (wr_ptr==rd_ptr);
endmodule
