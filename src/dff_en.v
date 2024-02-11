/*
 * Copyright (c) 2023 Iron Violet LLC
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

//============================================================================//
// Gate Level DFF w/ Enable
//============================================================================//
module dff_en (
    // inputs
    input  wire clk,   // clock
    input  wire rst_n, // active-low reset
    input  wire en,    // enable
    input  wire d,     // data in
    // outputs
    output reg  q,     // data out
    output reg  q_bar  // data out, inverted
);
    // mux wires
    wire d_mux;
  
    // internal wires
    wire w_nand_0;
    wire w_nand_1;
    wire w_nand_2;
    wire w_nand_3;

    // gates
    mux  mux_0  (.a (q), .b (d), .s (en), .y (d_mux));

    nand nand_0 (w_nand_0, w_nand_3, w_nand_1);
    nand nand_1 (w_nand_1, w_nand_0, rst_n, clk);
    nand nand_2 (w_nand_2, w_nand_1, clk, w_nand_3);
    nand nand_3 (w_nand_3, w_nand_2, d_mux, rst_n);
    nand nand_4 (q, w_nand_1, q_bar);   
    nand nand_5 (q_bar, q, w_nand_2, rst_n);     

endmodule
