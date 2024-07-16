`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/15 14:55:26
// Design Name: 
// Module Name: DECODER
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
`define ADD                 5'B00000    
`define SUB                 5'B00010   
`define SLT                 5'B00100
`define SLTU                5'B00101
`define AND                 5'B01001
`define OR                  5'B01010
`define XOR                 5'B01011
`define SLL                 5'B01110   
`define SRL                 5'B01111    
`define SRA                 5'B10000  
`define SRC0                5'B10001
`define SRC1                5'B10010

`define R_TYPE              7'b0110011
`define B_TYPE              7'b1100011
`define S_TYPE              7'b0100011
`define J_TYPE              7'b1101111
`define I_TYPE_1            7'b1100111
`define I_TYPE_2            7'b0000011
`define I_TYPE_3            7'b0010011
`define I_TYPE_4            7'b0001111
`define I_TYPE_5            7'b1110011
`define U_TYPE_1            7'b0110111
`define U_TYPE_2            7'b0010111

`define ALU_ERR_OP(reg)          reg = 5'b11111



module DECODER(
    input                           [31 : 0]            inst,

    output              reg         [ 4 : 0]            alu_op,
    output              reg         [31 : 0]            imm,

    output              reg         [ 4 : 0]            rf_ra0,
    output              reg         [ 4 : 0]            rf_ra1,
    output              reg         [ 4 : 0]            rf_wa,
    output              reg         [ 0 : 0]            rf_we,

    output              reg         [ 0 : 0]            alu_src0_sel,       // 0为选择reg，1为选择pc 
    output              reg         [ 0 : 0]            alu_src1_sel        // 0为选择reg, 1为选择立即数
);

    always @(inst) begin
        case (inst[6:0])
        //-------------R-TYPE-DECODE
            `R_TYPE : case (inst[14:12])
            //---funt3: 000, add/sub
                3'b000: case (inst[31:25])
                    7'b0000000: begin
                        alu_op <= `ADD; 
                        rf_ra0 <= inst[19:15];
                        rf_ra1 <= inst[24:20];
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b0;
                    end//add
                    7'b0100000: begin
                        alu_op <= `SUB; 
                        rf_ra0 <= inst[19:15];
                        rf_ra1 <= inst[24:20];
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b0;
                    end//sub
                    default: begin
                        `ALU_ERR_OP(alu_op);
                        rf_we <= 1'b0;
                    end
                endcase 
                3'b001: case (inst[31:25])
                    7'b0000000: begin
                        alu_op <= `SLL; 
                        rf_ra0 <= inst[19:15];
                        rf_ra1 <= inst[24:20];
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b0; 
                    end//sll 
                    default: begin
                        `ALU_ERR_OP(alu_op);
                        rf_we <= 1'b0;
                    end
                endcase
                3'b010: case (inst[31:25])
                    7'b0000000: begin
                        alu_op <= `SLT; 
                        rf_ra0 <= inst[19:15];
                        rf_ra1 <= inst[24:20];
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b0;
                    end//slt
                    default: begin
                        `ALU_ERR_OP(alu_op);
                        rf_we <= 1'b0;
                    end
                endcase
                3'b011: case (inst[31:25])
                    7'b0000000: begin
                        alu_op <= `SLTU; 
                        rf_ra0 <= inst[19:15];
                        rf_ra1 <= inst[24:20];
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b0;
                    end//sltu
                    default: begin
                        `ALU_ERR_OP(alu_op);
                        rf_we <= 1'b0;
                    end
                endcase
                3'b100: case (inst[31:25])
                    7'b0000000: begin
                        alu_op <= `XOR; 
                        rf_ra0 <= inst[19:15];
                        rf_ra1 <= inst[24:20];
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b0;
                    end//xor
                    default: begin
                        `ALU_ERR_OP(alu_op);
                        rf_we <= 1'b0;
                    end
                endcase
                3'b101: case (inst[31:25])
                    7'b0000000: begin
                        alu_op <= `SRL; 
                        rf_ra0 <= inst[19:15];
                        rf_ra1 <= inst[24:20];
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b0;
                    end//srl
                    7'b0100000: begin
                        alu_op <= `SRA; 
                        rf_ra0 <= inst[19:15];
                        rf_ra1 <= inst[24:20];
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b0;
                    end//sra 
                    default: begin
                        `ALU_ERR_OP(alu_op);
                        rf_we <= 1'b0;
                    end
                endcase
                3'b110: case (inst[31:25])
                    7'b0000000: begin
                        alu_op <= `OR; 
                        rf_ra0 <= inst[19:15];
                        rf_ra1 <= inst[24:20];
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b0;
                    end//or 
                    default: begin
                        `ALU_ERR_OP(alu_op);
                        rf_we <= 1'b0;
                    end
                endcase
                3'b111: case (inst[31:25])
                    7'b0000000: begin
                        alu_op <= `AND; 
                        rf_ra0 <= inst[19:15];
                        rf_ra1 <= inst[24:20];
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b0;
                    end//and
                    default: begin
                        `ALU_ERR_OP(alu_op);
                        rf_we <= 1'b0;
                    end
                endcase
                default: begin
                    `ALU_ERR_OP(alu_op);
                    rf_we <= 1'b0;
                end
            endcase
        //-------------R-TYPE-DECODE
        //-------------I-TYPE-DECODE
            `I_TYPE_1 : begin
            `ALU_ERR_OP(alu_op);
            rf_we <= 1'b0;
        end
            `I_TYPE_2 : begin
        `ALU_ERR_OP(alu_op);
        rf_we <= 1'b0;
    end
            `I_TYPE_3 : case (inst[14:12])
                3'b000: begin
                    alu_op <= `ADD; 
                    rf_ra0 <= inst[19:15];
                    imm[11:0] = inst[31:20];
                    imm[31:12] <= imm[11]; 
                    rf_wa <= inst[11:7];
                    rf_we <= 1'b1;
                    alu_src0_sel <= 1'b0;
                    alu_src1_sel <= 1'b1;
                end //addi
                3'b010: begin
                    alu_op <= `SLT; 
                    rf_ra0 <= inst[19:15];
                    imm[11:0] = inst[31:20];
                    imm[31:12] <= imm[11]; 
                    rf_wa <= inst[11:7];
                    rf_we <= 1'b1;
                    alu_src0_sel <= 1'b0;
                    alu_src1_sel <= 1'b1;
                end //slti
                3'b011: begin
                    alu_op <= `SLTU; 
                    rf_ra0 <= inst[19:15];
                    imm[11:0] = inst[31:20];
                    imm[31:12] <= 0; 
                    rf_wa <= inst[11:7];
                    rf_we <= 1'b1;
                    alu_src0_sel <= 1'b0;
                    alu_src1_sel <= 1'b1;
                end //sltiu
                3'b100: begin
                    alu_op <= `XOR; 
                    rf_ra0 <= inst[19:15];
                    imm[11:0] = inst[31:20];
                    imm[31:12] <= imm[11]; 
                    rf_wa <= inst[11:7];
                    rf_we <= 1'b1;
                    alu_src0_sel <= 1'b0;
                    alu_src1_sel <= 1'b1;
                end//xori
                3'b110: begin
                    alu_op <= `OR; 
                    rf_ra0 <= inst[19:15];
                    imm[11:0] = inst[31:20];
                    imm[31:12] <= imm[11]; 
                    rf_wa <= inst[11:7];
                    rf_we <= 1'b1;
                    alu_src0_sel <= 1'b0;
                    alu_src1_sel <= 1'b1;
                end //ori
                3'b111: begin
                    alu_op <= `AND; 
                    rf_ra0 <= inst[19:15];
                    imm[11:0] = inst[31:20];
                    imm[31:12] <= imm[11]; 
                    rf_wa <= inst[11:7];
                    rf_we <= 1'b1;
                    alu_src0_sel <= 1'b0;
                    alu_src1_sel <= 1'b1;
                end //andi
                3'b001: case (inst[31:25])
                    7'b0000000: begin
                        alu_op <= `SLL; 
                        rf_ra0 <= inst[19:15];
                        imm[4:0] = inst[24:20];
                        imm[31:5] = 0;
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b1;
                    end //slli
                    default: begin
                        `ALU_ERR_OP(alu_op);
                        rf_we <= 1'b0;
                    end
                3'b101: case (inst[31:25])
                    7'b0000000: begin
                        alu_op <= `SRL; 
                        rf_ra0 <= inst[19:15];
                        imm[4:0] = inst[24:20];
                        imm[31:5] = 0;
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b1;
                    end //srli
                    7'b0100000: begin
                        alu_op <= `SRA; 
                        rf_ra0 <= inst[19:15];
                        imm[4:0] = inst[24:20];
                        imm[31:5] = 0;
                        rf_wa <= inst[11:7];
                        rf_we <= 1'b1;
                        alu_src0_sel <= 1'b0;
                        alu_src1_sel <= 1'b1;
                    end //srai
                    default: begin
                        `ALU_ERR_OP(alu_op);
                        rf_we <= 1'b0;
                    end
                endcase
                endcase
                default: begin
                    `ALU_ERR_OP(alu_op);
                    rf_we <= 1'b0;
                end
            endcase
            `I_TYPE_4 : begin
            `ALU_ERR_OP(alu_op);
            rf_we <= 1'b0;
        end
            `I_TYPE_5 : begin
        `ALU_ERR_OP(alu_op);
        rf_we <= 1'b0;
    end
            `U_TYPE_1 : begin
                alu_op <= 5'b11110;
                imm[31:12] = inst[31:12];
                imm[11:0] = 0;
                rf_wa <= inst[11:7];
                rf_we <= 1'b1;
                alu_src0_sel <= 1'b0;
                alu_src1_sel <= 1'b1;
            end //lui
            `U_TYPE_2 : begin
                alu_op <= `ADD;
                imm[31:12] = inst[31:12];
                imm[11:0] <= 0;
                rf_wa <= inst[11:7];
                rf_we <= 1'b1;
                alu_src0_sel <= 1'b1;
                alu_src1_sel <= 1'b1;
            end //auipc
            default: begin
                `ALU_ERR_OP(alu_op);
                rf_we <= 1'b0;
            end
        endcase
    end

endmodule
