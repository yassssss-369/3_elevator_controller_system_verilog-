// Code your testbench here
// or browse Examples
module tb;
  
  logic clk, rst;
  logic [2:0] floor1, floor2, floor3;
  logic [2:0] out1, out2, out3;
  logic rst1, rst2, rst3;
  
  // Instantiate the DUT (Device Under Test)
  top uut (
    .clk(clk),
    .rst(rst),
    .floor1(floor1), .floor2(floor2), .floor3(floor3),
    .rst1(rst1), .rst2(rst2), .rst3(rst3),
    .out1(out1), .out2(out2), .out3(out3)
  );

  // Clock generation
  initial begin
    $dumpfile("dump.vcd"); $dumpvars(1,tb);
    clk = 0;
    forever #10 clk = ~clk;  // 20ns clock period
  end

  // Reset and stimulus
  initial begin
    rst = 1; rst1 = 1; rst2 = 1; rst3 = 1;
    floor1 = 3'b000;
    floor2 = 3'b000;
    floor3 = 3'b000;

    #5 rst = 0; rst1 = 0; rst2 = 0; rst3 = 0;
    #10 rst = 1; rst1 = 1; rst2 = 1; rst3 = 1;

    // Apply test cases
    #20 floor1 = 3'b011;  // Request floor 3 for elevator 1
    #30 floor2 = 3'b101;  // Request floor 5 for elevator 2
    #40 floor3 = 3'b111;  // Request floor 7 for elevator 3

    #50 floor1 = 3'b010;  // Change floor request for elevator 1
    #60 floor2 = 3'b100;  // Change floor request for elevator 2
    #70 floor3 = 3'b001;  // Change floor request for elevator 3

    // Observe behavior for a while
    #100;

    // Finish simulation
    $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("Time=%0t | Out1=%b Out2=%b Out3=%b", $time, out1, out2, out3);
  end

endmodule
