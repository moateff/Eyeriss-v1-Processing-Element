`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 09:51:18 PM
// Design Name: 
// Module Name: Mux2x1
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


module mux2x1
#(
    parameter DATA_WIDTH = 16
)(
    input  [DATA_WIDTH-1:0] in0,   // Input 0
    input  [DATA_WIDTH-1:0] in1,   // Input 1
    input                    sel,   // Select line
    
    output [DATA_WIDTH-1:0] out    // Output
);
    assign out = sel ? in1 : in0; // If sel is 1, output in1; else, output in0
endmodule

