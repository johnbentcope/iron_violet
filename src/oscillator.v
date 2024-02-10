/*
 * Copyright (c) 2023 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module oscillator#()(
  input  wire       clk,    // Clock - 50MHz
  input  wire       rst_n,  // Reset_n - active low
  input  wire       load,   // Reset_n - active low
  input  wire [4:0] note,   // Note selection, maybe needs more bits
  output reg        speaker // Oscillator output
);

reg [15: 0] oscillator_counter;

always @(posedge clk) begin

  if(!rst_n) begin
    speaker             <=  0;
    oscillator_counter  <= '0;
  end

  else begin
    oscillator_counter  <= oscillator_counter + 1;
  end

end

endmodule : oscillator
