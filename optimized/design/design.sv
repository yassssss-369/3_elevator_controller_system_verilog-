module elevator(
    input logic clk, rst,
    input logic [2:0] floor,
  output logic [2:0] out,
  output logic idle_flag
);
  logic rstn;
  logic enable;
//   logic fsm_clk; // Clock for FSM
  logic [3:0] idle_counter;
   typedef enum logic [2:0] {
        S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011,
        S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111
    } State;
  State cs, ns;

//   assign enable = 1'b1;
//   assign fsm_clk = clk & enable;

  // ========== FSM Sequential Logic ============
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) 
      cs <= S0;  // Reset to ground floor
    else 
      cs <= ns;
      
    out <= cs;  // Update output state synchronously
  end

  // ========== FSM Combinational Logic ============
  always_comb begin
    ns = cs;  // Default: remain in current state
    case(cs)
      S0: begin
        if (floor > 3'b000) ns = S1;
      end

      S1: begin 
        if (floor > 3'b001) ns = S2;
        else if (floor < 3'b001) ns = S0;
      end

      S2: begin 
        if (floor > 3'b010) ns = S3;
        else if (floor < 3'b010) ns = S1;
      end

      S3: begin 
        if (floor > 3'b011) ns = S4;
        else if (floor < 3'b011) ns = S2;
      end

      S4: begin 
        if (floor > 3'b100) ns = S5;
        else if (floor < 3'b100) ns = S3;
      end

      S5: begin 
        if (floor > 3'b101) ns = S6;
        else if (floor < 3'b101) ns = S4;
      end

      S6: begin 
        if (floor > 3'b110) ns = S7;
        else if (floor < 3'b110) ns = S5;
      end

      S7: begin 
        if (floor < 3'b111) ns = S6;
      end
    endcase
  end

// ===============power saving mechanism=================
  
  always_ff @(posedge clk or negedge rstn) begin
     if (!rstn) begin
            idle_counter <= 4'd0;
            idle_flag <= 1'b0;
        end else if (cs == ns) begin
          if (idle_counter < 4'd1010) 
                idle_counter <= idle_counter + 1;
            else
                idle_flag <= 1'b1;  // Enter idle mode
        end else begin
            idle_counter <= 4'd0; // Reset when state changes
            idle_flag <= 1'b0;    // Wake up
        end
    end
  
  always_comb begin
        if (idle_flag && (floor != cs)) 
            rstn = 1'b0;  // Force reset
        else
            rstn = 1'b1;  // Normal operation
    end

endmodule

