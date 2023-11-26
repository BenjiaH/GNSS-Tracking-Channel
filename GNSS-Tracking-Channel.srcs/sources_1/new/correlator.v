`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/20 14:40:57
// Design Name: 
// Module Name: correlator
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

module correlator
(
    input   wire                                                                I_sysClk,
    input   wire                                                                I_sysRst_n,
    input   wire        [0 : 0]                                                 I_PELReplica,
    input   wire                                                                I_PELReplicaClk,
    input   wire                                                                I_PELFinish,
    input   wire signed [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   I_S_carrMix_IQ,
    output  wire signed  [`C_ACCM_WIDTH - 1 : 0]                                O_S_accumulation,
    output  wire signed  [`C_ACCM_WIDTH - 1 : 0]                                O_S_accumulationReg
);

// Internal signals
reg signed  [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   S_S_postCarrCodeMix_IQ;

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_S_postCarrCodeMix_IQ <= 0;
    else if(I_PELReplica == 1'b1) 
        S_S_postCarrCodeMix_IQ <= I_S_carrMix_IQ;
    else 
        S_S_postCarrCodeMix_IQ <= -I_S_carrMix_IQ;

accumulator U0_accumulator
(
    .I_sysClk               (I_sysClk),
    .I_sysRst_n             (I_sysRst_n),
    .I_PELReplicaClk        (I_PELReplicaClk),
    .I_PELFinish            (I_PELFinish),
    .I_S_postCarrCodeMix_IQ (S_S_postCarrCodeMix_IQ),
    .O_S_accumulation       (O_S_accumulation),
    .O_S_accumulationReg    (O_S_accumulationReg)
);

endmodule
