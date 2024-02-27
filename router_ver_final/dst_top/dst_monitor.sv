//monitor







class dst_monitor extends uvm_monitor;


`uvm_component_utils(dst_monitor)

dst_xtns req;

virtual interface dst_if.mon_mp vif;
dst_agent_config m_cfg;
int no_of_recv_trans;

uvm_analysis_port#(dst_xtns)dst_port;

int channel_id;
string str_inst;


function  new(string name ="dst_monitor",uvm_component parent);
super.new(name,parent);
dst_port=new("dst_port",this);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(dst_agent_config)::get(this,"","dst_agent_config",m_cfg))
`uvm_fatal(get_type_name(),"NOT RECEIVED INTERFACE")
uvm_config_int::get(this,"","channel",channel_id);
case(channel_id)
   0:str_inst="channel0";
   1:str_inst="channel1";
   2:str_inst="channel2";
endcase
endfunction

function void connect_phase(uvm_phase phase);
vif=m_cfg.vif;
endfunction





task run_phase(uvm_phase phase);


@(negedge vif.reset_n);

@(posedge vif.reset_n);

 `uvm_info(get_type_name(),"INSIDE MON CH after reset",UVM_HIGH)
forever 
  begin
  req=dst_xtns::type_id::create("req");
     
@(vif.ch_mon iff ((vif.ch_mon.valid_out==1) && (vif.ch_mon.read_enb==1)));
//repeat(4) 
 //@(vif.ch_mon);

// @(vif.ch_mon);
//@(vif.ch_mon iff (vif.ch_mon.valid_out==1));
 `uvm_info(get_type_name(),$sformatf("channel=%0s",str_inst),UVM_HIGH)
 `uvm_info(get_type_name(),$sformatf("valid_out=%0d",vif.ch_mon.valid_out),UVM_HIGH)
 `uvm_info(get_type_name(),$sformatf("read_enb=%0d",vif.ch_mon.read_enb),UVM_HIGH)
 @(vif.ch_mon  iff vif.ch_mon.read_enb);
 `uvm_info(get_type_name(),"INSIDE h BEFORE DATA",UVM_HIGH)
// {req.length,req.addr}=vif.ch_mon.data_out;
    
   req.addr=vif.ch_mon.data_out[1:0];
   if(req.addr!=channel_id)
        `uvm_error(get_type_name(),$sformatf("CHANNEL ADDR ERROR RECV=%0d Expect=%0d",req.addr,channel_id))
   req.length=vif.ch_mon.data_out[7:2];
 req.payload=new[req.length];
         for(int i=0;i<req.length;i++)
           begin
      @(vif.ch_mon iff (vif.ch_mon.read_enb));
                         
 //@(vif.ch_mon  iff vif.ch_mon.read_enb && (!vif.ch_mon.busy));
               req.payload[i]=vif.ch_mon.data_out;
           end
        @(vif.ch_mon iff (vif.ch_mon.read_enb));
// @(vif.ch_mon  iff vif.ch_mon.read_enb && (!vif.ch_mon.busy));
             req.parity=vif.ch_mon.data_out;
  dst_port.write(req); 
no_of_recv_trans++;
     `uvm_info(get_type_name(),$sformatf("pkt RECV:\n%s",req.sprint()),UVM_HIGH)
 
@(vif.ch_mon iff ((vif.ch_mon.valid_out==0) && (vif.ch_mon.read_enb==0)));
end

endtask


function void report_phase(uvm_phase phase);

 `uvm_info(get_type_name(),{str_inst,$sformatf("NO OF TRANS RECV_YAPP:%0d",no_of_recv_trans)},UVM_HIGH)
endfunction
endclass:dst_monitor
