module mux (
  // inputs
  input  wire a, // input a
  input  wire b, // input b
  input  wire s, // select
  // outputs
  output reg  y
);
  // wires
  wire s_bar;
  wire w0;
  wire w1;

  // gates
  not not_s (s_bar, s);

  and and_w0 (w0, a, s_bar);
  and and_w1 (w1, b, s);
  or  or_y   (y, w0, w1);

endmodule : mux
