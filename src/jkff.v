/*
 * Copyright (c) 2023 Iron Violet LLC
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

//============================================================================//
// Gate Level JKFF (7 Gates!)
//============================================================================//
module jkff (
  // inputs
  input  wire clk,   // clock
  input  wire rst_n, // active-low reset
  input  wire j,     // j input
  input  wire k,     // k input
  // outputs
  output reg  q,     // q output
  output reg  q_bar  // inverted q output
);
  // wires
  wire w_nand_0;
  wire w_nand_1;
  wire w_nand_2;
  wire w_nand_3;  
  wire w_nand_4;
  wire w_nand_5;  
  wire w_nand_6;
  wire w_nand_7;             
  wire clk_n;

  not  not_clk (clk_n, clk);

  // master
  nand nand_0  (w_nand_0, j, clk_n, q_bar);
  nand nand_1  (w_nand_1, k, clk_n, q);
  nand nand_2  (w_nand_2, w_nand_0, w_nand_3);
  nand nand_3  (w_nand_3, w_nand_1, w_nand_2, rst_n);

  // slave
  nand nand_4  (w_nand_4, w_nand_2, clk);
  nand nand_5  (w_nand_5, w_nand_3, clk);
  nand nand_6  (q, w_nand_4, q_bar);
  nand nand_7  (q_bar, w_nand_5, q, rst_n);

endmodule
