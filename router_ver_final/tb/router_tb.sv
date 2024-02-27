










class router_tb extends uvm_env;


`uvm_component_utils(router_tb)

src_agent_config m_src_agent_config;
dst_agent_config m_dst_agent_config[];

src_top src;
env_config env_cfg;
dst_top dst[];
scoreboard sb;

int channel_id;

router_mcsequencer vir_seqrh;



function new(string name="router_tb",uvm_component parent);
super.new(name,parent);
endfunction


function void config_src_channel();
uvm_config_db#(src_agent_config)::set(this,"*","src_agent_config",env_cfg.m_src_agent_config);

dst=new[env_cfg.no_of_chann];

foreach(dst[i])begin
uvm_config_db#(dst_agent_config)::set(this,{"*",$sformatf("dst[%0d]",i),"*"},"dst_agent_config",env_cfg.m_dst_agent_config[i]);
uvm_config_int::set(this,$sformatf("dst[%0d]*",i),"channel",i);
dst[i]=dst_top::type_id::create($sformatf("dst[%0d]",i),this);
end

endfunction


function void build_phase(uvm_phase phase);
assert(uvm_config_db#(env_config)::get(this,"","env_config",env_cfg));
config_src_channel();

super.build_phase(phase);
src=src_top::type_id::create("src",this);
sb=scoreboard::type_id::create("sb",this);
vir_seqrh=router_mcsequencer::type_id::create("vir_seqrh",this);
endfunction




function void connect_phase(uvm_phase phase);
vir_seqrh.seqrh=src.agnth.seqrh;
src.agnth.monitor.src_port.connect(sb.src_packet_in);
dst[0].agnth.monitor.dst_port.connect(sb.chan0_packet_in);
dst[1].agnth.monitor.dst_port.connect(sb.chan1_packet_in);
dst[2].agnth.monitor.dst_port.connect(sb.chan2_packet_in);
endfunction
















endclass
