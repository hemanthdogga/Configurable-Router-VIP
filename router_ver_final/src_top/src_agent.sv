//src_agent





class src_agent extends uvm_agent;



`uvm_component_utils(src_agent)

src_driver driver;
src_monitor monitor;
src_sequencer seqrh;


src_agent_config m_cfg;







function  new(string name ="src_top",uvm_component parent);
super.new(name,parent);
endfunction



function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

m_cfg=src_agent_config::type_id::create("m_cfg"); 
monitor=src_monitor::type_id::create("monitor",this);
///  ACTIVE PASSIVE CONDITION
if(m_cfg.is_active==UVM_ACTIVE)
begin
seqrh=src_sequencer::type_id::create("seqrh",this);
driver=src_driver::type_id::create("driver",this);
end
endfunction

function void connect_phase(uvm_phase phase);
if(m_cfg.is_active==UVM_ACTIVE)
   driver.seq_item_port.connect(seqrh.seq_item_export);
endfunction



endclass:src_agent
