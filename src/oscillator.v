/*
 * Copyright (c) 2023 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module oscillator#(
  parameter DATA_WIDTH = 2
)(
  input  wire       clk,    // Clock - 50MHz
  input  wire       rst_n,  // Reset_n - active low
  input  wire       load,   // Reset_n - active low
  input  wire [4:0] note,   // Note selection, maybe needs more bits
  output reg        speaker // Oscillator output
);

//-------------------------------------------------------------------
// note:        Hz : Cyc@10Mhz : Cyc@50Mhz
// F#5 :  739.99Hz :   13_514  :    67_568
// A 5 :  880.00Hz :   11_363  :    56_818
// C#6 : 1108.70Hz :           :          
// E 6 : 1318.50Hz :           :          
//-------------------------------------------------------------------

reg [15: 0] oscillator_counter;

reg [  DATA_WIDTH-1:0] stack [DEPTH-1:0];

always @(posedge clk or negedge rst_n) begin

  // Handle reset.
  if(!rst_n) begin
    speaker             <=  0;
    oscillator_counter  <= '0;
  end

  else begin
    oscillator_counter  <= oscillator_counter + 1;
  end

end

endmodule : oscillator
