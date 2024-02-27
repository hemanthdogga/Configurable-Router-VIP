




class src_agent_config extends uvm_object;



`uvm_object_utils(src_agent_config)


virtual interface  src_if vif;

function new(string name="src_agent_config");
super.new(name);
endfunction




uvm_active_passive_enum is_active=UVM_ACTIVE;



endclass
