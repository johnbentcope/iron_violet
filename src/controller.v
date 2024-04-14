/*
 * Copyright (c) 2023 Iron Violet LLC
 * SPDX-License-Identifier: Apache-2.0
 */

//============================================================================//
// Controller
//============================================================================//
`define default_netname none

module controller (
  input             CLK,
  input             RST_N,

  input  wire [1:0] IN,
  input  wire       IN_VALID,
  output reg  [1:0] OUT,
  output reg        OUT_ENA,

  input  wire [1:0] RAND,

  input  wire       START_GAME,
  output reg        LOSE,
  output reg        HS
);
  `include "constants.vh"

  // internal signals
  localparam [4:0] MAX = 5'b1_1111;

  reg [3:0] state;
  reg [4:0] i;          // Current historic turn to display
  reg [4:0] cnt;        // Current turn count
  reg [5:0] high_score;

  reg good_hold;
  reg last_color;
  reg clr_turn;
  reg go_turn;
  wire timeout_turn;

  reg [1:0] stack [0:31];

  reg [24:0] timer_count;

  timer turn_timer_u1 (
    .CLK        ( CLK           ),
    .RST_N      ( RST_N         ),
    .CLR        ( clr_turn      ),
    .TIMER_VAL  ( timer_count   ),
    .START_TMR  ( go_turn       ),
    .PULSE      ( timeout_turn  )
  );

  always @(posedge CLK or negedge RST_N) begin
    if (!RST_N) begin
      state       <= 0;
      i           <= 0;
      cnt         <= 0;
      high_score  <= 0;
      LOSE        <= 0;
      HS          <= 0;
      OUT         <= 3;
      OUT_ENA     <= 0;
      good_hold   <= 0;
      last_color  <= 0;
      clr_turn    <= 1;
      go_turn     <= 0;
      timer_count <= 0;
    end else begin
      // Pulsed signal default values
      HS          <= 0;
      go_turn     <= 0;
      clr_turn    <= 0;

      case (state)
        CTRL_IDLE_S : begin
          i   <= 0;
          cnt <= 0;
          clr_turn <= 1;
          go_turn  <= 0;            
          if (START_GAME) state <= CTRL_START_S; // NOISE (start sound)
        end

        CTRL_START_S : begin
          if (!START_GAME) state <= CTRL_ADD_COLOR_S; // End NOISE (start sound)
        end

        CTRL_ADD_COLOR_S : begin
          last_color <= 0;
          if (cnt == MAX-1) begin
            //game over out of memory
            //NOISE happy sound
            //maybe special thing if gates
            state <= CTRL_WIN_S;
          end else begin
            stack[cnt] <= RAND;
            state      <= CTRL_DISPLAY_S;
          end
        end

        CTRL_DISPLAY_S : begin
          // TODO: break into 2 substates
          // one to set values, one to implement a delay
          go_turn     <= 1; // Start display timer
          timer_count <= HALF_SECOND;
          OUT_ENA     <= 1;
          OUT         <= stack[i];
          state       <= CTRL_DISPLAY2_S;
        end

        CTRL_DISPLAY2_S : begin
          if (timeout_turn) begin
            OUT_ENA     <= 0;

            if (i == cnt) begin
              state       <= CTRL_INPUT_S;
              i           <= 0;
              cnt         <= cnt + 1;
              clr_turn    <= 0;
              timer_count <= FIVE_SECOND;
              go_turn     <= 1;
            end
            
            else begin
              i         <= i + 1;
              state     <= CTRL_DISPLAY_S;
            end

          end
        end

        // TODO: make sure i is reset to 0 before entering this state
        CTRL_INPUT_S : begin
          if (timeout_turn) begin // took too long to answer
            state    <= CTRL_LOSE_S;
            clr_turn <= 1;
          end

          else if (IN_VALID) begin
            if (IN == stack[i]) begin
              clr_turn                   <= 1;
              i                          <= i + 1;
              good_hold                  <= 1;
              if (i == cnt-1) last_color <= 1;
            end
            state <= CTRL_INPUT_HOLD_S;

          end
        end

        CTRL_INPUT_HOLD_S : begin
          if (!IN_VALID) begin // Don't transition until released
            if (good_hold) begin
              good_hold <= 0;

              if (last_color) begin
                i     <= 0;
                state <= CTRL_ADD_COLOR_S; // Releasing correct button
              end else begin
                state <= CTRL_INPUT_S;
              end
            end else begin
              state <= CTRL_LOSE_S; // Releasing wrong button
            end
          end
        end

        // TODO: should we just have 'win' for the round and lose for the whole game (maybe change name to end)
        // TODO: should win/lose be one state? check score agains highscore
        CTRL_WIN_S : begin
          state <= CTRL_LOSE_S;
        end

        CTRL_LOSE_S : begin
          if (cnt > high_score) begin
            high_score <= cnt - 1;
            HS    <= 1;
          end
          state <= CTRL_IDLE_S;
        end

        default : begin
          state <= CTRL_IDLE_S;
        end

      endcase
    end
  end

endmodule : controller
