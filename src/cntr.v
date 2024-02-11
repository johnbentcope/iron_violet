/*
 * Copyright (c) 2023 Iron Violet LLC
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

//============================================================================//
// Gate Level Counter
//============================================================================//
module cntr #(parameter COUNT_WIDTH = 4)(
    // inputs
    input  wire                  clk,   // clock
    input  wire                  rst_n, // active-low reset
    input  wire                  en,    // enable
    // outputs
    output reg [COUNT_WIDTH-1:0] count  // counter value
);
    // cascading jkff
    generate 
        for (genvar i = 0; i < COUNT_WIDTH; i = i + 1) begin
            jkff jkff_u (.clk (clk), .rst_n (rst_n), .j (en), .k (en), .q (count[i]));  
        end
    endgenerate

endmodule : cntr
