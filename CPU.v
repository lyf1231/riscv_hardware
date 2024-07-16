`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/15 21:20:40
// Design Name: 
// Module Name: CPU
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


module CPU (
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rst,

    input                   [ 0 : 0]            global_en,

/* ------------------------------ Memory (inst) ----------------------------- */
    output                  [31 : 0]            imem_raddr,
    input                   [31 : 0]            imem_rdata,

/* ------------------------------ Memory (data) ----------------------------- */
    input                   [31 : 0]            dmem_rdata,
    output                  [ 0 : 0]            dmem_we,
    output                  [31 : 0]            dmem_addr,
    output                  [31 : 0]            dmem_wdata,

/* ---------------------------------- Debug --------------------------------- */
    output                  [ 0 : 0]            commit,
    output                  [31 : 0]            commit_pc,
    output                  [31 : 0]            commit_inst,
    output                  [ 0 : 0]            commit_halt,
    output                  [ 0 : 0]            commit_reg_we,
    output                  [ 4 : 0]            commit_reg_wa,
    output                  [31 : 0]            commit_reg_wd,
    output                  [ 0 : 0]            commit_dmem_we,
    output                  [31 : 0]            commit_dmem_wa,
    output                  [31 : 0]            commit_dmem_wd,

    input                   [ 4 : 0]            debug_reg_ra,   // TODO
    output                  [31 : 0]            debug_reg_rd,    // TODO


    output                  wire[4:0]           alu_op_d,
    output                  wire[31:0]          imm_d,
    output                  wire[31:0]          pc_wire_d,
    output                  wire[0:0]           sel_0_d, sel_1_d,
    output                  wire[0:0]           rf_we_d,
    output                  wire[4:0]           rf_ra0_d, rf_ra1_d, rf_wa_d,
    output                  wire[31:0]          rf_rd1_d, rf_rd0_d, rf_wd_d,
    output                  wire[31:0]          alu_src0_d, alu_src1_d, alu_res_d



);

    wire[4:0]   alu_op;
    wire[31:0]  imm;
    wire[31:0]  pc_wire;
    wire[0:0]   sel_0, sel_1;
    wire[0:0]   rf_we;
    wire[4:0]   rf_ra0, rf_ra1, rf_wa;
    wire[31:0]  rf_rd1, rf_rd0, rf_wd;
    wire[31:0]  alu_src0, alu_src1, alu_res;

    reg[31:0] npc;
    reg[0:0] clk_d;

    assign pc_wire_d = pc_wire;
    assign imem_raddr = pc_wire;
    assign alu_op_d = alu_op;
    assign imm_d = imm;
    assign rf_ra0_d = rf_ra0;
    assign rf_ra1_d = rf_ra1;
    assign rf_wa_d = rf_wa;
    assign rf_we_d = rf_we;
    assign sel_0_d = sel_0;
    assign sel_1_d = sel_1;
    assign alu_src0_d = alu_src0;
    assign alu_src1_d = alu_src1;
    assign alu_res_d = alu_res;
    assign rf_rd0_d = rf_rd0;
    assign rf_rd1_d = rf_rd1;

    always @(pc_wire) begin
        npc = pc_wire + 4;
    end

    DECODER decoder(
        .inst(imem_rdata),
        .alu_op(alu_op),
        .imm(imm),
        .rf_ra0(rf_ra0),
        .rf_ra1(rf_ra1),
        .rf_wa(rf_wa),
        .rf_we(rf_we),
        .alu_src0_sel(sel_0),
        .alu_src1_sel(sel_1)
    );

    PC pc(
        .clk(clk), 
        .rst(rst),
        .en(global_en),
        .npc(npc),
        .pc(pc_wire)
    );

    MUX mux_0(
        .sel(sel_0),
        .src0(rf_rd0),
        .src1(pc_wire),
        .res(alu_src0)
    );

    MUX mux_1(
        .sel(sel_1),
        .src0(rf_rd1),
        .src1(imm),
        .res(alu_src1)
    );

    REG_FILE reg_file(
        .clk(clk),
        .rf_ra0(rf_ra0),
        .rf_ra1(rf_ra1),   
        .rf_wa(rf_wa),
        .rf_we(rf_we),
        .rf_wd(alu_res),
        .rf_rd0(rf_rd0),
        .rf_rd1(rf_rd1),
        .dbg_reg_ra(debug_reg_ra),
        .dbg_reg_rd(debug_reg_rd)


    );

    ALU alu(
        .alu_src0(alu_src0),
        .alu_src1(alu_src1),
        .alu_op(alu_op),
        .alu_res(alu_res)
    );


    // Commit
    reg  [ 0 : 0]   commit_reg          ;
    reg  [31 : 0]   commit_pc_reg       ;
    reg  [31 : 0]   commit_inst_reg     ;
    reg  [ 0 : 0]   commit_halt_reg     ;
    reg  [ 0 : 0]   commit_reg_we_reg   ;
    reg  [ 4 : 0]   commit_reg_wa_reg   ;
    reg  [31 : 0]   commit_reg_wd_reg   ;
    reg  [ 0 : 0]   commit_dmem_we_reg  ;
    reg  [31 : 0]   commit_dmem_wa_reg  ;
    reg  [31 : 0]   commit_dmem_wd_reg  ;

    // Commit
    always @(posedge clk) begin
        if (rst) begin
            commit_reg          <= 1'B0;
            commit_pc_reg       <= 32'H0;
            commit_inst_reg     <= 32'H0;
            commit_halt_reg     <= 1'B0;
            commit_reg_we_reg   <= 1'B0;
            commit_reg_wa_reg   <= 5'H0;
            commit_reg_wd_reg   <= 32'H0;
            commit_dmem_we_reg  <= 1'B0;
            commit_dmem_wa_reg  <= 32'H0;
            commit_dmem_wd_reg  <= 32'H0;
        end
        else if (global_en) begin
            commit_reg          <= 1'B1;
            commit_pc_reg       <= 0;   // TODO
            commit_inst_reg     <= 0;   // TODO
            commit_halt_reg     <= 0;   // TODO
            commit_reg_we_reg   <= 0;   // TODO
            commit_reg_wa_reg   <= 0;   // TODO
            commit_reg_wd_reg   <= 0;   // TODO
            commit_dmem_we_reg  <= 0;   // TODO
            commit_dmem_wa_reg  <= 0;   // TODO
            commit_dmem_wd_reg  <= 0;   // TODO
        end
    end

    assign commit           = commit_reg;
    assign commit_pc        = commit_pc_reg;
    assign commit_inst      = commit_inst_reg;
    assign commit_halt      = commit_halt_reg;
    assign commit_reg_we    = commit_reg_we_reg;
    assign commit_reg_wa    = commit_reg_wa_reg;
    assign commit_reg_wd    = commit_reg_wd_reg;
    assign commit_dmem_we   = commit_dmem_we_reg;
    assign commit_dmem_wa   = commit_dmem_wa_reg;
    assign commit_dmem_wd   = commit_dmem_wd_reg;

endmodule