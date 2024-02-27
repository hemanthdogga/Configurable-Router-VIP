//sequencer







class dst_sequencer extends uvm_sequencer#(dst_xtns);


`uvm_component_utils(dst_sequencer)
virtual interface dst_if vif;
dst_agent_config m_dst_cfg;


function  new(string name ="dst_sequencer",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
assert(uvm_config_db#(dst_agent_config)::get(this,get_full_name(),"dst_agent_config",m_dst_cfg));
vif=m_dst_cfg.vif;
endfunction




endclass:dst_sequencer














