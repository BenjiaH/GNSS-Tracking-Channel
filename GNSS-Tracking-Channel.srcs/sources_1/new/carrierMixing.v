`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/17 15:39:28
// Design Name: 
// Module Name: carrierMixing
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

module carrierMixing
(
    input   wire                                                                I_sysClk,
    input   wire                                                                I_sysRst_n,
    input   wire signed [`C_S_FE_DATA_WIDTH - 1 : 0]                            I_S_FEInputData,
    input   wire                                                                I_FEInputDataValid,
    input   wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]                        I_S_carrSinReplica,
    input   wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]                        I_S_carrCosReplica,
    output  reg signed  [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   O_S_carrIData,
    output  reg signed  [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   O_S_carrQData
);

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n) begin
        O_S_carrIData <= 0;
        O_S_carrQData <= 0;
    end
    else if(!I_FEInputDataValid) begin
        O_S_carrIData <= O_S_carrIData;
        O_S_carrQData <= O_S_carrQData;
    end
    else begin
        O_S_carrIData <= I_S_FEInputData * I_S_carrCosReplica;
        O_S_carrQData <= I_S_FEInputData * I_S_carrSinReplica;
    end

endmodule
