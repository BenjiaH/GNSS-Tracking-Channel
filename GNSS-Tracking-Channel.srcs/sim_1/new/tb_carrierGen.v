`timescale 1ps / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/31 22:24:03
// Design Name: 
// Module Name: tb_carrierGen
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

module tb_carrierGen();

// Input/Output
reg                                             tb_I_sysClk;
reg                                             tb_I_sysRst_n;
reg         [`C_NCO_PHASE_WIDTH - 1 : 0]        tb_I_FSWCarr;
wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]    tb_O_S_carrSinReplica;
wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]    tb_O_S_carrCosReplica;

always #`C_SYS_CLK_HALF_PERIOD tb_I_sysClk = ~tb_I_sysClk;  //200Mhz

initial begin
    tb_I_sysClk <= 1'b1;
    tb_I_sysRst_n <= 1'b0;
    tb_I_FSWCarr <= `C_CARR_NCO_INCR;
    
    #(`C_SYS_CLK_HALF_PERIOD * 2 + 2000)
    tb_I_sysRst_n <= 1'b1;

end

carrierGen  DUT_carrierGen_0
(
    .I_sysClk           (tb_I_sysClk),
    .I_sysRst_n         (tb_I_sysRst_n),
    .I_FSW              (tb_I_FSWCarr),
    .O_S_carrSinReplica (tb_O_S_carrSinReplica),
    .O_S_carrCosReplica (tb_O_S_carrCosReplica)
);

endmodule
