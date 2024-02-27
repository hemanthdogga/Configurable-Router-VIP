   


module top;
import uvm_pkg::*;
`include "uvm_macros.svh"

import router_test_pkg::*;

bit clock=0;
logic  reset;


initial begin

clock=0;

forever #5 clock=~clock;

end
initial begin
//reset<=1;
 @(posedge clock);
     reset<=0;

 @(posedge clock);

    reset<=1;
end
//router_if in0(clock,reset);


src_if in0(clock,reset);
dst_if ch0(clock,reset); 
dst_if ch1(clock,reset); 
dst_if ch2(clock,reset); 
 
router_top dut1(.data_in(in0.data_in),.pkt_valid(in0.pkt_valid),.clock(clock),.resetn(reset)
,.read_enb_0(ch0.read_enb),.read_enb_1(ch1.read_enb),.read_enb_2(ch2.read_enb),
.data_out_0(ch0.data_out),.data_out_1(ch1.data_out),.data_out_2(ch2.data_out),
.vld_out_0(ch0.valid_out),.vld_out_1(ch1.valid_out),.vld_out_2(ch2.valid_out),
.err(),.busy(in0.busy));

/*router_top dut (.clock(clock),.resetn(reset),.read_enb_0(ch0.read_enb),.read_enb_1(ch1.read_enb),
.read_enb_2(ch2.read_enb),.data_in(in0.data_in),
.pkt_valid(in0.pkt_valid),
.data_out_0(ch0.data_out),.data_out_1(ch1.data_out),.data_out_2(ch2.data_out),
.valid_out_0(ch0.valid_out),.valid_out_1(ch1.valid_out),.valid_out_2(ch2.valid_out),
.error(),.busy(in0.busy));
*/   

initial begin
uvm_config_db#(virtual dst_if)::set(null,"uvm_test_top","vif[0]",ch0);
uvm_config_db#(virtual dst_if)::set(null,"uvm_test_top","vif[1]",ch1);
uvm_config_db#(virtual dst_if)::set(null,"uvm_test_top","vif[2]",ch2);
uvm_config_db#(virtual src_if)::set(null,"uvm_test_top","vif",in0);
run_test();

end

endmodule 







