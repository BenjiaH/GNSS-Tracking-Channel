`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/31 22:18:46
// Design Name: 
// Module Name: carrierGen
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

module carrierGen
(
    input   wire                                            I_sysClk,
    input   wire                                            I_sysRst_n,
    input   wire        [`C_NCO_PHASE_WIDTH - 1 : 0]        I_FSW,

    output  wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]    O_S_carrSinReplica,
    output  wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]    O_S_carrCosReplica
);

// Internal signals
wire    [`C_NCO_PHASE_WIDTH - 1 : 0]    S_carrGen;  // Not used

NCO
#(
    .C_NCO_MODE (`C_CARR_GEN_MODE)
)
U0_NCO_carrGen
(
    .I_sysClk   (I_sysClk),
    .I_sysRst_n (I_sysRst_n),
    .I_FSW      (I_FSW),
    .O_phase    (S_carrGen),
    .O_S_sin    (O_S_carrSinReplica),
    .O_S_cos    (O_S_carrCosReplica)
);


endmodule
