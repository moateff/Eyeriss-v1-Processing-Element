`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2025 11:35:51 PM
// Design Name: 
// Module Name: D_FF_EN
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


module flopenr 
#(
    parameter DATA_WIDTH = 16
)(
    input                        clk, reset,
    input                        en,
    input      [DATA_WIDTH-1:0] d, 
    output reg [DATA_WIDTH-1:0] q
);

    always @(negedge clk or posedge reset) begin
    if (reset) 
        q <= {DATA_WIDTH{1'b0}};
    else if (en)    
        q <= d;
    end

endmodule

