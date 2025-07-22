`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2025 02:37:09 AM
// Design Name: 
// Module Name: counter
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


module fifo_flag_generator #(
    parameter WIDTH = 8             // Width of counter
)(
    input wire clk,                 // Clock
    input wire reset,               // Synchronous reset
    input wire enable,              // Enable signal
    output wire flag                // High when count_r ? 0
);

    reg [WIDTH-1:0] count_r;        // Internal counter register

    always @(negedge clk or posedge reset) begin
        if (reset) begin
            count_r <= {WIDTH{1'b0}};      // Reset to 0
        end else if (flag) begin
            count_r <= count_r + 1'b1;     // Increment
        end
    end

    assign flag = (count_r != 0) | enable; // Set flag when count_r ? 0 or enable is high

endmodule
