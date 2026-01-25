module quad_ssd_counter (
    input        clk,      // PIN_23 (50MHz)
    input        rst,     // PIN_25 (RESET)
    output wire [6:0] segments,         // Segments that are highlighted
    output reg [3:0] dig_sel,           // Selected digit
    output reg decimal                  // Decimal point
);

    // Prescaler constants
    parameter max_count_sel = 208_333;          // 240Hz digit switching
    parameter max_count_10msec = 500_000;       // 10 millisecond
    parameter max_count_100msec = 5_000_000;    // 100 millisecond
    parameter max_count_1sec = 50_000_000;      // 1 second  
    parameter max_count_10sec = 500_000_000;    // 10 second

    // Counters with initial values of 0
    reg [18:0] counter_sel = 0;         // Digit switching
    reg [18:0] counter_10msec = 0;      // 10 millisecond counter
    reg [22:0] counter_100msec = 0;     // 100 millisecond counter
    reg [25:0] counter_1sec = 0;        // 1 second counter
    reg [28:0] counter_10sec = 0;       // 10 second counter

    // Displayed values on SSD with initial values of 0
    reg [3:0] dig1_bits = 4'b0000;      // 10s of milliseconds elapsed
    reg [3:0] dig2_bits = 4'b0000;      // 100s of milliseconds elapsed
    reg [3:0] dig3_bits = 4'b0000;      // Seconds elapsed
    reg [3:0] dig4_bits = 4'b0000;      // 10s of seconds elapsed

    reg [3:0] input_bits = 4'b0000;     // The bits we input to the SSDs
    reg [3:0] dig_update = 4'b1110;     // First digit is initially on (active low)

    // This handles SSD 4-digit multiplexing
    always @ (posedge clk) begin
        if (counter_sel >= max_count_sel) begin
            counter_sel <= 0;
            if (dig_update == 4'b1110) begin            // If the first digit is being shown
                input_bits <= dig1_bits;                // Show the bits for dig1
                decimal <= 1'b1;                        // Turn off the decimal point
                dig_update <= 4'b1101;                  // Switch to second digit
                dig_sel <= dig_update;
            end else if (dig_update == 4'b1101) begin   // If second digit is being shown
                input_bits <= dig2_bits;                // Show the bits for dig2
                decimal <= 1'b1;                        // Turn off the decimal point
                dig_update <= 4'b1011;                  // Switch to third digit
                dig_sel <= dig_update;
            end else if (dig_update == 4'b1011) begin   // If the third digit is being shown
                input_bits <= dig3_bits;                // Show the bits for dig3
                decimal <= 1'b0;                        // Turn on the decimal point
                dig_update <= 4'b0111;                  // Switch to fourth digit
                dig_sel <= dig_update;
            end else if (dig_update == 4'b0111) begin   // If the fourth digit is being shown
                input_bits <= dig4_bits;                 // Show the bits for dig4
                decimal <= 1'b1;                        // Turn off the decimal point
                dig_update <= 4'b1110;                  // Switch back to first digit
                dig_sel <= dig_update;
            end else begin                              // Catch-all case
                dig_update <= 4'b1110;                  // Switch back to first digit
                dig_sel <= dig_update;
            end
        end else begin
            counter_sel <= counter_sel + 1;             // Increment counter until we hit max_count_sel
        end
    end

    // Increment the 1 second counter and update elapsed time
    always @ (posedge clk) begin
        if (counter_1sec >= max_count_1sec) begin
        counter_1sec <= 0;
            if (dig3_bits < 9) begin
                dig3_bits <= dig3_bits + 1;
            end else begin
                dig3_bits <= 4'b0000;
            end
        end else begin
            counter_1sec <= counter_1sec + 1;
        end
    end

    // Increment the 10 second counter and update elapsed time
    always @ (posedge clk) begin
        if (counter_10sec >= max_count_10sec) begin
            counter_10sec <= 0;
            if (dig4_bits < 9) begin
                dig4_bits <= dig4_bits + 1;
            end else begin
                dig4_bits <= 4'b0000;
            end
        end else begin
            counter_10sec <= counter_10sec + 1;
        end
    end

    // Increment the 100 millisecond counter and update elapsed time
    always @ (posedge clk) begin
        if (counter_100msec >= max_count_100msec) begin
            counter_100msec <= 0;
            if (dig2_bits < 9) begin
                dig2_bits <= dig2_bits + 1;
            end else begin
                dig2_bits <= 4'b0000;
            end
        end else begin
            counter_100msec <= counter_100msec + 1;
        end
    end

    // Increment the 10 millisecond counter and update elapsed time
    always @ (posedge clk) begin
        if (counter_10msec >= max_count_10msec) begin
            counter_10msec <= 0;
            if (dig1_bits < 9) begin
                dig1_bits <= dig1_bits + 1;
            end else begin
                dig1_bits <= 4'b0000;
            end
        end else begin
            counter_10msec <= counter_10msec + 1;
        end
    end

    // SSD Driver Instantiation
    Segment_Selector ssd_driver (
        .input_bits(input_bits),
        .segments(segments)
    );

endmodule