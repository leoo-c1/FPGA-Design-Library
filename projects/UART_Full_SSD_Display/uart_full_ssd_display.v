module uart_full_ssd_display (
    input clk,                  // 50MHz clock
    input rst,                  // Reset button (not used yet)

    input wire uart_rxd,        // Received data
    output wire uart_txd,       // Transmitted data
    output wire [6:0] segments, // SSD segments to activate
    output reg [3:0] dig_sel    // SSD digit to select
    );

    parameter PAYLOAD_BITS = 8;
    parameter max_sel_count = 416_667;      // Clock prescaler for 60Hz digit switching
    parameter STARTUP_WAIT = 50_000_000;    // 1 second wait after starting the program

    wire [PAYLOAD_BITS-1:0] uart_rx_data;   // Holds the byte we just heard
    wire                    uart_rx_valid;  // Pulses when a byte arrives

    reg [3:0] bottom_rx_data;               // The bottom 4 bits of the UART byte
    reg [3:0] top_rx_data;                  // The top 4 bits of the UART byte

    reg [3:0] dig_update = 4'b1110;         // Digit 1 is initially on
    reg [3:0] input_bits;
    reg       dash = 1'b1;                  // Whether or not to show a dash on the SSDs (initially yes)
    reg [18:0] sel_counter = 0;             // Counter for digit switching
    reg [25:0] startup_counter = 0;

    // UART byte receiving
    always @ (posedge clk) begin
        if (startup_counter < STARTUP_WAIT) begin
            startup_counter <= startup_counter + 1;
            dash <= 1'b1;
        end else if (rst) begin                     // If one second has passed and no reset signal
            if (uart_rx_valid) begin
                bottom_rx_data <= uart_rx_data[3:0];
                top_rx_data <= uart_rx_data[7:4];
                dash <= 1'b0;
            end
        end else if (~rst) begin                    // If we press the reset button, show dashes
            dash <= 1'b1;
        end
    end

    // Digit selection and SSD display
    always @ (posedge clk) begin
        if (sel_counter >= max_sel_count) begin
            sel_counter <= 0;
            if (dig_update == 4'b1110) begin            // If we are showing the first digit
                input_bits <= bottom_rx_data;           // Show the bottom of the UART byte
                dig_sel <= dig_update;
                dig_update <= 4'b1101;                  // Switch to the second digit

            end else if (dig_update == 4'b1101) begin   // If we are showing the second digit
                input_bits <= top_rx_data;              // Show the bottom of the UART byte
                dig_sel <= dig_update;
                dig_update <= 4'b1110;                  // Switch to the first digit
            end else begin                              // Catch-all case
                dig_update <= 4'b1110;                  // Switch to the first digit
                dig_sel <= dig_update;
            end
        end else
            sel_counter <= sel_counter + 1;
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