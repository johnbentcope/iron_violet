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
    wire d_en;
    wire d_int;
  
    // internal wires
    wire w_nand_0;
    wire w_nand_1;
    wire w_nand_2;
    wire w_nand_3;

    // gates
    mux  mux_en  (.a (1'b0), .b (d), .s (rst_n), .y (d_int));    
    mux  mux_en  (.a (q), .b (d_int), .s (en), .y (d_en));
    

    nand nand_0 (w_nand_0, w_nand_3, w_nand_1);
    nand nand_1 (w_nand_1, w_nand_0, rst_n, clk);
    nand nand_2 (w_nand_2, w_nand_1, clk, w_nand_3);
    nand nand_3 (w_nand_3, w_nand_2, d_int);
    nand nand_4 (q, w_nand_1, q_bar);   
    nand nand_5 (q_bar, q, w_nand_2);     

endmodule
