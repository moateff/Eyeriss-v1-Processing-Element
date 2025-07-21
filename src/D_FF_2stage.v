`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 12:18:56 AM
// Design Name: 
// Module Name: D_FF_2stage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module flopr2
#(
    parameter DATA_WIDTH = 16
)(
    input                   clk, reset,
    input  [DATA_WIDTH-1:0] d, 
    output [DATA_WIDTH-1:0] q
);
    
    reg [DATA_WIDTH-1:0] q1, q2;
    
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            q1 <= {DATA_WIDTH{1'b0}};
            q2 <= {DATA_WIDTH{1'b0}};
        end else begin  
            q1 <= d;
            q2 <= q1;
        end
    end
    
    assign q = q2;
    
endmodule
