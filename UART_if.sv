`ifndef UART_IF_H_
`define UART_IF_H_
`timescale 1us / 1ns
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

clocking cb @(posedge clk);
default input #1 output #2 ;
inout tx_en,rx_en,reset,clk,tx,rx,data_in,data_out,parity_error,stop_error,data_ready;
endclocking

modport driver (clocking cb,
input  clk,
output tx_en,rx_en,reset,rx,data_in
);

modport monitor(clocking cb,
input tx_en,rx_en,reset,clk,tx,rx,data_in,data_out,parity_error,stop_error,data_ready
);

endinterface

`endif