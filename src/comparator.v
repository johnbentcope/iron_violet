/*
 * Copyright (c) 2023 Iron Violet LLC
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

//============================================================================//
// Comparator (5 Gates!)
//============================================================================//
module comparator (
    // inputs
    input  wire a,  // input a
    input  wire b,  // input b
    // outputs
    output reg  lt, // (a) less than (b)
    output reg  gt, // (a) greater than (b) 
    output reg  eq  // (a) equals (b)       
);
    // compliments
    wire a_bar;
    wire b_bar;

    // gates
    nor  nor_a   (a_bar, a);
    nor  nor_b   (b_bar, b);    

    and  and_lt  (lt, a_bar, b);
    and  and_gt  (gt, a, b_bar);
    xnor xnor_eq (eq, lt, gt);
  
endmodule : comparator
