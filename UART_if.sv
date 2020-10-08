`ifndef UART_IF_H_
`define UART_IF_H_
interface UART_if(input clk);
logic tx_en;
logic rx_en;
logic reset;
logic tx;
logic rx;
logic [7:0]data_in;
logic [7:0]data_out;
logic parity_error;
logic stop_error;
logic data_ready;


modport driver (
input clk,
output tx_en,rx_en,reset,rx,data_in
);

modport monitor(
input tx_en,rx_en,reset,clk,tx,rx,data_in,data_out,parity_error,stop_error,data_ready
);

endinterface

`endif