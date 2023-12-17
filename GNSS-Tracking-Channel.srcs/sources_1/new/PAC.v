`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 21:20:26
// Design Name: 
// Module Name: PAC
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

module PAC
(
    input   wire                                            I_sysClk,
    input   wire                                            I_sysRst_n,
    input   wire        [`C_NCO_PHASE_WIDTH - 1 : 0]        I_phase,
    output  wire        [`C_NCO_PHASE_WIDTH - 1 : 0]        O_phase,
    output  reg signed  [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]    O_S_sin,
    output  reg signed  [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]    O_S_cos
);


// Internal signals
wire        [`C_PHASE_HEADER_LENGTH - 1 : 0]    S_phaseCut                                ;
reg signed  [`C_SIN_COS_LUT_WIDTH - 1 : 0]      S_S_SinLUT  [`C_SIN_COS_LUT_DEPTH - 1 : 0];
reg signed  [`C_SIN_COS_LUT_WIDTH - 1 : 0]      S_S_CosLUT  [`C_SIN_COS_LUT_DEPTH - 1 : 0];

assign S_phaseCut   = I_phase[`C_NCO_PHASE_WIDTH - 1 -: `C_PHASE_HEADER_LENGTH];
assign O_phase      = I_phase;

initial begin 
    $readmemh(`C_SIN_LUT_PATH, S_S_SinLUT);
    $readmemh(`C_COS_LUT_PATH, S_S_CosLUT);
end

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n) begin
        O_S_sin <= 0;
        O_S_cos <= 0;
    end
    else begin
        O_S_sin <= S_S_SinLUT[S_phaseCut][`C_S_CARR_OUTPUT_WIDTH - 1 : 0];
        O_S_cos <= S_S_CosLUT[S_phaseCut][`C_S_CARR_OUTPUT_WIDTH - 1 : 0];
    end


endmodule
