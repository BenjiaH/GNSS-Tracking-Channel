`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 10:22:07
// Design Name: 
// Module Name: trackingChannel
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

module trackingChannel
(
    input   wire                                        I_sysClk,
    input   wire                                        I_sysRst_n,
    input   wire signed [`C_S_FE_DATA_WIDTH - 1 : 0]    I_S_FEInputData,
    input   wire                                        I_FEInputDataValid,
    output  wire                                        O_sysClk
);

// Internal signals
// U0_carrierGen ...
wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]                        S_S_carrSinReplica;
wire signed [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]                        S_S_carrCosReplica;
// U0_codeGen_RPN2 ...
wire                                                                S_codeReplicaClk;
wire                                                                S_codeFinish;
wire        [`C_CODE_WORD_SIZE - 1 : 0]                             S_codeWord;
wire        [0 : 0]                                                 S_codeReplica;
// U0_carrierMixing ...
wire signed [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   S_S_carrMix_I;
wire signed [`C_S_FE_DATA_WIDTH + `C_S_CARR_OUTPUT_WIDTH - 1 : 0]   S_S_carrMix_Q;
// U0_PELCodeGen ...
wire        [2 : 0]                                                 S_PELReplica;
wire        [2 : 0]                                                 S_PELReplicaClk;
wire        [2 : 0]                                                 S_PELFinish;
// U0_correlator_I_P ...
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulation_I_P;
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulationReg_I_P;
// U1_correlator_Q_P ...
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulation_Q_P;
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulationReg_Q_P;
// U2_correlator_I_E ...
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulation_I_E;
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulationReg_I_E;
// U3_correlator_Q_E ...
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulation_Q_E;
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulationReg_Q_E;
// U4_correlator_I_L ...
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulation_I_L;
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulationReg_I_L;
// U5_correlator_Q_L ...
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulation_Q_L;
wire signed [`C_ACCM_WIDTH - 1 : 0]                                 S_S_accumulationReg_Q_L;

// Output
wire signed [2 * `C_ACCM_WIDTH : 0]                                 S_S_accumulation_P;
wire signed [2 * `C_ACCM_WIDTH : 0]                                 S_S_accumulation_E;
wire signed [2 * `C_ACCM_WIDTH : 0]                                 S_S_accumulation_L;

assign  S_S_accumulation_P = S_S_accumulationReg_I_P * S_S_accumulationReg_I_P + S_S_accumulationReg_Q_P * S_S_accumulationReg_Q_P;
assign  S_S_accumulation_E = S_S_accumulationReg_I_E * S_S_accumulationReg_I_E + S_S_accumulationReg_Q_E * S_S_accumulationReg_Q_E;
assign  S_S_accumulation_L = S_S_accumulationReg_I_L * S_S_accumulationReg_I_L + S_S_accumulationReg_Q_L * S_S_accumulationReg_Q_L;
assign  O_sysClk = I_sysClk;

// User task
// Variable for user task
integer                                                             S_accum_P_fileHandler,
S_accum_E_fileHandler,
S_accum_L_fileHandler;
integer                                                             errNO;
reg         [320 : 0]                                               errMsg;

task createFile(); begin
    S_accum_P_fileHandler = $fopen("accumulation_P.dat", "w");
    errNO = $ferror(S_accum_P_fileHandler, errMsg);
    if (S_accum_P_fileHandler == 0) begin
        $display("Error: (%h)%s", errNO, errMsg);
        $stop;
    end
    S_accum_E_fileHandler = $fopen("accumulation_E.dat", "w");
    errNO = $ferror(S_accum_P_fileHandler, errMsg);
    if (S_accum_E_fileHandler == 0) begin
        $display("Error: (%h)%s", errNO, errMsg);
        $stop;
    end
    S_accum_L_fileHandler = $fopen("accumulation_L.dat", "w");
    errNO = $ferror(S_accum_P_fileHandler, errMsg);
    if (S_accum_L_fileHandler == 0) begin
        $display("Error: (%h)%s", errNO, errMsg);
        $stop;
    end
end
endtask

task openFile(); begin
    S_accum_P_fileHandler = $fopen("accumulation_P.dat", "a");
    errNO = $ferror(S_accum_P_fileHandler, errMsg);
    if (S_accum_P_fileHandler == 0) begin
        $display("\nError: (%h)%s\n", errNO, errMsg);
        $stop;
    end
    S_accum_E_fileHandler = $fopen("accumulation_E.dat", "a");
    errNO = $ferror(S_accum_P_fileHandler, errMsg);
    if (S_accum_E_fileHandler == 0) begin
        $display("\nError: (%h)%s\n", errNO, errMsg);
        $stop;
    end
    S_accum_L_fileHandler = $fopen("accumulation_L.dat", "a");
    errNO = $ferror(S_accum_P_fileHandler, errMsg);
    if (S_accum_L_fileHandler == 0) begin
        $display("\nError: (%h)%s\n", errNO, errMsg);
        $stop;
    end
end
endtask

task closeFile(); begin
    $fclose(S_accum_P_fileHandler);
    $fclose(S_accum_E_fileHandler);
    $fclose(S_accum_L_fileHandler);
end
endtask

task getAndSaveAccumulationValue(); begin
    $display("O_S_accumulation_P: %d", S_S_accumulation_P);
    $display("O_S_accumulation_E: %d", S_S_accumulation_E);
    $display("O_S_accumulation_L: %d", S_S_accumulation_L);
    $fwrite(S_accum_P_fileHandler, "%-6d\n", S_S_accumulation_P);
    $fwrite(S_accum_E_fileHandler, "%-6d\n", S_S_accumulation_E);
    $fwrite(S_accum_L_fileHandler, "%-6d\n", S_S_accumulation_L);
end
endtask

carrierGen  U0_carrierGen
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_FSW              (`C_CARR_NCO_INCR),
    .O_S_carrSinReplica (S_S_carrSinReplica),
    .O_S_carrCosReplica (S_S_carrCosReplica)
);

