module ButtonBuzzerVerilog (
    input wire clk,       // Your 50MHz crystal oscillator
    input wire btn_1,			// Button 1
	 input wire btn_2,			// Button 2
	 input wire btn_3,			// Button 3
	 input wire btn_4,			// Button 4
    output reg buzzer     // The pin connected to the buzzer
);

    // We need a container to store the count for the low E (requires 19 bits)
    reg [18:0] counter_0th;
	 
	 // Do the rest for the other frets (only require 18 bits)
	 reg [17:0] counter_3rd;
	 reg [17:0] counter_5th;
	 reg [17:0] counter_6th;
	 
	 localparam count_0 = 303361;
	 localparam count_3 = 255095;
	 localparam count_5 = 227264;
	 localparam count_6 = 214509;

    // This block runs perfectly aligned with the rising edge of the 50MHz clock
    always @(posedge clk) begin
	 
	 // 1. Check if we press only button 1
        if (btn_1 == 0 && btn_2 == 1 && btn_3 == 1 && btn_4 == 1) begin
            // 2. Check if we reached the count for the low E
            if (counter_0th >= count_0) begin
                // Toggle the buzzer (Flip 0 to 1, or 1 to 0)
                buzzer <= ~buzzer;
					 counter_0th <= 0;
            end else begin
					// Keep counting up
					counter_0th <= counter_0th + 1;
            end
			
			// Check if we only press button 2
			end else if (btn_2 == 0 && btn_1 == 1 && btn_3 == 1 && btn_4 == 1) begin
				// 2. Check if we reached the count for the 3rd fret
            if (counter_3rd >= count_3) begin
                // Toggle the buzzer (Flip 0 to 1, or 1 to 0)
                buzzer <= ~buzzer;
					 counter_3rd <= 0;
            end else begin
					// Keep counting up
					counter_3rd <= counter_3rd + 1;
            end
			
			// Check if we only press button 3
			end else if (btn_3 == 0 && btn_1 == 1 && btn_2 == 1 && btn_4 == 1) begin
				// 2. Check if we reached the count for the 5th fret
            if (counter_5th >= count_5) begin
                // Toggle the buzzer (Flip 0 to 1, or 1 to 0)
                buzzer <= ~buzzer;
					 counter_5th <= 0;
            end else begin
					// Keep counting up
					counter_5th <= counter_5th + 1;
            end
			
			// Check if we only press button 4
			end else if (btn_4 == 0 && btn_1 == 1 && btn_2 == 1 && btn_3 == 1) begin
				// 2. Check if we reached the count for the 6th fret
            if (counter_6th >= count_6) begin
                // Toggle the buzzer (Flip 0 to 1, or 1 to 0)
                buzzer <= ~buzzer;
					 counter_6th <= 0;
            end else begin
					// Keep counting up
					counter_6th <= counter_6th + 1;
            end
			
			// The else case means either no buttons are being pressed or multiple are
			// Either way, in this case we should not activate the buzzer
			end else begin
				buzzer <= 0;
			end
    end

endmodule