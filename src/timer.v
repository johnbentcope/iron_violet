`default_nettype none

module timer(
input  CLK,
input  RST_N,
input  START_TMR,
output PULSE
);
`include "constants.vh"

reg [1:0]  state;
reg pulse_i;
reg [20:0] counter;

assign PULSE = pulse_i;

always @(posedge CLK or negedge RST_N) begin

  // Handle reset.
  if(!RST_N) begin
    state <= 0;
    pulse_i       <= 0;
    counter       <= 0;
  end
  else begin
    // Pulsed signal default values
    pulse_i   <= 0;
    
    case(state)
      TIMR_IDLE_S: begin
        if (START_TMR) begin
          state <= TIMR_COUNT_S;
          counter       <= counter + 1;
        end
      end
      TIMR_COUNT_S: begin
        counter         <= counter + 1;
        if (counter == TIMR_MAX_C) begin
          counter       <= '0;
          pulse_i       <=  1;
          state <= TIMR_IDLE_S;
        end
      end
      default : begin
        state <= TIMR_IDLE_S;
      end

    endcase
  end

end


endmodule : timer
