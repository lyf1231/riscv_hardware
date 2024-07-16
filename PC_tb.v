`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 13:43:08
// Design Name: 
// Module Name: PC_tb
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


module PC_tb();

reg clk;
wire[31:0]   pc_;
reg[31:0]   npc;

initial begin
    clk = 0;
    forever begin
       #5   clk = ~clk; 
    end
end

always @(pc_) begin
    npc = pc_ + 4;
end

    PC pc(
        .clk(clk),
        .rst(1'b0),
        .en(1'b1),
        .npc(npc),
        .pc(pc_)
    );
endmodule
