//sequencer







class src_sequencer extends uvm_sequencer#(src_xtns);


`uvm_component_utils(src_sequencer)




function  new(string name ="src_sequencer",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction




endclass:src_sequencer














