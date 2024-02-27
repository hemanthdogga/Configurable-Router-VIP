//seq_item



class dst_xtns extends uvm_sequence_item;


 bit[1:0] addr;

 bit[7:0] payload[];

 bit[5:0] length;


bit [7:0] parity;

bit read_enable;
bit vld_out;

rand int no_of_clocks;





`uvm_object_utils_begin(dst_xtns)
 `uvm_field_int(addr,UVM_ALL_ON)
`uvm_field_int(length,UVM_ALL_ON)
`uvm_field_array_int(payload,UVM_ALL_ON)
`uvm_field_int(parity,UVM_ALL_ON)
`uvm_field_int(no_of_clocks,UVM_ALL_ON)
`uvm_object_utils_end


function new(string name="dst_xtns");
super.new(name);
endfunction



endclass
