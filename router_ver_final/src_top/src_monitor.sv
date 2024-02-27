//monitor







class src_monitor extends uvm_monitor;


`uvm_component_utils(src_monitor)

src_xtns req;
virtual interface src_if.mon_mp vif;
src_agent_config m_cfg;
int no_of_recv_trans;
uvm_analysis_port#(src_xtns)src_port;
function  new(string name ="src_monitor",uvm_component parent);
super.new(name,parent);
src_port=new("src_port",this);
endfunction



function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(src_agent_config)::get(this,"","src_agent_config",m_cfg))
`uvm_fatal(get_type_name(),"NOT RECEIVED INTERFACE")

//m_cfg=src_agent_config::type_id::create("m_cfg"); 
endfunction



function void connect_phase(uvm_phase phase);
vif=m_cfg.vif;
endfunction



task run_phase(uvm_phase phase);


@(negedge vif.reset_n);

@(posedge vif.reset_n);

forever
  begin
  req=src_xtns::type_id::create("req");
       @(vif.sr_mon iff ((!vif.sr_mon.busy) && (vif.sr_mon.pkt_valid)));
   req.addr=vif.sr_mon.data_in[1:0];
   req.length=vif.sr_mon.data_in[7:2];
  req.payload=new[req.length];
         for(int i=0;i<req.length;i++)
           begin
            @(vif.sr_mon iff !(vif.sr_mon.busy));
                         
               req.payload[i]=vif.sr_mon.data_in;
           end
       @(vif.sr_mon);
       @(vif.sr_mon iff ((!vif.sr_mon.busy) && (!vif.sr_mon.pkt_valid)));
             req.parity=vif.sr_mon.data_in;
src_port.write(req); 
no_of_recv_trans++;
   if(req.parity==req.cal_parity())
     req.parity_type=GOOD_PARITY;
     else
     req.parity_type=BAD_PARITY; 
     `uvm_info(get_type_name(),$sformatf("pkt RECV:\n%s",req.sprint()),UVM_HIGH)
 
end

endtask


function void report_phase(uvm_phase phase);

 `uvm_info(get_type_name(),$sformatf("NO OF TRANS RECV_YAPP:%0d",no_of_recv_trans),UVM_HIGH)
endfunction

endclass:src_monitor
