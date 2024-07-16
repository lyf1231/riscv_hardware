`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/14 17:49:57
// Design Name: 
// Module Name: REG_FILE
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


module REG_FILE(
    input                   [ 0 : 0]        clk,

    input                   [ 4 : 0]        rf_ra0,
    input                   [ 4 : 0]        rf_ra1,   
    input                   [ 4 : 0]        rf_wa,
    input                   [ 0 : 0]        rf_we,
    input                   [31 : 0]        rf_wd,

    output                  [31 : 0]        rf_rd0,
    output                  [31 : 0]        rf_rd1,

    // debug port
    input                   [ 4 : 0]        dbg_reg_ra,
    output                  [31 : 0]        dbg_reg_rd
    );

    //---init
    reg [31:0] reg_file [31:0];
    integer i;
    initial begin
        for(i=0;i<=31;i=i+1)
            reg_file[i] = 32'b0;
    end
    //---init

    //---read
    // always @(rf_ra0, rf_ra1) begin
    //     rf_rd0 <= reg_file[rf_ra0];
    //     rf_rd1 <= reg_file[rf_ra1];
    // end
    assign rf_rd0 = reg_file[rf_ra0];
    assign rf_rd1 = reg_file[rf_ra1];
    //---read

    //write
    always @(posedge clk) begin
        if(rf_we)
            reg_file[rf_wa] <= rf_wd;
        else
            reg_file[rf_wa] <= reg_file[rf_wa];
        reg_file[0] <= 32'b0;
    end
    //write

    //debug port
    assign dbg_reg_rd = reg_file[dbg_reg_ra];

endmodule
