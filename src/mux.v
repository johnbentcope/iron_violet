module mux #(parameter BUS_WIDTH = 1)(
  // inputs
  input  wire [BUS_WIDTH-1:0] a, // input a
  input  wire [BUS_WIDTH-1:0] b, // input b
  input  wire                 s, // select
  // outputs
  output reg  [BUS_WIDTH-1:0] y
);
  // wires
  wire s_bar;
  wire [BUS_WIDTH-1:0] w0;
  wire [BUS_WIDTH-1:0] w1;

  // gates
  not not_s (s_bar, s);

  generate
    for (genvar i = 0; i < BUS_WIDTH; i = i + 1) begin
      and and_w0_u (w0[i], a[i], s_bar);
      and and_w1_u (w1[i], b[i], s);
      or  or_y_u   (y[i], w0[i], w1[i]);
    end
  endgenerate

endmodule : mux
