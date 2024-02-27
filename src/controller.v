module controller(
input CLK,
input RST_N,

input wire [1:0] IN,
input wire       IN_VALID,
output reg [1:0] OUT,

input wire [1:0] RAND,
input wire       TIMER_PULSE,

input  wire START,
output reg WIN,
output reg LOSE,
output reg HS
);
`include "constants.vh"


localparam [5:0] MAX = 32;

reg [2:0] state;
reg [4:0] i;
reg [4:0] cnt;
reg [5:0] high_score;


reg [1:0] stack [0:31];

always @(posedge CLK or negedge RST_N) begin
    if(!RST_N) begin
        state      <= 0;
        i          <= 0;
        cnt        <= 0;
        high_score <= 0;
        WIN        <= 0;
        LOSE       <= 0;
        HS         <= 0;
    end
    else begin
        //pulse defaults
        HS   <= 0;

        case(state)

        IDLE_S : begin
            i   <= 0;
            cnt <= 0;
            if(START) begin
                state <= ADD_COLOR_S; //NOISE (start sound)
            end
        end

        ADD_COLOR_S : begin
            if(cnt == MAX-1) begin
                //game over out of memory
                //NOISE happy sound
                //maybe special thing if gates
                state <= WIN_S;
            end else begin
                stack[cnt] <= RAND;
                cnt        <= cnt + 1;
                state      <= DISPLAY_S;
                HS <= 1;
            end
        end

        DISPLAY_S : begin
            // break into 2 substates
            // one to set values, one to implement a delay

            state <= DISPLAY2_S;
        end

        DISPLAY2_S :begin
            OUT   <= stack[i];
            if(TIMER_PULSE) begin
                i <= i + 1;
                state <= DISPLAY_S;
            end
        end

        //TODO make sure i is reset to 0 before entering this state
        INPUT_S : begin
            //assume inputs have been sampled, synced and encoded externally
            if(IN_VALID) begin
                if(IN == stack[i]) begin
                    i <= i + 1;
                    if (i == cnt-1) begin
                        state <= ADD_COLOR_S; //NOISE(win happy sound)
                    end
                end else begin
                    state <= LOSE_S;
                end
            end
        end

        //should we just have 'win' for the round and lose for the whole game (maybe change name to end)
        //should win/lose be one state? check score agains highscore
        WIN_S : begin

            state <= LOSE_S;
        end

        LOSE_S : begin
            state <= IDLE_S;
            HS    <= 1;
        end



        endcase
    end
end

//TODO secretly insert code to mine bitcoin

endmodule