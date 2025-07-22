`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 11:02:50 PM
// Design Name: 
// Module Name: Spad
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

module psum_spad 
#(
    parameter MEM_DEPTH  = 24,      
    parameter DATA_WIDTH = 16,    
    parameter ADDR_WIDTH = $clog2(MEM_DEPTH)
)(
    input  wire                    clk,  
    
    input  wire                    w_en, 
    input  wire [DATA_WIDTH - 1:0] din,    
    input  wire [ADDR_WIDTH - 1:0] w_addr,  
    
    input  wire [ADDR_WIDTH - 1:0] r_addr, 
    output reg  [DATA_WIDTH - 1:0] dout   
);
    
    // The memory has MEM_DEPTH locations, each of DATA_WIDTH bits
    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    
    // Memory write and read logic
    always @(posedge clk) begin
        if (w_en) begin
            mem[w_addr] <= din;
        end
    end
    
    always @(negedge clk) begin
        dout <= mem[r_addr];
    end
                
endmodule
