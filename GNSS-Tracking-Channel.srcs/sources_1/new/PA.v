`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 21:20:26
// Design Name: 
// Module Name: PA
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

module PA
// #(
//     parameter C_PA_OUTPUT_WIDTH = 2
// )
(
    input   wire                                    I_sysClk,
    input   wire                                    I_sysRst_n,
    input   wire    [`C_NCO_PHASE_WIDTH - 1 : 0]    I_FSW,
    output  reg     [`C_NCO_PHASE_WIDTH - 1 : 0]    O_phase
);

//Internal signals
reg     [`C_NCO_PHASE_WIDTH - 1 : 0]     S_counter;

always @(posedge I_sysClk or negedge I_sysRst_n) 
    if(~I_sysRst_n) 
        S_counter <= 0;
    // else if(S_counter == `C_REG_MAX)
    //     S_counter <= 0;
    else
        S_counter <= S_counter + I_FSW;

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(~I_sysRst_n)
        O_phase <= 0;
    else
        O_phase <= S_counter;


endmodule
