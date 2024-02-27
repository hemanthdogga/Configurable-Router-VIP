











interface src_if(input bit clock, input logic reset_n);


logic read_enb;

logic [7:0] data_in;
logic pkt_valid;




logic busy;
logic error;






clocking sr_drv@(posedge clock);
default input #1ns output#1ns;
output data_in;
output pkt_valid;

input read_enb;
input busy;
input error;

endclocking


clocking sr_mon@(posedge clock);
default input #1ns output#1ns;
input  data_in;
input  pkt_valid;
input read_enb;
input busy;
input error;
endclocking






modport drv_mp(clocking sr_drv,input reset_n);

modport mon_mp(clocking sr_mon,input reset_n);



endinterface

