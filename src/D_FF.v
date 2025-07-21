`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2025 11:30:57 PM
// Design Name: 
// Module Name: D_FF
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


module flopr 
#(
    parameter DATA_WIDTH = 16
)(
    input                       clk, reset,
    input      [DATA_WIDTH-1:0] d, 
    output reg [DATA_WIDTH-1:0] q
);

    always @(negedge clk or posedge reset) begin
    if (reset) 
        q <= {DATA_WIDTH{1'b0}};
    else       
        q <= d;
    end

endmodule

