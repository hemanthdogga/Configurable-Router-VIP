
class router_simple_mcseq extends uvm_sequence#(uvm_sequence_item);

`uvm_object_utils(router_simple_mcseq)
`uvm_declare_p_sequencer(router_mcsequencer)

function new(string name="router_simple_mcseq");
super.new(name);
endfunction



small_packet_seq small_pkt;
med_packet_seq med_pkt;
lar_packet_seq lar_pkt;







task pre_body();

if(starting_phase!=null)
starting_phase.raise_objection(this,get_type_name());


endtask



task body();
repeat(40) begin
`uvm_do_on(small_pkt,p_sequencer.seqrh);

`uvm_do_on(med_pkt,p_sequencer.seqrh);
`uvm_do_on(lar_pkt,p_sequencer.seqrh);
end
endtask










task post_body();

if(starting_phase!=null)
starting_phase.drop_objection(this,get_type_name());


endtask






endclass
