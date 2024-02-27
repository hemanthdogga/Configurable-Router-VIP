class env_config extends uvm_object;


src_agent_config m_src_agent_config;

dst_agent_config m_dst_agent_config[];

int has_scoreboard=1;


int no_of_chann=3;


int has_virtual_sequencer=1;


int src_agent_coverage=1;

int dst_functional_coverage=1;

int src_agent=1;

int dst_agent=1;






`uvm_object_utils(env_config)


function new (string name="env_config");
super.new(name);
endfunction




endclass

