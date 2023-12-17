`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/20 15:45:49
// Design Name: 
// Module Name: accumulator
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

module accumulator
(
    input   wire                                                                I_sysClk,
    input   wire                                                                I_sysRst_n,
    input   wire                                                                I_PELReplicaClk,
    input   wire                                                                I_PELFinish,
    input   wire signed  [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]  I_S_postCarrCodeMix_IQ,
    output  wire signed  [`C_ACCM_WIDTH - 1 : 0]                                O_S_accumulation,
    output  wire signed  [`C_ACCM_WIDTH - 1 : 0]                                O_S_accumulationReg
);

// Internal signals
reg signed  [`C_ACCM_WIDTH - 1 : 0] S_S_accumulation;
reg signed  [`C_ACCM_WIDTH - 1 : 0] S_S_accumulationReg;

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_S_accumulation <= 0;
    else if(I_PELFinish)
        S_S_accumulation <= 0;
    else if(I_PELReplicaClk)
        S_S_accumulation <= S_S_accumulation + I_S_postCarrCodeMix_IQ;
    else
        S_S_accumulation <= S_S_accumulation;

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_S_accumulationReg <= 0;
    else if(I_PELFinish)
        S_S_accumulationReg <= S_S_accumulation;
    else
        S_S_accumulationReg <= S_S_accumulationReg;
    
assign O_S_accumulation   = S_S_accumulation;
assign O_S_accumulationReg= S_S_accumulationReg;

endmodule
