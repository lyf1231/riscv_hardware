`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/14 20:26:45
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb();

reg [31:0] src0, src1;
reg [4:0] sel; 
wire [31:0] res;

ALU alu(
    .alu_src0(src0),
    .alu_src1(src1),
    .alu_op(sel),
    .alu_res(res)
);
    initial begin
      src0=32'hffffffff; src1=32'h2; sel=5'H0;
      #20
      repeat(32) begin
          sel = sel + 1;
          #20;
       end
    end
endmodule
