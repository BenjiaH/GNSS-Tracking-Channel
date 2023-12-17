`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/19 23:04:35
// Design Name: 
// Module Name: PELCodeGen
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

module PELCodeGen
(
    input   wire            I_sysClk,
    input   wire            I_sysRst_n,
    input   wire            I_codeReplicaClk,
    input   wire    [0 : 0] I_codeReplica,
    input   wire            I_codeFinish,
    output  wire    [2 : 0] O_PELReplica,
    output  wire    [2 : 0] O_PELReplicaClk,
    output  wire    [2 : 0] O_PELFinish
);

// Parameter 
parameter integer   C_CODE_DELAY_REG_WIDTH  = `C_CODE_DELAY_REG_WIDTH,
                    C_CODE_DELAY_MID_POINT  = `C_CODE_DELAY_MID_POINT,
                    C_ONE_CHIP_SPACING      = `C_ONE_CHIP_SPACING,
                    C_CODE_DELAY_CNT_MAX    = `C_CODE_DELAY_CNT_MAX,
                    C_CODE_DELAY_CNT_WIDTH  = (C_CODE_DELAY_CNT_MAX == 1) ? 1 : $clog2(C_CODE_DELAY_CNT_MAX);

parameter   ST_IDEL     = 5'b00001,
            ST_FINISH   = 5'b00010,
            ST_EARLY    = 5'b00100,
            ST_PROMPT   = 5'b01000,
            ST_LATE     = 5'b10000;

// Internal signals
wire    [0 : 0]                             S_promptCode;
wire    [0 : 0]                             S_earlyCode;
wire    [0 : 0]                             S_lateCode;
wire                                        S_promptCodeClk;
wire                                        S_earlyCodeClk;
wire                                        S_lateCodeClk;
wire                                        S_promptFinish;
wire                                        S_earlyFinish;
wire                                        S_lateFinish;
reg     [C_CODE_DELAY_REG_WIDTH - 1 : 0]    S_codeDelayReg;
reg     [C_CODE_DELAY_CNT_WIDTH - 1 : 0]    S_codeDelayCnt;
reg     [4 : 0]                             S_currentState;
reg     [4 : 0]                             S_nextState;

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_codeDelayReg <= 0;
    else
        S_codeDelayReg <= {S_codeDelayReg[C_CODE_DELAY_REG_WIDTH - 2 : 0], I_codeReplica};

always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_codeDelayCnt <= 0;
    // else if(S_codeDelayCnt == C_CODE_DELAY_CNT_MAX - 1)
    //     S_codeDelayCnt <= 0;
    else if(I_codeReplicaClk)
        S_codeDelayCnt <= 0;
    else
        S_codeDelayCnt <= S_codeDelayCnt + 1;

// FSM for generating prompt, early and late finish signal
always @(posedge I_sysClk or negedge I_sysRst_n)
    if(!I_sysRst_n)
        S_currentState <= ST_IDEL;
    else
        S_currentState <= S_nextState;

always @(*)
    if(!I_sysRst_n)
        S_nextState = ST_IDEL;
    else
        case(S_currentState)
            ST_IDEL:
                if(I_codeFinish)
                    S_nextState = ST_FINISH;
                else
                    S_nextState = ST_IDEL;
            ST_FINISH:
                if(S_codeDelayCnt == C_CODE_DELAY_CNT_MAX - C_CODE_DELAY_MID_POINT - C_ONE_CHIP_SPACING)
                    S_nextState = ST_EARLY;
                else if(S_codeDelayCnt == C_CODE_DELAY_CNT_MAX - C_CODE_DELAY_MID_POINT)
                    S_nextState = ST_PROMPT;
                else if(S_codeDelayCnt == C_CODE_DELAY_CNT_MAX - C_CODE_DELAY_MID_POINT + C_ONE_CHIP_SPACING)
                    S_nextState = ST_LATE;
                else
                    S_nextState = ST_FINISH;
            ST_EARLY:
                S_nextState = ST_FINISH;
            ST_PROMPT:
                S_nextState = ST_FINISH;
            ST_LATE:
                S_nextState = ST_IDEL;
            default:
                S_nextState = ST_IDEL;
        endcase

assign S_promptCode = S_codeDelayReg[C_CODE_DELAY_MID_POINT];
assign S_earlyCode = S_codeDelayReg[C_CODE_DELAY_MID_POINT - C_ONE_CHIP_SPACING];
assign S_lateCode = S_codeDelayReg[C_CODE_DELAY_MID_POINT + C_ONE_CHIP_SPACING];
assign S_promptCodeClk = (S_codeDelayCnt == C_CODE_DELAY_CNT_MAX - C_CODE_DELAY_MID_POINT + 1) ? 1'b1 : 1'b0;
assign S_earlyCodeClk = (S_codeDelayCnt == C_CODE_DELAY_CNT_MAX - C_CODE_DELAY_MID_POINT - C_ONE_CHIP_SPACING + 1) ? 1'b1 : 1'b0;
assign S_lateCodeClk = (S_codeDelayCnt == C_CODE_DELAY_CNT_MAX - C_CODE_DELAY_MID_POINT + C_ONE_CHIP_SPACING + 1) ? 1'b1 : 1'b0;
assign S_promptFinish = (S_currentState == ST_PROMPT) ? 1'b1 : 1'b0;
assign S_earlyFinish = (S_currentState == ST_EARLY) ? 1'b1 : 1'b0;
assign S_lateFinish = (S_currentState == ST_LATE) ? 1'b1 : 1'b0;
assign O_PELReplica = {S_promptCode, S_earlyCode, S_lateCode};
assign O_PELReplicaClk = {S_promptCodeClk, S_earlyCodeClk, S_lateCodeClk};
assign O_PELFinish = {S_promptFinish, S_earlyFinish, S_lateFinish};

endmodule
