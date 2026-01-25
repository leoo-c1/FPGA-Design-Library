module uart_echo (
    input        clk,      // PIN_23 (50MHz)
    input        rst,     // PIN_88 (KEY1 - Reset)
    input  wire  uart_rxd, // PIN_141 (RX)
    output wire  uart_txd  // PIN_138 (TX)
);

    parameter PAYLOAD_BITS = 8;

    wire [PAYLOAD_BITS-1:0] uart_rx_data; // Holds the byte we just heard
    wire                    uart_rx_valid; // Pulses when a byte arrives

    // Instantiation of uart logic
    uart_communication uart_logic (
        .clk(clk),
        .rst(rst),
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd),
        .uart_tx_data(uart_rx_data),
        .uart_tx_en(uart_rx_valid),
        .uart_rx_data(uart_rx_data),
        .uart_rx_valid(uart_rx_valid)
    );

endmodule