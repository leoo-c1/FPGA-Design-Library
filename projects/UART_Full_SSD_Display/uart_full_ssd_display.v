module uart_full_ssd_display (
    input clk,                  // 50MHz clock
    input rst,                  // Reset button (not used yet)

    input wire uart_rxd,        // Received data
    output wire uart_txd,       // Transmitted data
    output wire [6:0] segments, // SSD segments to activate
    output reg [3:0] dig_sel    // SSD digit to select
    );

    parameter PAYLOAD_BITS = 8;
    parameter max_count_sel = 416_667;      // Clock prescaler for 60Hz digit switching

    wire [PAYLOAD_BITS-1:0] uart_rx_data;   // Holds the byte we just heard
    wire                    uart_rx_valid;  // Pulses when a byte arrives

    wire [PAYLOAD_BITS-5:0] bottom_rx_data; // The bottom 4 bits of the UART byte
    wire [PAYLOAD_BITS-5:0] top_rx_data;    // The top 4 bits of the UART byte

    assign bottom_rx_data = uart_rx_data[PAYLOAD_BITS-5:0];
    assign top_rx_data = uart_rx_data[PAYLOAD_BITS-1:PAYLOAD_BITS-4];

    reg [3:0] dig_update = 4'b1110;         // Digit 1 is initially on
    reg [3:0] input_bits;
    reg       dash;                         // Whether or not to show a dash on the SSDs

    always @ (posedge clk) begin
        if (dig_update == 4'b1110) begin            // If we are showing the first digit
            if (uart_rx_valid) begin                // If we received a UART byte
                input_bits <= bottom_rx_data;       // Show the bottom of the UART byte
                dash <= 1'b0;

            end else                                // Don't show a dash                                  // If we haven't received a byte yet
                dash <= 1'b1;                       // Show the dash

            dig_sel <= dig_update;
            dig_update <= 4'b1101;                  // Switch to the second digit

        end else if (dig_update == 4'b1101) begin   // If we are showing the second digit
            if (uart_rx_valid) begin                // If we received a UART byte
                input_bits <= top_rx_data;          // Show the bottom of the UART byte
                dash <= 1'b0;                       // Don't show a dash

            end else                                // If we haven't received a byte yet
                dash <= 1'b1;                       // Show the dash

            dig_sel <= dig_update;
            dig_update <= 4'b1110;                  // Switch to the first digit
        end else begin                              // Catch-all case
            dig_update <= 4'b1110;                  // Switch to the first digit
            dig_sel <= dig_update;
        end
    end

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

    // Instantiation of SSD logic
    Segment_Selector ssd_display (
        .input_bits(input_bits),
        .dash(dash),
        .segments(segments)
    );

endmodule