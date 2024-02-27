//driver









class src_driver extends uvm_driver#(src_xtns);


`uvm_component_utils(src_driver)
virtual interface src_if.drv_mp vif;
int no_of_sent_trans;
src_agent_config m_cfg;


function  new(string name ="src_driver",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
//m_cfg=src_agent_config::type_id::create("m_cfg"); 

assert(uvm_config_db#(src_agent_config)::get(this,"","src_agent_config",m_cfg));
//`uvm_fatal(get_type_name(),"NOT RECEIVED INTERFACE")
endfunction


function void connect_phase(uvm_phase phase);
vif=m_cfg.vif;
endfunction


task run_phase(uvm_phase phase);

@(negedge vif.reset_n);

@(posedge vif.reset_n);


forever begin
seq_item_port.get_next_item(req);
@(vif.sr_drv iff (!vif.sr_drv.busy));
       vif.sr_drv.pkt_valid<=1;
        vif.sr_drv.data_in[1:0]<=req.addr;
        
        vif.sr_drv.data_in[7:2]<=req.length;
         
         for(int i=0;i<req.length;i++)
           begin
            @(vif.sr_drv iff !(vif.sr_drv.busy));
                         
                vif.sr_drv.data_in<=req.payload[i];
           end
       @(vif.sr_drv iff(!vif.sr_drv.busy));
       vif.sr_drv.pkt_valid<=0;
             vif.sr_drv.data_in<=req.parity;
        no_of_sent_trans++;
 seq_item_port.item_done();
      repeat(req.packet_delay)
             @(vif.sr_drv);
     `uvm_info(get_type_name(),$sformatf("pkt sent:\n%s",req.sprint()),UVM_HIGH)
   end

endtask


function void report_phase(uvm_phase phase);

 `uvm_info(get_type_name(),$sformatf("NO OF TRANS sent:%0d",no_of_sent_trans),UVM_HIGH)
endfunction


endclass:src_driver
