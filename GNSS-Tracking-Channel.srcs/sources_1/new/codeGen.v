`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/31 22:18:02
// Design Name: 
// Module Name: codeGen
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

module codeGen
#(
    parameter C_CODE_PATH    = `C_CODE_PRN2_PATH   // C_CODE_PRN_NO    = `C_CODE_PRNx
)
(
    input   wire                                            I_sysClk,
    input   wire                                            I_sysRst_n,
    input   wire    [`C_NCO_PHASE_WIDTH - 1 : 0]            I_FSW,
    output  reg                                             O_codeReplicaClk_d,
    output  wire                                            O_codeFinish,
    output  reg     [`C_CODE_WORD_SIZE - 1 : 0]             O_codeWord,
    output  reg     [0 : 0]                                 O_codeReplica
);

// Parameters
parameter integer C_CODE_REPLICA_COUNTER_WIDTH = $ceil((`C_CODE_WORD_SIZE == 1) ? 1 : $clog2(`C_CODE_WORD_SIZE)),   // 5
                  C_CODE_REPLICA_COUNTER_MAX   = `C_CODE_WORD_SIZE - 1,                                             // 31
                  C_CODE_WORD_COUNTER_WIDTH    = $ceil((`C_CODE_ROM_DEPTH == 1) ? 1 : $clog2(`C_CODE_ROM_DEPTH)),   // 5
                  C_CODE_WORD_COUNTER_MAX      = `C_CODE_ROM_DEPTH - 1;                                             // 31

// Internal signals
wire    [`C_NCO_PHASE_WIDTH - 1 : 0]            S_codeGen;
wire    [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]        S_codeGenSin;   // Not used
wire    [`C_S_CARR_OUTPUT_WIDTH - 1 : 0]        S_codeGenCos;   // Not used
reg                                             S_codeReplicaClk;
reg     [C_CODE_REPLICA_COUNTER_WIDTH - 1 : 0]  S_codeReplicaCounter;
reg     [C_CODE_REPLICA_COUNTER_WIDTH - 1 : 0]  S_codeReplicaCounter_d;
reg                                             S_codeWordClk;
reg     [C_CODE_WORD_COUNTER_WIDTH - 1 : 0]     S_codeWordCounter;
reg                                             S_codeWordCounterMaxFlag;
reg                                             S_codeWordCounterMaxFlag_d1;
// wire    [`C_CODE_WORD_SIZE - 1 : 0]             S_codeWord;
// wire    [0 : 0]                                 S_codeReplica;
reg     [`C_CODE_ROM_WIDTH - 1 : 0]             S_CAcode  [`C_CODE_ROM_DEPTH - 1 : 0];

initial begin 
    $readmemh(C_CODE_PATH, S_CAcode);
end

NCO
#(
    .C_NCO_MODE (`C_CODE_GEN_MODE)
)
U1_NCO_codePhaseGen
(
    .I_sysClk   (I_sysClk),
    .I_sysRst_n (I_sysRst_n),
    .I_FSW      (I_FSW),
    .O_phase    (S_codeGen),
    .O_S_sin    (S_codeGenSin),
    .O_S_cos    (S_codeGenCos)
);

// Generate code replica clock
always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_codeReplicaClk <= 1'b0;
    else if(S_codeGen > (`C_CODE_REG_MAX - I_FSW))
        S_codeReplicaClk <= 1'b1;
    else
        S_codeReplicaClk <= 1'b0;

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        O_codeReplicaClk_d <= 0;
    else
        O_codeReplicaClk_d <= S_codeReplicaClk;

// Generate code replica counter
always @(posedge S_codeReplicaClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_codeReplicaCounter <= 0;
    else if(S_codeReplicaCounter == C_CODE_REPLICA_COUNTER_MAX)
        S_codeReplicaCounter <= 0;
    else
        S_codeReplicaCounter <= S_codeReplicaCounter + 1;

// Generate code word clock
always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_codeReplicaCounter_d <= 0;
    else
        S_codeReplicaCounter_d <= S_codeReplicaCounter;

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_codeWordClk <= 1'b0;
    else if(S_codeReplicaCounter == 0 && S_codeReplicaCounter_d == C_CODE_REPLICA_COUNTER_MAX)
        S_codeWordClk <= 1'b1;
    else
        S_codeWordClk <= 1'b0;

// Generate code word counter
always @(posedge S_codeWordClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_codeWordCounter <= 0;
    else if(S_codeWordCounter == C_CODE_WORD_COUNTER_MAX)
        S_codeWordCounter <= 0;
    else
        S_codeWordCounter <= S_codeWordCounter + 1;

// Generate code finish flag signal and PPS_1ms signal
always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_codeWordCounterMaxFlag <= 0;
    else if(S_codeWordCounter == C_CODE_WORD_COUNTER_MAX)
        S_codeWordCounterMaxFlag <= 1;
    else
        S_codeWordCounterMaxFlag <= 0;

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_codeWordCounterMaxFlag_d1 <= 1'b0;
    else
        S_codeWordCounterMaxFlag_d1 <= S_codeWordCounterMaxFlag;

assign O_codeFinish = (S_codeWordCounter == 0 && S_codeReplicaCounter_d == 0 && O_codeReplicaClk_d) ? 1'b1 : 1'b0;
// assign O_PPS1ms = O_codeFinish;

// Generate code word
always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        O_codeWord <= 0;
    else
        O_codeWord <= S_CAcode[S_codeWordCounter];

// Generate code replica
always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        O_codeReplica <= 0;
    else
        O_codeReplica <= S_CAcode[S_codeWordCounter][S_codeReplicaCounter_d];

endmodule
