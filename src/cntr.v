/*
 * Copyright (c) 2023 Iron Violet LLC
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

//============================================================================//
// Counter
//============================================================================//
module cntr #(parameter COUNT_WIDTH = 4)(
    // inputs
    input  wire                  clk,     // clock
    input  wire                  rst_n,   // active-low reset
    input  wire                  ena,     // enable
    // outputs
    output reg [COUNT_WIDTH-1:0] count    // sync data out
);
    // counting ff
    always @(posedge clk or negedge rst_n) begin
      if  (!rst_n) count <= 0;
      else if (ena) count <= count + 1;
    end
  
endmodule
