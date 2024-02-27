


















class src_seq_base extends uvm_sequence#(src_xtns);


`uvm_object_utils(src_seq_base)




function new(string name="src_seq_base");
super.new(name);
endfunction





task pre_body();

if(starting_phase!=null)
   starting_phase.raise_objection(this,get_type_name());

endtask



task post_body();

if(starting_phase!=null)
   starting_phase.drop_objection(this,get_type_name());
endtask


endclass



class small_packet_seq extends src_seq_base;



`uvm_object_utils(small_packet_seq)




function new(string name="small_packet_seq");
super.new(name);
endfunction



task body();



//   `uvm_do_with(req,{req.addr==2'b00;})

  // `uvm_do_with(req,{req.addr==2'b01;})
  // `uvm_do_with(req,{req.addr==2'b10;})

repeat(50)`uvm_do_with(req,{req.addr==2'b00;req.length inside{[1:10]};})


repeat(50) `uvm_do_with(req,{req.addr==2'b01;req.length<=10;})
repeat(50)  `uvm_do_with(req,{req.addr==2'b10;req.length<=10;})
endtask


endclass




class med_packet_seq extends src_seq_base;



`uvm_object_utils(med_packet_seq)




function new(string name="med_packet_seq");
super.new(name);
endfunction



task body();



//   `uvm_do_with(req,{req.addr==2'b00;})

  // `uvm_do_with(req,{req.addr==2'b01;})
  // `uvm_do_with(req,{req.addr==2'b10;})

repeat(50)`uvm_do_with(req,{req.addr==2'b00;req.length inside {[16:30]};})


repeat(50) `uvm_do_with(req,{req.addr==2'b01;req.length inside {[16:30]};})
repeat(50)  `uvm_do_with(req,{req.addr==2'b10;req.length inside {[16:30]};})
endtask


endclass



class lar_packet_seq extends src_seq_base;



`uvm_object_utils(lar_packet_seq)




function new(string name="lar_packet_seq");
super.new(name);
endfunction



task body();



//   `uvm_do_with(req,{req.addr==2'b00;})

  // `uvm_do_with(req,{req.addr==2'b01;})
  // `uvm_do_with(req,{req.addr==2'b10;})

repeat(50)`uvm_do_with(req,{req.addr==2'b00;req.length<=63;})


repeat(50) `uvm_do_with(req,{req.addr==2'b01;req.length<=63;})
repeat(50)  `uvm_do_with(req,{req.addr==2'b10;req.length<=63;})
endtask


endclass



