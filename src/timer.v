module timer(
input CLK,
input RST_N,
input START
);

reg [1:0] current_state;

always @(posedge CLK) begin

  // Handle reset.
  if(!RST_N) begin
    current_state <= 0;
  end
  else begin
    if (current_state == 0 && )
  end

end


endmodule
