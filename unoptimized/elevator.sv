module elevator(
    input logic clk, rst,
    input logic [2:0] floor,
    output logic [2:0] out
);

    typedef enum logic [2:0] {
        S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011,
        S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111
    } State;

    State cs, ns;
    logic [3:0] redundant_counter; // Power-consuming counter
    logic dummy_signal; // Adds unnecessary toggling

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            cs <= S0;
            redundant_counter <= 4'b0000; 
            dummy_signal <= 1'b0;
        end else begin
            cs <= ns;
            redundant_counter <= redundant_counter + 1; // Useless counting
            dummy_signal <= ~dummy_signal; // Keeps toggling every cycle
        end
    end

    always_comb begin
        ns = cs;
        case(cs)
            S0: if (floor > 3'b000) ns = S1;
            S1: if (floor > 3'b001) ns = S2; else if (floor < 3'b001) ns = S0;
            S2: if (floor > 3'b010) ns = S3; else if (floor < 3'b010) ns = S1;
            S3: if (floor > 3'b011) ns = S4; else if (floor < 3'b011) ns = S2;
            S4: if (floor > 3'b100) ns = S5; else if (floor < 3'b100) ns = S3;
            S5: if (floor > 3'b101) ns = S6; else if (floor < 3'b101) ns = S4;
            S6: if (floor > 3'b110) ns = S7; else if (floor < 3'b110) ns = S5;
            S7: if (floor < 3'b111) ns = S6;
        endcase
    end

    assign out = cs ^ redundant_counter[2:0]; // Adds useless toggling

endmodule

