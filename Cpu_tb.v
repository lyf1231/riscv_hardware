`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/15 23:09:24
// Design Name: 
// Module Name: Cpu_tb
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


module Cpu_tb();

wire[31:0]  a;
wire[31:0]  d;
wire[31:0]  spo;
reg[0:0]    clk;

wire[4:0]   alu_op;
wire[31:0]  imm;
wire[31:0]  pc_wire;
wire[0:0]   sel_0, sel_1;
wire[0:0]   rf_we;
wire[4:0]   rf_ra0, rf_ra1, rf_wa;
wire[31:0]  rf_rd1, rf_rd0, rf_wd;
wire[31:0]  alu_src0, alu_src1, alu_res;
wire[31:0]   real_imm_addr;

initial begin
    clk = 0;
    forever begin
        #5  clk = ~clk;
    end
end

CPU cpu(
    .clk(clk),
    .rst(1'b0),
    .global_en(1'b1),
    .imem_raddr(a),
    .imem_rdata(spo),
    .dmem_rdata(),
    .dmem_we(),
    .dmem_addr(),
    .dmem_wdata(),

    .alu_op_d(alu_op),
    .imm_d(imm),
    .pc_wire_d(pc_wire),
    .sel_0_d(sel_0), .sel_1_d(sel_1),
    .rf_we_d(rf_we),
    .rf_ra0_d(rf_ra0), .rf_ra1_d(rf_ra1), .rf_wa_d(rf_wa),
    .rf_rd1_d(rf_rd1), .rf_rd0_d(rf_rd0), .rf_wd_d(rf_wd),
    .alu_src0_d(alu_src0), .alu_src1_d(alu_src1), .alu_res_d(alu_res)
);

assign real_imm_addr = (a-32'h00400000) >>2;

dist_mem_gen_0 inst_mem (
  .a(real_imm_addr[9:0]),      // input wire [9 : 0] a
  .d(d),      // input wire [31 : 0] d
  .clk(clk),  // input wire clk
  .we(1'b0),    // input wire we
  .spo(spo)  // output wire [31 : 0] spo
);



endmodule
