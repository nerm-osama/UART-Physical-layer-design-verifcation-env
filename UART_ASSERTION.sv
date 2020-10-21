module UART_ASSERTION
(
input tx_en,rx_en,reset,clock,rx,
input [7:0] data_in, [7:0] data_out, 
input tx ,parity_error,stop_error,data_ready
);


property TX_assert;
logic [7:0] data_tx;
byte i =0;
@(posedge clock)(tx_en,data_tx=data_in,$display(" data_tx =%0b ",data_tx)) ##10 ~tx |-> (##20(tx==data_tx[i],i=i+1))[*8];
endproperty 

property RX_assert;
logic [7:0] data_rx;
byte i=0;
@(posedge clock) (rx_en ##10 ~rx ) |-> (##20(1,data_rx[i]=rx,i=i+1))[*8] ##20 (data_rx==data_out);
endproperty


ERROR_RECIEVE: assert property (RX_assert)$display("------------------RECIVE ASSERTION SUCCESS");
EEROR_TRANSMITION: assert property (TX_assert)$display("------------------TRANSMIT ASSERTION SUCCESS");

endmodule
