// Code your design here
module elevator(
    input logic clk, rst,
    input logic [2:0] floor,
    output logic [2:0] out,
    output logic idle_flag
);
    typedef enum logic [2:0] {
        S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011,
        S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111
    } State;
    
    State cs, ns;
    logic [3:0] idle_counter;
    logic [2:0] prev_floor;
    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            cs <= S0;
            out <= S0;
            idle_counter <= 4'd0;
            idle_flag <= 1'b0;
            prev_floor <= S0;
        end else begin
            cs <= ns;
            out <= cs;
            prev_floor <= floor;
            if (cs == ns) begin
                if (idle_counter < 4'b1010)
                    idle_counter <= idle_counter + 1;
                else
                    idle_flag <= 1'b1;
            end else begin
                idle_counter <= 4'd0;
                idle_flag <= 1'b0;
            end
        end
    end
    
    always_comb begin
        ns = cs;
        case(cs)
            S0: if (floor > S0) ns = S1;
            S1: if (floor > S1) ns = S2; else if (floor < S1) ns = S0;
            S2: if (floor > S2) ns = S3; else if (floor < S2) ns = S1;
            S3: if (floor > S3) ns = S4; else if (floor < S3) ns = S2;
            S4: if (floor > S4) ns = S5; else if (floor < S4) ns = S3;
            S5: if (floor > S5) ns = S6; else if (floor < S5) ns = S4;
            S6: if (floor > S6) ns = S7; else if (floor < S6) ns = S5;
            S7: if (floor < S7) ns = S6;
        endcase
    end
endmodule

module top(
    input logic clk, rst,
    input logic [2:0] floor1, floor2, floor3,
    input logic rst1, rst2, rst3,
    output logic [2:0] out1, out2, out3
);
    logic idle1, idle2, idle3;
    
    elevator e1(.clk(clk), .rst(rst1), .floor(floor1), .out(out1), .idle_flag(idle1));
    elevator e2(.clk(clk), .rst(rst2), .floor(floor2), .out(out2), .idle_flag(idle2));
    elevator e3(.clk(clk), .rst(rst3), .floor(floor3), .out(out3), .idle_flag(idle3));
    
endmodule
