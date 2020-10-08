`ifndef GENERATOR_H_
`define GENERATOR_H_
`include "frame.sv"
`timescale 1us / 1ns
class generator;
integer loop=10;
mailbox mailbox_generator_diver;

function new(mailbox _mailbox_generator_diver,integer _loop);
	this.mailbox_generator_diver=_mailbox_generator_diver;
	this.loop=_loop;
endfunction

task run();
	for(int i=0 ;i<loop;i++) begin
		
		frame item=new;
		assert(item.randomize());
		$display("T=%0t [Generator] loop %0d/%0d create new item ",$time,i+1,loop);
		item.print("generator");
		mailbox_generator_diver.put(item);
	end	
endtask
endclass
`endif

