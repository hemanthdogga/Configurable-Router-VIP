//seq_item



class src_xtns extends uvm_sequence_item;


rand bit[1:0] addr;

rand bit[7:0] payload[];

rand bit[5:0] length;
 rand int  packet_delay;
typedef parity_type  parity_t;
rand parity_t parity_type;

bit [7:0]parity;





`uvm_object_utils_begin(src_xtns)
 `uvm_field_int(addr,UVM_ALL_ON)
`uvm_field_int(length,UVM_ALL_ON)
`uvm_field_array_int(payload,UVM_ALL_ON)
`uvm_field_int(packet_delay,UVM_ALL_ON)
`uvm_field_int(parity,UVM_ALL_ON)
`uvm_object_utils_end


function new(string name="src_xtns");
super.new(name);
endfunction

extern function void set_parity();

extern function bit[7:0]cal_parity();

extern function void post_randomize();

constraint valid_length{soft length inside {[34:35]};}
constraint payload_size{length==payload.size();}

constraint valid_length1{length!=0;}
constraint add_valid{addr inside {[0:2]};}
constraint delay{ soft packet_delay== 5;}
 constraint pct_type{parity_type inside  {GOOD_PARITY};}

//constraint valid_length{length inside {[10:20]};}




endclass

function void src_xtns::set_parity();
     if(parity_type==GOOD_PARITY)
             parity=cal_parity();
      else 
          parity=~parity;
endfunction


function void src_xtns::post_randomize();
    set_parity();


endfunction

function bit[7:0] src_xtns::cal_parity();
    cal_parity={length,addr};
  for(int i=0;i<length;i++)
     begin
        cal_parity^=payload[i];
     end

endfunction
