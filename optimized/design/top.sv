module top(
    input logic clk, rst,
    input logic [2:0] floor1, floor2, floor3, // 3-bit inputs for floors
    input logic rst1, rst2, rst3, 
    
    output logic [2:0] out1, out2, out3
);
  
    logic clk1, clk2, clk3;
    logic enable1, enable2, enable3; // Signals to control clock gating
//   logic [2:0] prev_floor1, prev_floor2, prev_floor3;
//   logic wakie1,wake2,wake3;
  
    // Clock gating logic: Disable clock if idle_flag is set (1 means idle)
    assign clk1 = enable1 ? 0 : clk;
    assign clk2 = enable2 ? 0 : clk;
    assign clk3 = enable3 ? 0 : clk;

  
  
//   assign wake1 = (floor1 != prev_floor1);
//     assign wake2 = (floor2 != prev_floor2);
//     assign wake3 = (floor3 != prev_floor3);
  
//   always_ff @(posedge clk or negedge rst) begin 
//     if(!rst) begin
//       prev_floor1<= 3'b000;
//       prev_floor2<= 3'b000;
//       prev_floor3<= 3'b000;
//     end
//     else begin
    
//       prev_floor1<= out1;
//       prev_floor2<= out2;
//       prev_floor3<= out3;
 
//     end
//     if(wake1)begin
      
//     end
    

//   end
//   assign wake1 = (enable1 && (floor1 == prev_floor1)) ? 0 : 1;
//   assign wake2 = (enable2 && (floor2 == prev_floor2)) ? 0 : 1;
//   assign wake3 = (enable3 && (floor3 == prev_floor3)) ? 0 : 1;
  

  // Instantiate three elevators
    elevator e1(.floor(floor1), .rst(rst1), .out(out1), .clk(clk1), .idle_flag(enable1)); 
    elevator e2(.floor(floor2), .rst(rst2), .out(out2), .clk(clk2), .idle_flag(enable2)); 
    elevator e3(.floor(floor3), .rst(rst3), .out(out3), .clk(clk3), .idle_flag(enable3)); 

endmodule

