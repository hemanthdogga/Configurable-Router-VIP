///src_top








class src_top extends uvm_env;



`uvm_component_utils(src_top)

src_agent agnth;

function  new(string name ="src_top",uvm_component parent);
super.new(name,parent);
endfunction








function void build_phase(uvm_phase phase);
super.build_phase(phase);
agnth=src_agent::type_id::create("agnth",this);
endfunction





endclass:src_top
