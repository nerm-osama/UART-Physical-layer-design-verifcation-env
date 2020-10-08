`timescale 1us / 1ns
`ifndef DRIVER_H_
`define DRIVER_H_
`include "UART_if.sv"
`include "frame.sv"

class driver ;
virtual UART_if.driver uart_if;
mailbox mailbox_generator_driver;
mailbox mailbox_scoreboard_driver;

function new(mailbox _mailbox_generator_driver,mailbox mailbox_scoreboard_driver,virtual UART_if.driver _uart_if);
	this.mailbox_generator_driver=_mailbox_generator_driver;
	this.mailbox_scoreboard_driver=mailbox_scoreboard_driver;
	this.uart_if=_uart_if;
endfunction 

task run();
	$display ("T=%0t [Driver] starting .... ",$time);

	uart_if.cb.reset=0;
	repeat(5) @(posedge uart_if.clk);
	uart_if.cb.reset=1;
	uart_if.cb.rx=1;
	
	forever begin

		frame item;
		mailbox_generator_driver.get(item);
		mailbox_scoreboard_driver.put(item);
		item.print("Driver");
		
		@(posedge uart_if.clk);
		
		if(item.transaction_type==transmit)begin
			uart_if.cb.tx_en<=1;
			uart_if.cb.data_in<=item.data;
			@(posedge uart_if.clk);
			uart_if.cb.tx_en<=0;
			uart_if.cb.data_in<=8'b0;
			repeat(240)@(posedge uart_if.clk);
		end
		
		else if(item.transaction_type==recieve)begin
			uart_if.cb.rx_en<=1;
			uart_if.cb.rx<=0;	//start bit
			
			for(int i=0;i<8;i++)begin
				repeat(20)@(posedge uart_if.clk);
				uart_if.cb.rx<=item.data[i];
			end

			repeat(20)@(posedge uart_if.clk);
			uart_if.cb.rx<=item.parity; 

			repeat(20)@(posedge uart_if.clk);
			uart_if.cb.rx<=1;	//stop bit
			uart_if.cb.rx_en<=0;
			repeat(20)@(posedge uart_if.clk);	
		end
	end


endtask
endclass
`endif