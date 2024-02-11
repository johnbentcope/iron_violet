/*
 * Copyright (c) 2023 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`include "clog2_function.vh"

`define default_netname none

module tt_um_iron_violet_simon
// #(
  // parameter CLK_FREQ    = 50_000_000_000, // 50 billion mHz aka 50 MHz
  // parameter NUM_BUTTONS = 4,
  // parameter DEPTH       = 16
// )
(
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // Will go high when the design is enabled
  input  wire       clk,      // Clock
  input  wire       rst_n     // Reset_n - active low
);

  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uo_out[5:3]  = 0;
  assign uio_out      = 0;
  assign uio_oe       = 0;


  stack #() stack_i (
    .CLK      (clk        ),
    .RST_N    (rst_n      ),
    .PUSH     (ui_in [  7]),
    .POP      (ui_in [  6]),
    .DATA_IN  (ui_in [1:0]),
    .DATA_OUT (uo_out[1:0]),
    .FULL     (uo_out[  7]),
    .EMPTY    (uo_out[  6])
  );

  oscillator #() osciillator_i (
    .CLK      (clk        ),
    .RST_N    (rst_n      ),
    .NOTE_SEL (ui_in [3:2]),
    .AUDIO    (uo_out[  2])
  );

endmodule : tt_um_iron_violet_simon
