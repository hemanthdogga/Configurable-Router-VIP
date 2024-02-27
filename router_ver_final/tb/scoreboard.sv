
class scoreboard extends uvm_scoreboard;


`uvm_component_utils(scoreboard)

`uvm_analysis_imp_decl(_src)
`uvm_analysis_imp_decl(_channel0)
`uvm_analysis_imp_decl(_channel1)
`uvm_analysis_imp_decl(_channel2)

src_xtns  q_addr0[$];
src_xtns  q_addr1[$];
src_xtns  q_addr2[$];

src_xtns src_cov_data;
dst_xtns ch_cov_data;


int mismatch_ch1;
int mismatch_ch0;
int mismatch_ch2;


int match_ch0;
int match_ch1;
int match_ch2;







function bit comp_equal (input src_xtns yp, input dst_xtns cp);
      // returns first mismatch only
      if (yp.addr != cp.addr) begin
        `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
        return(0);
      end
      if (yp.length != cp.length) begin
        `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
        return(0);
      end
      foreach (yp.payload [i])
        if (yp.payload[i] != cp.payload[i]) begin
          `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
          return(0);
        end
      if (yp.parity != cp.parity) begin
        `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
        return(0);
      end
      return(1);
   endfunction



uvm_analysis_imp_src#(src_xtns,scoreboard) src_packet_in;

uvm_analysis_imp_channel0#(dst_xtns,scoreboard) chan0_packet_in;
uvm_analysis_imp_channel1#(dst_xtns,scoreboard) chan1_packet_in;
uvm_analysis_imp_channel2#(dst_xtns,scoreboard) chan2_packet_in;





covergroup router_fcov1;
option.per_instance=1;
ADDRESS:coverpoint src_cov_data.addr {
			bins addrs={2'b00,2'b01,2'b10};}
			//bins mid={2'b01};
			//bins high={2'b10};}
PAYLOAD_SIZE: coverpoint src_cov_data.length{
			bins small_packet={[1:15]};
			bins mid_packet={[16:30]};
			bins large_packet={[31:63]};}
//BAD_PKT: coverpoint write_cov_data.error{
//			bins bad_pkt={1};}

CHANNEL_X_PAYLOAD_SIZE: cross ADDRESS,PAYLOAD_SIZE;
endgroup


covergroup router_fcov2;
option.per_instance=1;
CHANNEL:coverpoint ch_cov_data.addr{
			bins low={2'b00,2'b10,2'b01};}
			//bins mid={2'b01};
			//bins high={2'b10};}
PAYLOAD_SIZE: coverpoint ch_cov_data.length{
			bins small_packet={[1:15]};
			bins mid_packet={[16:30]};
			bins large_packet={[31:63]};}
//BAD_PKT: coverpoint read_cov_data.error{
//			bins bad_pkt={1};}

CHANNEL_X_PAYLOAD_SIZE: cross CHANNEL,PAYLOAD_SIZE;
endgroup






function new(string name="scoreboard",uvm_component parent);
super.new(name,parent);
src_packet_in=new("src_packet_in",this);
chan0_packet_in=new("chan0_packet_in",this);

chan1_packet_in=new("chan1_packet_in",this);
chan2_packet_in=new("chan2_packet_in",this);

router_fcov1=new();
router_fcov2=new();
endfunction




function void write_src(src_xtns pkt);
src_xtns clone_pkt;
$cast(src_cov_data,pkt.clone());
router_fcov1.sample();

$cast(clone_pkt,pkt.clone);


case(clone_pkt.addr)
2'b00:q_addr0.push_back(clone_pkt);
2'b01:q_addr1.push_back(clone_pkt);
2'b10:q_addr2.push_back(clone_pkt);
endcase



endfunction

function void write_channel0(dst_xtns pkt);
src_xtns que_pkt=q_addr0.pop_front();
ch_cov_data=pkt;
if(!comp_equal(que_pkt,pkt))
begin
`uvm_error(get_type_name(),$sformatf("yaap_pkt0=\n%s,channel_packet0=\n%s",que_pkt.sprint(),pkt.sprint()))
mismatch_ch0++;
end
else
begin
router_fcov2.sample();
match_ch0++;
end
endfunction


function void write_channel1(dst_xtns pkt);
src_xtns que_pkt=q_addr1.pop_front();
dst_xtns ch_cov_data;
ch_cov_data=pkt;
if(!comp_equal(que_pkt,pkt))
begin
`uvm_error(get_type_name(),$sformatf("yaap_pkt1=\n%s,channel_packet1=\n%s",que_pkt.sprint(),pkt.sprint()))
mismatch_ch1++;
end
else
begin
router_fcov2.sample();
match_ch1++;
end
endfunction




function void write_channel2(dst_xtns pkt);
src_xtns que_pkt=q_addr2.pop_front();
dst_xtns ch_cov_data;
ch_cov_data=pkt;
if(!comp_equal(que_pkt,pkt))
begin
`uvm_error(get_type_name(),$sformatf("yaap_pkt2=\n%s,channel_packet2=\n%s",que_pkt.sprint(),pkt.sprint()))
mismatch_ch2++;
end
else
begin
router_fcov2.sample();
match_ch2++;
end
endfunction




function void report_phase(uvm_phase phase);
`uvm_info(get_type_name(),$sformatf("channe0->MISMATCH=%0d ->MATCH=%0d",mismatch_ch0,match_ch0),UVM_HIGH)
`uvm_info(get_type_name(),$sformatf("channe1->MISMATCH=%0d ->MATCH=%0d",mismatch_ch1,match_ch1),UVM_HIGH)
`uvm_info(get_type_name(),$sformatf("channe2->MISMATCH=%0d ->MATCH=%0d",mismatch_ch2,match_ch2),UVM_HIGH)
endfunction


endclass
