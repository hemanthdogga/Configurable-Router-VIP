//dst_agent





class dst_agent extends uvm_agent;



`uvm_component_utils(dst_agent)

dst_driver driver;
dst_monitor monitor;
dst_sequencer seqrh;

dst_agent_config m_cfg;

function  new(string name ="dst_top",uvm_component parent);
super.new(name,parent);
endfunction








function void build_phase(uvm_phase phase);
super.build_phase(phase);
monitor=dst_monitor::type_id::create("monitor",this);
///  ACTIVE PASSIVE CONDITION

if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
if(m_cfg.is_active==UVM_ACTIVE)
begin
seqrh=dst_sequencer::type_id::create("seqrh",this);
driver=dst_driver::type_id::create("driver",this);
end
endfunction


function void connect_phase(uvm_phase phase);
if(m_cfg.is_active==UVM_ACTIVE)
   driver.seq_item_port.connect(seqrh.seq_item_export);
endfunction



endclass:dst_agent
