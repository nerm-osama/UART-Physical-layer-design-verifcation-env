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

clocking cb @(posedge clk);
default input #2 output #2;
endclocking

modport driver (clocking cb,
input clk,
output tx_en,rx_en,reset,rx,data_in
);

modport monitor(clocking cb,
input tx_en,rx_en,reset,clk,tx,rx,data_in,data_out,parity_error,stop_error,data_ready
);

endinterface

`endif