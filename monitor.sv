`ifndef MONITOR_H_
`define MONITOR_H_
`include "UART_if.sv"
`include "frame.sv"
class monitor;
virtual UART_if.monitor uart_if;
mailbox mbx_monitor_scoreboard;

function new(mailbox mbx_monitor_scoreboard,virtual UART_if.monitor uart_if);
	this.mbx_monitor_scoreboard=mbx_monitor_scoreboard;
	this.uart_if=uart_if;
endfunction

task run();
$display("T=%0t [Monitor] starting .... ",$time);
forever begin 
	@(posedge uart_if.clk);
	if(uart_if.cb.data_ready) begin
	
		frame item1 =new();
		item1.transaction_type=recieve;	

		item1.data =uart_if.cb.data_out; 
		if(uart_if.cb.parity_error)
			item1.parity=~^uart_if.cb.data_out;
		else 
			item1.parity=^uart_if.cb.data_out;
		
		mbx_monitor_scoreboard.put(item1);
		item1.print("Monitor");
	end

	if(uart_if.cb.tx_en) begin
		frame item2 =new();
		item2.transaction_type=transmit;
	
		repeat(10)@(posedge uart_if.clk);

		for(int i=0;i<8;i++)begin
			repeat(20)@(posedge uart_if.clk);
			item2.data[i]=uart_if.cb.tx;
		end

		repeat(20)@(posedge uart_if.clk);
		item2.parity=uart_if.cb.tx;
	
		mbx_monitor_scoreboard.put(item2);
		item2.print("Monitor");
	end

	
	
	
	

end 

endtask


endclass



`endif
