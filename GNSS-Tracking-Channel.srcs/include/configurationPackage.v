// `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 16:46:06
// Design Name: 
// Module Name: configurationPackage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Configuration package for trackingChannel
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// INFO
// 1. System bus width: 32-bit

// General configuration
`define     C_NULL                      0
`define     C_REG_WIDTH                 32
`define     C_REG_MAX                   2 ** `C_REG_WIDTH - 1
`define     C_BYTE_WIDTH                8
`define     C_BYTE_MAX                  2 ** `C_BYTE_WIDTH - 1
`define     C_WORD_WIDTH                32
`define     C_WORD_MAX                  2 ** `C_WORD_WIDTH - 1

// Signal configuration
`define     C_SAMPLE_FREQ               99375000
`define     C_SAMPLE_PERIOD             10062.893
`define     C_SAMPLE_HALF_PERIOD        5031.446
`define     C_CODE_FREQ                 1023000
`define     C_SAMPLES_PER_1MS           `C_SAMPLE_FREQ / 1000
`define     C_MAX_INPUT_AMP             3
`define     C_MAX_CARR_AMP              2

// System clock configuration
`define     C_SYS_CLK_FREQ              `C_SAMPLE_FREQ
`define     C_SYS_CLK_PERIOD            `C_SAMPLE_PERIOD
`define     C_SYS_CLK_HALF_PERIOD       `C_SAMPLE_HALF_PERIOD

// Input data configuration
`define     C_S_FE_DATA_WIDTH           3   // 2 + 1
`define     C_FE_DATA_DURATION_MS       99

// Simulation configuration
`define     C_SIM_RUN_ALL_MS            20
`define     C_SIM_TIME_1NS              1000
`define     C_SIM_TIME_1US              1000 * `C_SIM_TIME_1NS
`define     C_SIM_TIME_1MS              1000 * `C_SIM_TIME_1US
`define     C_SIM_TIME_MS_TO_PS         1000000000
`define     C_FE_DATA_NAME              "FE_fs_99p375_MHz_skip_46250_time_100ms_int8.dat"

// NCO configuration
`define     C_NCO_PHASE_WIDTH           `C_REG_WIDTH

// NCO configuration for generating carrier@(14.58MHz + 2200Hz)
`define     C_CARR_GEN_MODE             "PA and LUT"
// `define     C_CARR_NCO_INCR             `C_NCO_PHASE_WIDTH'h777_5170 // 14.58MHz + 2200Hz
`define     C_CARR_NCO_INCR             `C_NCO_PHASE_WIDTH'h2590_B1E8 // 14.58MHz + 2200Hz
`define     C_PHASE_HEADER_LENGTH       3
`define     C_S_CARR_OUTPUT_WIDTH       3   // 2 + 1
`define     C_SIN_LUT_PATH              "sinLUT.dat"    // These two files are imported as memory files.
`define     C_COS_LUT_PATH              "cosLUT.dat"    // Therefore, the path should be relative to the simulation directory.
`define     C_SIN_COS_LUT_DEPTH         8
`define     C_SIN_COS_LUT_WIDTH         4

// NCO configuration for generating code@(1.023Mhz - 500Hz)
`define     C_CODE_GEN_MODE             "PA only"
`define     C_CODE_REG_MAX              `C_REG_MAX
// `define     C_CODE_NCO_INCR             `C_NCO_PHASE_WIDTH'h86_0568 // 1.023Mhz - 500Hz
`define     C_CODE_NCO_INCR             `C_NCO_PHASE_WIDTH'h02A2_51F3 // 1.023Mhz - 500Hz

// Code generator configuration
`define     C_CODE_WORD_SIZE            `C_WORD_WIDTH

// C/A Code ROM
`define     C_CODE_PRN1_PATH            "codePRN1.dat"  // These files are imported as memory file.
`define     C_CODE_PRN2_PATH            "codePRN2.dat"  // Therefore, the path should be relative to the simulation directory
`define     C_CODE_PRN3_PATH            "codePRN3.dat"
`define     C_CODE_PRN4_PATH            "codePRN4.dat"
`define     C_CODE_PRN5_PATH            "codePRN5.dat"
`define     C_CODE_PRN6_PATH            "codePRN6.dat"
`define     C_CODE_PRN7_PATH            "codePRN7.dat"
`define     C_CODE_PRN8_PATH            "codePRN8.dat"
`define     C_CODE_PRN9_PATH            "codePRN9.dat"
`define     C_CODE_PRN10_PATH           "codePRN10.dat"
`define     C_CODE_PRN11_PATH           "codePRN11.dat"
`define     C_CODE_PRN12_PATH           "codePRN12.dat"
`define     C_CODE_PRN13_PATH           "codePRN13.dat"
`define     C_CODE_PRN14_PATH           "codePRN14.dat"
`define     C_CODE_PRN15_PATH           "codePRN15.dat"
`define     C_CODE_PRN16_PATH           "codePRN16.dat"
`define     C_CODE_PRN17_PATH           "codePRN17.dat"
`define     C_CODE_PRN18_PATH           "codePRN18.dat"
`define     C_CODE_PRN19_PATH           "codePRN19.dat"
`define     C_CODE_PRN20_PATH           "codePRN20.dat"
`define     C_CODE_PRN21_PATH           "codePRN21.dat"
`define     C_CODE_PRN22_PATH           "codePRN22.dat"
`define     C_CODE_PRN23_PATH           "codePRN23.dat"
`define     C_CODE_PRN24_PATH           "codePRN24.dat"
`define     C_CODE_PRN25_PATH           "codePRN25.dat"
`define     C_CODE_PRN26_PATH           "codePRN26.dat"
`define     C_CODE_PRN27_PATH           "codePRN27.dat"
`define     C_CODE_PRN28_PATH           "codePRN28.dat"
`define     C_CODE_PRN29_PATH           "codePRN29.dat"
`define     C_CODE_PRN30_PATH           "codePRN30.dat"
`define     C_CODE_PRN31_PATH           "codePRN31.dat"
`define     C_CODE_PRN32_PATH           "codePRN32.dat"
`define     C_CODE_PRN33_PATH           "codePRN33.dat"
`define     C_CODE_PRN34_PATH           "codePRN34.dat"
`define     C_CODE_PRN35_PATH           "codePRN35.dat"
`define     C_CODE_PRN36_PATH           "codePRN36.dat"
`define     C_CODE_PRN37_PATH           "codePRN37.dat"
`define     C_CODE_ROM_DEPTH            32
`define     C_CODE_ROM_WIDTH            `C_WORD_WIDTH

// Prompt, early and late code generator configuration
`define     C_CODE_DELAY_REG_WIDTH      $ceil(`C_SAMPLE_FREQ / `C_CODE_FREQ)
`define     C_CODE_DELAY_MID_POINT      $ceil(`C_CODE_DELAY_REG_WIDTH / 2)
`define     C_ONE_CHIP_SPACING          $ceil(`C_CODE_DELAY_MID_POINT / 2)
`define     C_CODE_DELAY_CNT_MAX        `C_CODE_DELAY_REG_WIDTH

// Accumulator configuration
`define     C_ACCM_LEN_MS               1
`define     C_ACCM_MAX_VALUE            (`C_ACCM_LEN_MS * `C_SAMPLES_PER_1MS * `C_MAX_INPUT_AMP * `C_MAX_CARR_AMP)
`define     C_ACCM_WIDTH                $clog2(2 * `C_ACCM_MAX_VALUE)
