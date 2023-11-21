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
    input   wire        [0 : 0]                                                 I_codePELReplica,
    input   wire                                                                I_codeReplicaClk,
    input   wire                                                                I_codeFinish,
    input   wire signed [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   I_S_carrMix_IQ
    // input   wire signed [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   I_S_carrMix_Q
);

// Internal signals
reg signed  [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   S_S_postCarrCodeMix_IQ;
// reg signed  [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   O_S_postCarrCodeMix_Q;


always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_S_postCarrCodeMix_IQ <= 0;
    else if(I_codePELReplica == 1'b1) 
        S_S_postCarrCodeMix_IQ <= I_S_carrMix_IQ;
    else 
        S_S_postCarrCodeMix_IQ <= -I_S_carrMix_IQ;

accumulator U_accumulator_0
(
    .I_sysClk               (I_sysClk),
    .I_sysRst_n             (I_sysRst_n),
    .I_codeReplicaClk       (I_codeReplicaClk),
    .I_codeFinish           (I_codeFinish),
    .I_S_postCarrCodeMix_IQ (S_S_postCarrCodeMix_IQ)
    // .O_S_accmP          (O_S_accmP)
);


endmodule
