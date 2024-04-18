/*
 * Copyright (c) 2023 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

//============================================================================//
// Oscillator
//============================================================================//

`define default_netname none

module oscillator (
  input  wire       CLK,      // Clock - 50MHz
  input  wire       RST_N,    // Reset_n - active low
  input  wire       EN,       // Enable
  input  wire [1:0] NOTE_SEL, // Note selection
  output reg        AUDIO     // Oscillator output
);
  //-----------------------------
  // note:        Hz : Cyc@50Mhz
  // F#5 :  739.99Hz :    67_568
  // A 5 :  880.00Hz :    56_818
  // C#6 : 1108.70Hz :    45_098
  // E 6 : 1318.50Hz :    37_922
  //-----------------------------

  wire clk_fsharp5;
  wire clk_a5;
  wire clk_csharp6;
  wire clk_e6;

  clk_div #(
    .FREQ_IN  (50_000_000),
    .FREQ_OUT (67_568)
  ) clk_div_fsharp5 (
    .CLK      (CLK),
    .RST_N    (RST_N),
    .CLK_OUT  (clk_fsharp5)
  );

  clk_div #(
    .FREQ_IN  (50_000_000),
    .FREQ_OUT (56_818)
  ) clk_div_a5 (
    .CLK      (CLK),
    .RST_N    (RST_N),
    .CLK_OUT  (clk_a5)
  );

  clk_div #(
    .FREQ_IN  (50_000_000),
    .FREQ_OUT (45_098)
  ) clk_div_csharp6 (
    .CLK      (CLK),
    .RST_N    (RST_N),
    .CLK_OUT  (clk_csharp6)
  );

  clk_div #(
    .FREQ_IN  (50_000_000),
    .FREQ_OUT (37_922)
  ) clk_div_e6 (
    .CLK      (CLK),
    .RST_N    (RST_N),
    .CLK_OUT  (clk_e6)
  );

  always @(*) begin
    case (NOTE_SEL)
      2'b0    : AUDIO = EN ? clk_fsharp5 : 0; 
      2'b1    : AUDIO = EN ? clk_a5      : 0;
      2'b2    : AUDIO = EN ? clk_csharp6 : 0;
      2'b3    : AUDIO = EN ? clk_e6      : 0;
      default : AUDIO = 0; 
    endcase
  end

endmodule : oscillator
