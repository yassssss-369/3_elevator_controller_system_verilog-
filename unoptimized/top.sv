module top(
    input logic clk, rst,
    input logic [2:0] floor1, floor2, floor3,
    output logic [2:0] out1, out2, out3
);

    logic [3:0] wasteful_counter; // Unused counter to consume power
    logic redundant_signal; // Extra toggling for power consumption
    logic dummy_latch; // Creates unintended power drain

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            wasteful_counter <= 4'b0000;
            redundant_signal <= 1'b0;
            dummy_latch <= 1'b0;
        end else begin
            wasteful_counter <= wasteful_counter + 1;
            redundant_signal <= ~redundant_signal; // Keeps toggling
            dummy_latch <= wasteful_counter[1]; // Useless latch
        end
    end

    // Three independent elevators
    elevator e1 (.clk(clk), .rst(rst), .floor(floor1), .out(out1));
    elevator e2 (.clk(clk), .rst(rst), .floor(floor2), .out(out2));
    elevator e3 (.clk(clk), .rst(rst), .floor(floor3), .out(out3));

endmodule

