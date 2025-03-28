module tb;

  logic clk, rst;
  logic [2:0] floor1, floor2, floor3;
  logic [2:0] out1, out2, out3;
  logic rst1,rst2,rst3;

  top uut (.clk(clk), .rst(rst), .floor1(floor1), .floor2(floor2), .floor3(floor3), 
           .out1(out1), .out2(out2), .out3(out3),.rst2(rst2),.rst3(rst3),.rst1(rst1));

  // Clock generation
  always #5 clk = ~clk; // 10ns clock period

  initial begin
    clk = 0;
    rst = 0;
    floor1 = 3'b000;
    floor2 = 3'b000;
    floor3 = 3'b000;
    rst = 0; rst1 = 0; rst2 = 0; rst3 = 0;
    #10 rst = 1; rst1 = 1; rst2 = 1; rst3 = 1; // Release reset
//     #5rst = 0; rst1 = 0; rst2 = 0; rst3 = 0;
    // Elevator 1: Moves from 0 -> 3 -> 0
    #20 floor1 = 3'b011; // Request floor 3
    #50 floor1 = 3'b000; // Return to floor 0

    // Elevator 2: Moves from 0 -> 5
    #30 floor2 = 3'b101; 

    // Elevator 3: Moves from 0 -> 2 -> 4
    #40 floor3 = 3'b010;
    #30 floor3 = 3'b100;

    // Wait for idle states
    #200;
    $finish;
  end

  initial begin
    $dumpfile("elevator_system.vcd");
    $dumpvars(0, tb);
  end

endmodule

