






class router_mcsequencer extends uvm_sequencer;

`uvm_component_utils(router_mcsequencer)


src_sequencer seqrh;

function new (string name ="router_mcsequencer",uvm_component parent);
super.new(name,parent);
endfunction

endclass

