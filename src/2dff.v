/*
 * Copyright (c) 2023 Iron Violet LLC
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

//============================================================================//
// Gate Level 2DFF (12 Gates!)
//============================================================================//
module 2dff #(parameter BUS_WIDTH = 1)(
    // inputs
    input  wire                 clk,      // clock
    input  wire                 rst_n,    // active-low reset
    input  wire [BUS_WIDTH-1:0] en,       // enable
    input  wire [BUS_WIDTH-1:0] async_in, // async data in
    // outputs
    output reg  [BUS_WIDTH-1:0] sync_out  // sync data out
);
    // internal regs
    reg [BUS_WIDTH-1:0] first_dff;

    // dffs
    generate
    for (genvar i; i < BUS_WIDTH; i = i + 1) begin
        dff_en dff_en_u0 (
            .clk   (clk),
            .rst_n (rst_n),
            .en    (en[i]),
            .d     (async_in[i]),
            .q     (first_dff[i]),
            .q_bar (/*open*/)
        ); 
    
        dff_en dff_en_u1 (
            .clk   (clk),
            .rst_n (rst_n),
            .en    (en[i]),
            .d     (first_dff[i]),
            .q     (sync_out[i]),
            .q_bar (/*open*/)
        ); 
    end
    endgenerate
    
endmodule
