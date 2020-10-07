`ifndef FRAME_H_
`define FRAME_H_
`include"macros.sv" 
class frame;
rand bit [7:0] data;
rand bit parity;
rand transaction transaction_type;



constraint transmit_recieve_const  { 
	transaction_type dist {transmit:=5 ,recieve:=5};
};

constraint parity_on_transmit_const{ 
	transaction_type == transmit -> parity == ^ data[7:0];
};

function void print(string source="");
	$display("T=%0t %s data=0x%0h parity=%d transaction=%s",$time,source,data,parity,transaction_type.name); 
endfunction 

endclass
`endif