/*
 * Copyright (c) 2023 Iron Violet LLC
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

//============================================================================//
// Gate Level 2DFF (12 Gates!)
//============================================================================//
module 2dff_gates (
    // inputs
    input  wire clk,     // clock
    input  wire rst_n,   // active-low reset
    input  wire aync_in, // async data in
    // outputs
    output reg  sync_out // sync data out
);
    // internal regs
    reg d_int;

    // dffs
    dff_gates dff_gates_u0 (
        .clk   (clk),
        .rst_n (rst_n),
        .d     (async_in),
        .q     (d_int),
        .q_bar (/*open*/)
    ); 
    
    dff_gates dff_gates_u1 (
        .clk   (clk),
        .rst_n (rst_n),
        .d     (d_int),
        .q     (sync_out),
        .q_bar (/*open*/)
    ); 
endmodule
