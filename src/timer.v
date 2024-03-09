module timer(
input CLK,
input RST_N,
input START,
output PULSE
);

reg [1:0]  current_state;
reg pulse_i;
reg [20:0] counter;

always @(posedge CLK) begin

  // Handle reset.
  if(!RST_N) begin
    current_state <= 0;
    pulse_i       <= 0;
  end
  else begin
    case(current_state)
      TIMR_IDLE_S: begin
        pulse_i <= 0;
        if (START) begin
          current_state <= TIMR_COUNT_S;
        end
      end
      TIMR_COUNT_S: begin
        counter <= counter + 1;
        if (counter == 21'h0F_FFFF) begin
          counter <= '0;
          pulse_i <=  1;
          current_state <= TIMR_IDLE_S;
        end
      end
    endcase
  end

end


endmodule
