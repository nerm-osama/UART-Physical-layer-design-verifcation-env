`timescale 1us / 1ns
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
module top_test;

reg clk;
UART_if inf(clk);
mailbox    mbx_gen_drv;
mailbox    mbx_mon_scb;
mailbox    mbx_drv_scb;
generator  gen;
driver 	   drv;
monitor    mon;
scoreboard scb;

UART u1(.tx_en		(inf.tx_en),
	.rx_en		(inf.rx_en),
	.reset		(inf.reset),
	.clock		(inf.clk),
	.tx		(inf.tx),
	.rx		(inf.rx),
	.data_in	(inf.data_in),
	.data_out	(inf.data_out),
	.parity_error	(inf.parity_error),
	.stop_error	(inf.stop_error),
	.data_ready	(inf.data_ready)
	);

initial begin

	mbx_gen_drv = new();	
	mbx_mon_scb = new();
	mbx_drv_scb = new();

	gen = new(mbx_gen_drv,10);	
	drv = new(mbx_gen_drv,mbx_drv_scb,inf.driver);
	mon = new(mbx_mon_scb,inf.monitor);
	scb = new(mbx_drv_scb,mbx_mon_scb);

	fork
		gen.run();
		drv.run();
		mon.run();
		scb.run();
	join_none

end

initial clk=0; 

always #2.5 clk=~clk;

endmodule
