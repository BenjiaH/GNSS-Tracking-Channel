`timescale 1ps / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/31 22:56:10
// Design Name: 
// Module Name: tb_codeGen
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

module tb_codeGen();

// Input/Output
reg                                             tb_I_sysClk;
reg                                             tb_I_sysRst_n;
reg     [`C_NCO_PHASE_WIDTH - 1 : 0]            tb_I_FSWCode;
wire                                            tb_O_codeFinish;
wire    [`C_CODE_WORD_SIZE - 1 : 0]             tb_O_codeWord;
wire    [0 : 0]                                 tb_O_codeReplica;

// always #`C_SYS_CLK_HALF_PERIOD tb_I_NCOClk = ~tb_I_NCOClk;  //200Mhz
always #`C_SYS_CLK_HALF_PERIOD tb_I_sysClk = ~tb_I_sysClk;  //99.375Mhz

initial begin
    tb_I_sysClk <= 1'b1;
    tb_I_sysRst_n <= 1'b0;
    tb_I_FSWCode <= `C_CODE_NCO_INCR;
    
    #(`C_SYS_CLK_HALF_PERIOD * 2 + 2000)
    tb_I_sysRst_n <= 1'b1;

end

codeGen
#(
    .C_CODE_PATH    (`C_CODE_PRN2_PATH)
)
DUT_codeGen_RPN2_0
(
    .I_sysClk       (tb_I_sysClk),
    .I_sysRst_n     (tb_I_sysRst_n),
    .I_FSW          (tb_I_FSWCode),
    .O_codeFinish   (tb_O_codeFinish),
    .O_codeWord     (tb_O_codeWord),
    .O_codeReplica  (tb_O_codeReplica)
);

endmodule
