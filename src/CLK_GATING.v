`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2025 11:14:27 PM
// Design Name: 
// Module Name: CLK_GATING
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


module CLK_GATING (
    input  enable,
    input  clk,
    output gated_clk
);

    // Internal latch for clock enable control
    reg latch_en;
    
    // Level-sensitive latch
    always @(clk or enable) begin
        if (!clk) begin  // Transparent when CLK is low
            latch_en <= enable;
        end
    end
    
    // Clock gating logic using AND gate
    assign gated_clk = clk & latch_en;

endmodule
