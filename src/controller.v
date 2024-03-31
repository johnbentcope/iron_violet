module controller(
input             CLK,
input             RST_N,

input  wire [1:0] IN,
input  wire       IN_VALID,
output reg  [1:0] OUT,
output reg        OUT_ENA,

input  wire [1:0] RAND,
output reg        TIMER_GO,
input  wire       TIMER_PULSE,

input  wire       START_GAME,
output reg        WIN,
output reg        LOSE,
output reg        HS
);
`include "constants.vh"


localparam [4:0] MAX = '1;

reg [3:0] state;
reg [4:0] i;          // Current historic turn to display
reg [4:0] cnt;        // Current turn count
reg [5:0] high_score;

reg good_hold;
reg last_color;

reg [1:0] stack [0:31];

always @(posedge CLK or negedge RST_N) begin
    if(!RST_N) begin
        state       <= 0;
        i           <= 0;
        TIMER_GO    <= 0;
        cnt         <= 0;
        high_score  <= 0;
        WIN         <= 0;
        LOSE        <= 0;
        HS          <= 0;
        OUT         <= 3;
        OUT_ENA     <= 0;
        good_hold   <= 0;
        last_color  <= 0;
    end
    else begin
        // Pulsed signal default values
        HS          <= 0;
        TIMER_GO    <= 0;

        case(state)

        CTRL_IDLE_S : begin
            i   <= 0;
            cnt <= 0;
            if(START_GAME) begin
                state <= CTRL_START_S; //NOISE (start sound)
            end
        end

        CTRL_START_S : begin
            if(!START_GAME) begin
                state <= CTRL_ADD_COLOR_S; //End NOISE (start sound)
            end
        end

        CTRL_ADD_COLOR_S : begin
            last_color <= 0;
            if(cnt == MAX-1) begin
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
            // break into 2 substates
            // one to set values, one to implement a delay
            TIMER_GO  <= 1;
            OUT_ENA   <= 1;
            OUT       <= stack[i];
            state     <= CTRL_DISPLAY2_S;
        end

        CTRL_DISPLAY2_S :begin
            if(TIMER_PULSE) begin
                OUT_ENA   <= 0;
                if(i == cnt) begin
                  state   <= CTRL_INPUT_S;
                  i       <= 0;
                  cnt     <= cnt + 1;
                end else begin
                  i       <= i + 1;
                  state   <= CTRL_DISPLAY_S;
                end
            end
        end

        //TODO make sure i is reset to 0 before entering this state
        CTRL_INPUT_S : begin
            //assume inputs have been sampled, synced and encoded externally
            if(IN_VALID) begin
                if(IN == stack[i]) begin
                    i <= i + 1;
                    good_hold <= 1;
                    if (i == cnt-1) begin
                        last_color <= 1;
                    end
                end
                state <= CTRL_INPUT_HOLD_S;
            end
        end

        CTRL_INPUT_HOLD_S : begin
          // if(IN == stack[i]) begin
          //     i <= i + 1;
          //     good_hold <= 1;
          //     if (i == cnt-1) begin
          //         i <= 0;
          //     end
          // end
          if(!IN_VALID) begin // Don't transition until released
            if(good_hold) begin
              good_hold <= 0;

              if (last_color) begin
                i <= 0;
                state <= CTRL_ADD_COLOR_S; // Releasing correct button
              end else begin
                state <= CTRL_INPUT_S;
              end
            end else begin
              state <= CTRL_LOSE_S; // Releasing wrong button
            end
          end
        end

        //should we just have 'win' for the round and lose for the whole game (maybe change name to end)
        //should win/lose be one state? check score agains highscore
        CTRL_WIN_S : begin

            state <= CTRL_LOSE_S;
        end

        CTRL_LOSE_S : begin
            state <= CTRL_IDLE_S;
            HS    <= 1;
        end

        default : begin
          state <= CTRL_IDLE_S;
        end

        endcase
    end
end

//TODO secretly insert code to mine bitcoin

endmodule : controller
