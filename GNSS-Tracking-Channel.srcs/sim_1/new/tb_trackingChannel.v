`timescale 1ps / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 14:42:11
// Design Name: 
// Module Name: tb_trackingChannel
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

module tb_trackingChannel();

// Input signals
reg                                         tb_I_sysClk;
reg                                         tb_I_sysRst_n;
reg signed  [`C_S_FE_DATA_WIDTH - 1 : 0]    tb_I_S_FEInputData;
// Output signals
wire                                        tb_O_sysClk;

// Internal signals for read file
integer                                     tb_S_dataFile    ; // file handler
integer                                     tb_S_scanFile    ; // file handler
reg signed  [`C_S_FE_DATA_WIDTH - 1 : 0]    tb_S_S_capturedData;
reg                                         tb_S_FEInputDataValid;

integer i;

always #`C_SYS_CLK_HALF_PERIOD tb_I_sysClk = ~tb_I_sysClk;  //99.375Mhz
// always #`C_SYS_CLK_HALF_PERIOD tb_I_NCOClk = ~tb_I_NCOClk;  //200Mhz

initial begin
    $display("*******************************************");
    $display("********** GNSS Tracking Channel **********");
    $display("*******************************************");
    $display("\nSimulation start...\n\n");
    
    tb_I_sysClk <= 1'b1;
    tb_I_sysRst_n <= 1'b0;
    tb_I_S_FEInputData <= 0;
    
    #(`C_SYS_CLK_HALF_PERIOD * 2 + `C_SIM_TIME_1NS * 2)
    tb_I_sysRst_n <= 1'b1;
    
    #(`C_SIM_TIME_1US * 3)
    $display();
    $display("Time: %7.3f ms", $time / `C_SIM_TIME_MS_TO_PS);
    trackingChannel_inst.getAccumulationValue();

    for(i = 0; i < `C_FE_DATA_DURATION_MS; i = i + 1) begin
        #(`C_SIM_TIME_1MS)
        $display();
        if($time > `C_SIM_RUN_ALL_MS * `C_SIM_TIME_MS_TO_PS) begin
            $display("Reached maximum simulation time %7.3f ms!", `C_SIM_RUN_ALL_MS);
            // $stop;
        end
        $display("Time: %7.3f ms", $time / `C_SIM_TIME_MS_TO_PS);
        trackingChannel_inst.getAccumulationValue();
    end

    $display("\n\nReached the end of the simulation file!");
    $display("Simulation finished!\n\n");
    $stop;
end

trackingChannel trackingChannel_inst
(
    .I_sysClk                   (tb_I_sysClk),
    .I_sysRst_n                 (tb_I_sysRst_n),
    .I_S_FEInputData            (tb_I_S_FEInputData),
    .I_FEInputDataValid         (tb_S_FEInputDataValid),
    .O_sysClk                   (tb_O_sysClk)
);

// ****************Read Frond-end data file****************
initial begin
    tb_S_dataFile = $fopen(`C_FE_DATA_NAME, "r");
    if (tb_S_dataFile == `C_NULL) begin
        $display("ERROR: tb_S_dataFile handle '%s' was NULL", `C_FE_DATA_NAME);
        $finish;
    end
    end

always @(posedge tb_I_sysClk or negedge tb_I_sysRst_n)
    if(!tb_I_sysRst_n)
        tb_S_scanFile = `C_NULL;
    else
        tb_S_scanFile = $fscanf(tb_S_dataFile, "%d\n", tb_S_S_capturedData); 

always @(negedge tb_I_sysRst_n)
    if(!tb_I_sysRst_n)
        tb_S_S_capturedData <= 0;
    else
        tb_S_S_capturedData <= tb_S_S_capturedData;

always @(posedge tb_I_sysClk or negedge tb_I_sysRst_n)
    if(!tb_I_sysRst_n)
        tb_I_S_FEInputData <= 0;
    else if (!$feof(tb_S_dataFile))
        //use tb_S_S_capturedData as you would any other wire or reg value;
        tb_I_S_FEInputData <= tb_S_S_capturedData;
    else
        tb_I_S_FEInputData <= tb_I_S_FEInputData;

always @(posedge tb_I_sysClk or negedge tb_I_sysRst_n)
    if(!tb_I_sysRst_n)
        tb_S_FEInputDataValid <= 0;
    else if (!$feof(tb_S_dataFile))
        tb_S_FEInputDataValid <= 1;
    else if ($feof(tb_S_dataFile))
        tb_S_FEInputDataValid <= 0;
    else
        tb_S_FEInputDataValid <= tb_S_FEInputDataValid;
// ****************EOF Read Frond-end data file****************

endmodule
