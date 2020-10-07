`ifndef SCORE_BOARD_H_
`define SCORE_BOARD_H_
`include "frame.sv"

class scoreboard;
mailbox mbx_drv_scb;
mailbox mbx_mon_scb;


function new(mailbox mbx_drv_scb,mailbox mbx_mon_scb);
	this.mbx_drv_scb=mbx_drv_scb;
	this.mbx_mon_scb=mbx_mon_scb;
endfunction

task run();

	forever begin
		frame item_mon;
		frame item_ref;

		mbx_mon_scb.get(item_mon);		
		mbx_drv_scb.get(item_ref);
		item_ref.print("Scoreboard");

	if(item_mon.transaction_type!=item_ref.transaction_type)
		$display("T=%0t [Scoreboard ERROR!!]  TRANSACTION TYPE MISMATCH",$time);
	else
		$display("T=%0t [Scoreboard PASS!!]  TRANSACTION TYPE MATCH",$time);
	
	if(item_mon.data != item_ref.data)
		$display("T=%0t [Scoreboard ERROR!!]  DATA MISMATCH",$time);
	else
		$display("T=%0t [Scoreboard PASS!!]  DATA MATCH",$time);
	
	if(item_mon.parity!= item_ref.parity)
		$display("T=%0t [Scoreboard ERROR!!]  PARITY MISMATCH",$time);
	else 
		$display("T=%0t [Scoreboard PASS!!]  PARITY MATCH",$time);
	
	end

endtask

endclass


`endif
