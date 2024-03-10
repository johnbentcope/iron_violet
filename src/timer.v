`default_nettype none

module timer(
input  CLK,
input  RST_N,
input  START_TMR,
output PULSE
);
`include "constants.vh"

reg [1:0]  current_state;
reg pulse_i;
reg [20:0] counter;

assign PULSE = pulse_i;

always @(posedge CLK) begin

  // Handle reset.
  if(!RST_N) begin
    current_state <= 0;
    pulse_i       <= 0;
    counter       <= 0;
  end
  else begin
    case(current_state)
      TIMR_IDLE_S: begin
        pulse_i   <= 0;
        if (START_TMR) begin
          current_state <= TIMR_COUNT_S;
          counter   <= counter + 1;
        end
      end
      TIMR_COUNT_S: begin
        counter   <= counter + 1;
        if (counter == TIMR_MAX_C) begin
          counter       <= '0;
          pulse_i       <=  1;
          current_state <= TIMR_IDLE_S;
        end
      end
    endcase
  end

end


endmodule : timer
