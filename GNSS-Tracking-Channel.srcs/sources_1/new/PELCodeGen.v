`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/19 23:04:35
// Design Name: 
// Module Name: PELCodeGen
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

`include "../../include/configurationPackage.v"

module PELCodeGen
(
    input   wire            I_sysClk,
    input   wire            I_sysRst_n,
    input   wire    [0 : 0] I_codeReplica,
    output  wire    [0 : 0] O_promptCode,
    output  wire    [0 : 0] O_earlyCode,
    output  wire    [0 : 0] O_lateCode
);

// Parameter 
parameter integer   C_CODE_DELAY_REG_WIDTH  = `C_CODE_DELAY_REG_WIDTH;
parameter integer   C_CODE_DELAY_MID_POINT  = `C_CODE_DELAY_MID_POINT;
parameter integer   C_ONE_CHIP_SPACING      = `C_ONE_CHIP_SPACING;

// Internal signals
reg     [C_CODE_DELAY_REG_WIDTH - 1 : 0] S_codDelayReg;

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_codDelayReg <= 0;
    else
        S_codDelayReg <= {S_codDelayReg[C_CODE_DELAY_REG_WIDTH - 2 : 0], I_codeReplica};

assign O_promptCode = S_codDelayReg[C_CODE_DELAY_MID_POINT];
assign O_earlyCode = S_codDelayReg[C_CODE_DELAY_MID_POINT - C_ONE_CHIP_SPACING];
assign O_lateCode = S_codDelayReg[C_CODE_DELAY_MID_POINT + C_ONE_CHIP_SPACING];

endmodule
