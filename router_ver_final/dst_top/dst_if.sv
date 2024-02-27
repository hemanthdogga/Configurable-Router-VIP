










interface dst_if(input logic  clock,input logic  reset_n);

logic [7:0]data_out;

logic valid_out;

logic busy;

logic read_enb;


clocking ch_drv@(posedge clock);
default input #1 output#1;
input valid_out;
output read_enb;
endclocking


clocking ch_mon@(posedge clock);
default input #1 output #1;
input data_out;
input read_enb;
input busy;
input valid_out;
endclocking 

modport drv_mp(clocking ch_drv,input reset_n);
modport mon_mp(clocking ch_mon,input reset_n);

endinterface
