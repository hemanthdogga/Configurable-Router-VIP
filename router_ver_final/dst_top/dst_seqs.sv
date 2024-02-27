





class dst_seqs_base extends uvm_sequence#(dst_xtns);



`uvm_object_utils(dst_seqs_base)
//`uvm_declare_p_sequencer(dst_sequencer)
`uvm_declare_p_sequencer(dst_sequencer) 


function new(string name="src_seq_base");
super.new(name);
endfunction



endclass



class small_delay_seq extends dst_seqs_base;



`uvm_object_utils(small_delay_seq)




function new(string name="small_delay_seq");
super.new(name);
endfunction



task body();

`uvm_create(req)
forever begin
@(posedge p_sequencer.vif.clock iff(p_sequencer.vif.valid_out==1));
   `uvm_rand_send_with(req,{req.no_of_clocks==5;})
end

endtask


endclass
