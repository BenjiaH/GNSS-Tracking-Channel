`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 21:06:02
// Design Name: 
// Module Name: NCO
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

module NCO
#(
    parameter C_NCO_MODE    = "PA and LUT" // "PA and LUT" or "PA only" 
)
(
    input   wire                                            I_sysClk,
    input   wire                                            I_sysRst_n,
    input   wire        [`C_NCO_PHASE_WIDTH - 1 : 0]        I_FSW,
    output  wire        [`C_NCO_PHASE_WIDTH - 1 : 0]        O_phase,
    output  wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]    O_S_sin,
    output  wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]    O_S_cos
);

// Internal signals
wire    [`C_NCO_PHASE_WIDTH - 1 : 0]    S_phaseFromPA;
wire    [`C_NCO_PHASE_WIDTH - 1 : 0]    S_phaseT;

assign S_phaseT = 0;

PA  U0_PA
(
    .I_sysClk   (I_sysClk),
    .I_sysRst_n (I_sysRst_n),
    .I_FSW      (I_FSW),
    .O_phase    (S_phaseFromPA)
);

generate
    case (C_NCO_MODE)
        "PA and LUT": begin
            PAC U0_PAC
            (
                .I_sysClk   (I_sysClk),
                .I_sysRst_n (I_sysRst_n),
                .I_phase    (S_phaseFromPA),
                .O_phase    (O_phase),
                .O_S_sin    (O_S_sin),
                .O_S_cos    (O_S_cos)
            );
        end
        "PA only": begin
            assign O_phase = S_phaseFromPA;
            assign O_S_sin = 0;
            assign O_S_cos = 0;
        end
        default: begin
            // assign O_phase = 0;
            PAC U1_PAC
            (
                .I_sysClk   (I_sysClk),
                .I_sysRst_n (I_sysRst_n),
                .I_phase    (S_phaseFromPA),
                .O_phase    (S_phaseT),
                .O_S_sin    (O_S_sin),
                .O_S_cos    (O_S_cos)
            );
        end
    endcase
endgenerate


endmodule
