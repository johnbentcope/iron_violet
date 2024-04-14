/*
 * Copyright (c) 2023 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module oscillator
// #(
//   parameter CLK_FREQ = 50_000_000_000
// )
(
  input  wire       CLK,      // Clock - 10KHz
  input  wire       RST_N,    // Reset_n - active low
  input  wire [1:0] NOTE_SEL, // Note selection
  output reg        AUDIO     // Oscillator output
);

//-------------------------------------------------------------------
// note:        Hz : Cyc@10Mhz : Cyc@50Mhz
// F#5 :  739.99Hz :   13_514  :    67_568
// A 5 :  880.00Hz :   11_363  :    56_818
// C#6 : 1108.70Hz :    9_020  :    45_098
// E 6 : 1318.50Hz :    7_584  :    37_922
//-------------------------------------------------------------------

// Frequencies in millihertz
// localparam Fs5_f =  739_990;
// localparam A_5_f =  880_000;
// localparam Cs6_f = 1108_700;
// localparam E_6_f = 1318_500;

reg [ 1: 0] current_note;             // 
reg [13: 0] oscillator_counter;       // 
reg [13: 0] counter_compares   [3:0]; // this seems expensive... optimize?

initial begin
  counter_compares[0] = 13_514;
  counter_compares[1] = 11_363;
  counter_compares[2] =  9_020;
  counter_compares[3] =  7_584;
end

//-------------------------------------------------------------------
// Okay so the state machine should never introduce a high frequency
// runt pulse in the square wave generator.
// Only at when toggling the output should a new counter value be loaded.
//-------------------------------------------------------------------

always @(posedge CLK) begin

  // Handle reset.
  if(!RST_N) begin
    AUDIO               <=  0;
    oscillator_counter  <= '0;
    current_note        <= NOTE_SEL;
  end

  else begin
    oscillator_counter  <= oscillator_counter + 1;
    if(oscillator_counter == counter_compares[current_note]) begin
      current_note <= NOTE_SEL;
      AUDIO <= !AUDIO;
    end
  end

end

endmodule : oscillator
