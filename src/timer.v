/*
 * Copyright (c) 2023 Iron Violet LLC
 * SPDX-License-Identifier: Apache-2.0
 */

//============================================================================//
// Timer
//============================================================================//
`default_nettype none

module timer #(parameter [20:0] MAX_COUNT = 21'h00_0003)(
  input  wire CLK,
  input  wire RST_N,
  input  wire CLR,
  input  wire START_TMR,
  output reg  PULSE
);
  `include "constants.vh"
  
  // internal signals
  reg [1:0]  state;
  reg        pulse_i;
  reg [20:0] counter;

  assign PULSE = pulse_i;

  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N) begin
      state         <= 0;
      pulse_i       <= 0;
      counter       <= 0;
    end else if (CLR) begin
      state         <= 0;
      pulse_i       <= 0;
      counter       <= 0;    
    end else begin
      // Pulsed signal default values
      pulse_i   <= 0;

      case (state)
        TIMR_IDLE_S: begin
          if (START_TMR) begin
            state   <= TIMR_COUNT_S;
            counter <= counter + 1;
          end
        end

        TIMR_COUNT_S: begin
          counter   <= counter + 1;
          if (counter == MAX_COUNT) begin
            counter <= 0;
            pulse_i <= 1;
            state   <= TIMR_IDLE_S;
          end
        end

        default : begin
          state <= TIMR_IDLE_S;
        end
      endcase
    end
  end

endmodule : timer