codeGen
#(
    .C_CODE_PATH            (`C_CODE_PRN2_PATH)
)
U0_codeGen_RPN2
(
    .I_sysClk               (I_sysClk),
    .I_sysRst_n             (I_sysRst_n),
    .I_FSW                  (`C_CODE_NCO_INCR),
    .O_codeReplicaClk_d     (S_codeReplicaClk),
    .O_codeFinish           (S_codeFinish),
    .O_codeWord             (S_codeWord),
    .O_codeReplica          (S_codeReplica)
);

carrierMixing   U0_carrierMixing
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_S_FEInputData    (I_S_FEInputData),
    .I_FEInputDataValid (I_FEInputDataValid),
    .I_S_carrSinReplica (S_S_carrSinReplica),
    .I_S_carrCosReplica (S_S_carrCosReplica),
    .O_S_carrMix_I      (S_S_carrMix_I),
    .O_S_carrMix_Q      (S_S_carrMix_Q)
);

PELCodeGen  U0_PELCodeGen
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_codeReplicaClk   (S_codeReplicaClk),
    .I_codeReplica      (S_codeReplica),
    .I_codeFinish       (S_codeFinish),
    .O_PELReplica       (S_PELReplica),
    .O_PELReplicaClk    (S_PELReplicaClk),
    .O_PELFinish        (S_PELFinish)
);

correlator  U0_correlator_I_P
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_PELReplica       (S_PELReplica[2]),
    .I_PELReplicaClk    (S_PELReplicaClk[2]),
    .I_PELFinish        (S_PELFinish[2]),
    .I_S_carrMix_IQ     (S_S_carrMix_I),
    .O_S_accumulation   (S_S_accumulation_I_P),
    .O_S_accumulationReg(S_S_accumulationReg_I_P)
);

correlator  U1_correlator_Q_P
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_PELReplica       (S_PELReplica[2]),
    .I_PELReplicaClk    (S_PELReplicaClk[2]),
    .I_PELFinish        (S_PELFinish[2]),
    .I_S_carrMix_IQ     (S_S_carrMix_Q),
    .O_S_accumulation   (S_S_accumulation_Q_P),
    .O_S_accumulationReg(S_S_accumulationReg_Q_P)
);

correlator  U2_correlator_I_E
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_PELReplica       (S_PELReplica[1]),
    .I_PELReplicaClk    (S_PELReplicaClk[1]),
    .I_PELFinish        (S_PELFinish[1]),
    .I_S_carrMix_IQ     (S_S_carrMix_I),
    .O_S_accumulation   (S_S_accumulation_I_E),
    .O_S_accumulationReg(S_S_accumulationReg_I_E)
);

correlator  U3_correlator_Q_E
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_PELReplica       (S_PELReplica[1]),
    .I_PELReplicaClk    (S_PELReplicaClk[1]),
    .I_PELFinish        (S_PELFinish[1]),
    .I_S_carrMix_IQ     (S_S_carrMix_Q),
    .O_S_accumulation   (S_S_accumulation_Q_E),
    .O_S_accumulationReg(S_S_accumulationReg_Q_E)
);

correlator  U4_correlator_I_L
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_PELReplica       (S_PELReplica[0]),
    .I_PELReplicaClk    (S_PELReplicaClk[0]),
    .I_PELFinish        (S_PELFinish[0]),
    .I_S_carrMix_IQ     (S_S_carrMix_I),
    .O_S_accumulation   (S_S_accumulation_I_L),
    .O_S_accumulationReg(S_S_accumulationReg_I_L)
);

correlator  U5_correlator_Q_L
(
    .I_sysClk           (I_sysClk),
    .I_sysRst_n         (I_sysRst_n),
    .I_PELReplica       (S_PELReplica[0]),
    .I_PELReplicaClk    (S_PELReplicaClk[0]),
    .I_PELFinish        (S_PELFinish[0]),
    .I_S_carrMix_IQ     (S_S_carrMix_Q),
    .O_S_accumulation   (S_S_accumulation_Q_L),
    .O_S_accumulationReg(S_S_accumulationReg_Q_L)
);

endmodule
