module testbench;
    logic clk, rst;
    logic [2:0] floor1, floor2, floor3;
    logic [2:0] out1, out2, out3;

    top uut (
        .clk(clk), .rst(rst),
        .floor1(floor1), .floor2(floor2), .floor3(floor3),
        .out1(out1), .out2(out2), .out3(out3)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize values
        clk = 0;
        rst = 0;
        floor1 = 3'b000;
        floor2 = 3'b001;
        floor3 = 3'b010;

        #10 rst = 1;  // Release reset
        #20 floor1 = 3'b011;
        #20 floor2 = 3'b101;
        #30 floor3 = 3'b110;
        #40 floor1 = 3'b100;
        #50 floor2 = 3'b000;
        #60 floor3 = 3'b111;
        #100 $finish;
    end

    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
    end

endmodule

