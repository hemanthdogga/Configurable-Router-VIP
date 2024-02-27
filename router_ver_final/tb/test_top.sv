





class router_test_base extends uvm_test;

`uvm_component_utils(router_test_base);
virtual  src_if vif;
src_agent_config m_sr_cfg;
dst_agent_config m_dt_cfg[];
router_tb router;




env_config env_cfg;
int no_of_chann=3;

int src_agent=1;
int dst_agent=1;

router_simple_mcseq vseq;






function new(string name="router_test_base",uvm_component parent);
super.new(name,parent);
endfunction




function void config_router();
uvm_config_db#(virtual src_if)::get(this,"","vif",vif);
if(src_agent)
begin
m_sr_cfg=src_agent_config::type_id::create("m_sr_cfg");
m_sr_cfg.is_active=UVM_ACTIVE;
m_sr_cfg.vif=vif;
env_cfg.m_src_agent_config=m_sr_cfg;
env_cfg.src_agent=src_agent;
end

if(dst_agent)
begin
m_dt_cfg=new[no_of_chann];
env_cfg.m_dst_agent_config=new[no_of_chann];

//config channels
foreach(m_dt_cfg[i])
begin
m_dt_cfg[i]=dst_agent_config::type_id::create($sformatf("m_dt_cfg[%0d]",i));
m_dt_cfg[i].is_active=UVM_ACTIVE;

assert(uvm_config_db#(virtual dst_if)::get(this,"",$sformatf("vif[%0d]",i),m_dt_cfg[i].vif));
env_cfg.m_dst_agent_config[i]=m_dt_cfg[i];
end
env_cfg.dst_agent=dst_agent;
env_cfg.no_of_chann=no_of_chann;

end



//m_dt_cfg.vif=vif;
/*
uvm_config_db#(src_agent_config)::set(this,"*","src_agent_config",m_sr_cfg);
foreach(m_dt_cfg[i])begin
uvm_config_db#(dst_agent_config)::set(this,{"*",$sformatf("dst[%0d]",i),"*"},"dst_agent_config",m_dt_cfg[i]);
//uvm_config_db#(dst_agent_config)::set(this,"*","dst_agent_config",m_dt_cfg);

uvm_config_db#(virtual dst_if)::set(this,{"*",$sformatf("dst[%0d]",i),"*"},"dst_agent_config",m_dt_cfg[i].vif);
end
*/

uvm_config_db#(env_config)::set(this,"router","env_config",env_cfg);

uvm_config_wrapper::set(this,"router.dst[?].agnth.seqrh.run_phase","default_sequence",small_delay_seq::get_type());



//uvm_config_wrapper::set(this,"router.dst[1].agnth.seqrh.run_phase","default_sequence",small_delay_seq::get_type());
//uvm_config_wrapper::set(this,"router.dst[2].agnth.seqrh.run_phase","default_sequence",small_delay_seq::get_type());
endfunction



function void build_phase(uvm_phase phase);
env_cfg=env_config::type_id::create("env_cfg");
config_router();
super.build_phase(phase);
router=router_tb::type_id::create("router",this);
endfunction
function void start_of_simulation_phase(uvm_phase phase);
uvm_top.print_topology();
endfunction

virtual task run_phase(uvm_phase phase);
uvm_objection obj=phase.get_objection();
///uvm_config_wrapper::set(this,"router.src.agnth.seqrh.run_phase","default_sequence",small_packet_seq::get_type());
phase.raise_objection(this);
vseq=router_simple_mcseq::type_id::create("vseq");
vseq.start(router.vir_seqrh);
phase.drop_objection(this);
obj.set_drain_time(this,50000ns);
endtask


endclass
