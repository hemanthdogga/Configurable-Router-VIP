///dst_top








class dst_top extends uvm_env;



`uvm_component_utils(dst_top)

dst_agent agnth;

function  new(string name ="dst_top",uvm_component parent);
super.new(name,parent);
endfunction








function void build_phase(uvm_phase phase);
super.build_phase(phase);
agnth=dst_agent::type_id::create("agnth",this);
endfunction





endclass:dst_top
