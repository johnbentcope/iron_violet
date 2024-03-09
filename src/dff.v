/*
 * Copyright (c) 2023 Iron Violet LLC
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

//============================================================================//
// Gate Level DFF (6 Gates!)
//============================================================================//
module dff (parameter BUS_WIDTH)(
    // inputs
    input  wire                 clk,   // clock
    input  wire                 rst_n, // active-low reset
    input  wire [BUS_WIDTH-1:0] d,     // data in
    // outputs
    output reg  [BUS_WIDTH-1:0] q,     // data out
    output reg  [BUS_WIDTH-1:0] q_bar  // data out, inverted
);

    // internal wires
    wire [BUS_WIDTH-1:0] d_int;
    wire [BUS_WIDTH-1:0] w_nand_0;
    wire [BUS_WIDTH-1:0] w_nand_1;
    wire [BUS_WIDTH-1:0] w_nand_2;
    wire [BUS_WIDTH-1:0] w_nand_3;

    generate 
        for (genvar i = 0; i < BUS_WIDTH; i = i + 1) begin
            // synchronous reset
            mux mux_reset_u (
                .a (1'b0),
                .b (d[i]),
                .s (rst_n),
                .y (d_int[i])
            );
    
            // gate logic
            nand nand_0_u (w_nand_0[i], w_nand_3[i], w_nand_1[i]);
            nand nand_1_u (w_nand_1[i], w_nand_0[i], rst_n, clk);
            nand nand_2_u (w_nand_2[i], w_nand_1[i], clk, w_nand_3[i]);
            nand nand_3_u (w_nand_3[i], w_nand_2[i], d_int[i]);
            nand nand_4_u (q[i], w_nand_1[i], q_bar[i]);   
            nand nand_5_u (q_bar[i], q[i], w_nand_2[i]);     
        end
    endgenerate

endmodule : dff
