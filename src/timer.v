module timer(
input CLK,
input RST_N,
input START
);

reg [1:0]  current_state;
reg [20:0] counter;

always @(posedge CLK) begin

  // Handle reset.
  if(!RST_N) begin
    current_state <= 0;
  end
  else begin
    case(current_state)
      TIMR_IDLE_S: begin
        if (START) begin
          current_state <= TIMR_COUNT_S;
        end
      end
    endcase
  end

end


endmodule
