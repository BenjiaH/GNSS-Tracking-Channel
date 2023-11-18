`timescale 1ps / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 21:44:37
// Design Name: 
// Module Name: tb_NCO
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

module tb_NCO();

parameter C_CARR_OUTPUT_WIDTH = `C_NCO_PHASE_WIDTH;
parameter C_CODE_OUTPUT_WIDTH = `C_S_CARR_OUTPUT_WIDTH;
parameter C_CODE_PHASE_OUTPUT_WIDTH = `C_NCO_PHASE_WIDTH;

// Input/Output
reg                                         tb_I_sysClk;
reg                                         tb_I_sysRst_n;
reg         [`C_NCO_PHASE_WIDTH - 1 : 0]        tb_I_FSWCarr;
reg         [`C_NCO_PHASE_WIDTH - 1 : 0]        tb_I_FSWCode;

wire        [C_CARR_OUTPUT_WIDTH - 1 : 0]       tb_O_carrGen;
wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]    tb_O_S_carrSinReplica;
wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]    tb_O_S_carrCosReplica;

wire        [C_CODE_PHASE_OUTPUT_WIDTH - 1 : 0] tb_O_codeGen;
wire        [C_CODE_OUTPUT_WIDTH - 1 : 0]       tb_O_codeGenSin;
wire        [C_CODE_OUTPUT_WIDTH - 1 : 0]       tb_O_codeGenCos;

always #`C_SYS_CLK_HALF_PERIOD tb_I_sysClk = ~tb_I_sysClk;  //200Mhz

initial begin
    tb_I_sysClk <= 1'b1;
    tb_I_sysRst_n <= 1'b0;
    tb_I_FSWCarr <= `C_CARR_NCO_INCR;
    tb_I_FSWCode <= `C_CODE_NCO_INCR;
    
    #(`C_SYS_CLK_HALF_PERIOD * 2 + 2000)
    tb_I_sysRst_n <= 1'b1;

end

NCO
#(
    .C_NCO_MODE ("PA and LUT")
)
DUT_NCO_CARR_GEN_0
(
    .I_sysClk   (tb_I_sysClk),
    .I_sysRst_n (tb_I_sysRst_n),
    .I_FSW      (tb_I_FSWCarr),
    .O_phase    (tb_O_carrGen),
    .O_S_sin    (tb_O_S_carrSinReplica),
    .O_S_cos    (tb_O_S_carrCosReplica)
);

NCO
#(
    .C_NCO_MODE ("PA only")
)
DUT_NCO_CODE_GEN_0
(
    .I_sysClk   (tb_I_sysClk),
    .I_sysRst_n (tb_I_sysRst_n),
    .I_FSW      (tb_I_FSWCode),
    .O_phase    (tb_O_codeGen),
    .O_S_sin    (tb_O_codeGenSin),
    .O_S_cos    (tb_O_codeGenCos)
);


endmodule
