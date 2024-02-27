//driver









class dst_driver extends uvm_driver#(dst_xtns);


`uvm_component_utils(dst_driver)

virtual interface dst_if.drv_mp vif;
dst_agent_config  env_cfg;
int channel_id;
string str_inst;

function  new(string name ="dst_driver",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
assert(uvm_config_db#(dst_agent_config)::get(this,"","dst_agent_config",env_cfg));
uvm_config_int::get(this,"","channel",channel_id);
case(channel_id)
   0:str_inst="channel0";
   1:str_inst="channel1";
   2:str_inst="channel2";
endcase
endfunction

function void connect_phase(uvm_phase phase);
vif=env_cfg.vif;
endfunction


task run_phase(uvm_phase phase);

 `uvm_info(get_type_name(),"INSIDE DRV CH",UVM_HIGH)
@(negedge vif.reset_n);

vif.ch_drv.read_enb<=0;
@(posedge vif.reset_n);

 `uvm_info(get_type_name(),"INSIDE DRV CH after reset",UVM_HIGH)
forever begin
seq_item_port.get_next_item(req);
@(vif.ch_drv iff (vif.ch_drv.valid_out==1));

 `uvm_info(get_type_name(),$sformatf("valid=%0b",vif.ch_drv.valid_out),UVM_HIGH)
repeat(req.no_of_clocks)
begin
vif.ch_drv.read_enb<=0;
//@(vif.ch_drv);
end
@(vif.ch_drv);
vif.ch_drv.read_enb<=1;

 //`uvm_info(get_type_name(),$sformatf("read_enb=%0b",vif.ch_drv.read_enb),UVM_HIGH)
//@(vif.ch_drv);
//@(vif.ch_drv);
@(vif.ch_drv iff (vif.ch_drv.valid_out==0));
vif.ch_drv.read_enb<=0;

 `uvm_info(get_type_name(),$sformatf("valid=%0b",vif.ch_drv.valid_out),UVM_HIGH)

@(vif.ch_drv);
//@(vif.ch_drv);
seq_item_port.item_done();
end

endtask




endclass:dst_driver
