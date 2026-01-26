module uart_ssd_display (
    input        clk,      // PIN_23 (50MHz)
    input        rst,     // PIN_88 (KEY1 - Reset)
    input  wire  uart_rxd, // PIN_141 (RX)
    output wire  uart_txd, // PIN_138 (TX)
    output wire [6:0] segments,         // Segments that are highlighted
    output wire [3:0] dig_sel         // Selected digit
);

    parameter PAYLOAD_BITS = 8;

    wire [PAYLOAD_BITS-1:0] uart_rx_data;

    assign dig_sel = 4'b1110;

    uart_communication uart_logic (
        .clk(clk),
        .rst(rst),
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd),

        .uart_rx_data(uart_rx_data),
        .uart_tx_data(uart_tx_data),
        .uart_tx_en(uart_tx_en)
    );

    // TRUNCATED RX DATA FOR SSD DISPLAY
    wire [3:0] uart_rx_data_trunc;
    assign uart_rx_data_trunc = uart_rx_data[3:0];

    // SSD Driver Instantiation
    Segment_Selector ssd_driver (
        .input_bits(uart_rx_data_trunc),        // SSD will display our bottom 4 bits
        .segments(segments),
        .dig_sel(dig_sel)
    );

endmodule