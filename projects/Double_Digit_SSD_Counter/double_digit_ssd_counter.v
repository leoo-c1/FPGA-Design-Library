module double_digit_ssd_counter (
    input        clk,      // PIN_23 (50MHz)
    input        rst,     // PIN_25 (RESET)
    output wire [6:0] segments,         // Segments that are highlighted
    output reg [3:0] dig_sel            // Selected digit
);

    parameter PAYLOAD_BITS = 8;         // Number of bits of info to send
    parameter max_count_sel = 416_667;      // Clock prescaler for 60Hz digit switching
    parameter max_count_1sec = 50_000_000;  // Clock prescaler for number updates every 1 second  
    parameter max_count_10sec = 500_000_000;  // Clock prescaler for number updates every 10 seconds  

    // wire [PAYLOAD_BITS-1:0] uart_rx_data;

    reg [3:0] dig_update = 4'b1110;     // First digit is initially on (active low)

    reg [18:0] counter_sel = 0;         // Initial count value for digit switching
    reg [25:0] counter_1sec = 0;        // Initial count value for 1 second counter
    reg [28:0] counter_10sec = 0;       // Initial count value for 10 second counter

    reg [3:0] dig0_bits = 4'b0000;      // Seconds elapsed, initial value of 0
    reg [3:0] dig1_bits = 4'b0000;      // 10s of seconds elapsed, initial value of 0

    reg [3:0] input_bits = 4'b0000;               // The bits we input to the SSDs

    // This handles SSD digit multiplexing
    always @ (posedge clk) begin
        if (counter_sel >= max_count_sel) begin
            counter_sel <= 0;
            if (dig_update == 4'b1110) begin            // If the first digit is being shown
                dig_update <= 4'b1101;                  // Switch to second digit
                dig_sel <= dig_update;
                input_bits <= dig0_bits;                // Start displaying number for second digit
            end else if (dig_update == 4'b1101) begin   // If second digit is being shown
                dig_update <= 4'b1110;                  // Switch to first digit
                dig_sel <= dig_update;
                input_bits <= dig1_bits;                // Start displaying number for first digit
            end else begin                              // Catch-all case
                dig_update <= 4'b1110;
                dig_sel <= dig_update;
                input_bits <= dig0_bits;
            end
        end else begin
            counter_sel <= counter_sel + 1;             // Increment counter until we hit max_count_sel
        end
    end

    // This handles incrementing the 1 second counter and displaying elapsed time
    always @ (posedge clk) begin
        if (counter_1sec >= max_count_1sec) begin
        counter_1sec <= 0;
            if (dig0_bits < 9) begin
                dig0_bits <= dig0_bits + 1;
            end else begin
                dig0_bits <= 4'b0000;
            end
        end else begin
            counter_1sec <= counter_1sec + 1;
        end
    end

    // This handles incrementing the 10 second counter and displaying elapsed time
    always @ (posedge clk) begin
        if (counter_10sec >= max_count_10sec) begin
            counter_10sec <= 0;
            if (dig1_bits < 9) begin
                dig1_bits <= dig1_bits + 1;
            end else begin
                dig1_bits <= 4'b0000;
            end
        end else begin
            counter_10sec <= counter_10sec + 1;
        end
    end

    // SSD Driver Instantiation
    Segment_Selector ssd_driver (
        .input_bits(input_bits),
        .segments(segments)
    );

endmodule