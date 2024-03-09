module add_sub (
  // inputs
  input  wire [7:0] a, 
  input  wire [7:0] b,
  input  wire       s_u,
  // outputs
  output wire [7:0] s
);
  // gate logic
  wire       fba_carry;
  wire [7:0] xor_b;

  xor xor_0 (xor_b[0], b[0], s_u);
  xor xor_1 (xor_b[1], b[1], s_u);
  xor xor_2 (xor_b[2], b[2], s_u);
  xor xor_3 (xor_b[3], b[3], s_u);   
  xor xor_4 (xor_b[4], b[4], s_u);
  xor xor_5 (xor_b[5], b[5], s_u);
  xor xor_6 (xor_b[6], b[6], s_u);
  xor xor_7 (xor_b[7], b[7], s_u);      

  fba fba_0 (.a (a[3:0]), .b (xor_b[3:0]), .c (s_u),       .sum (S[3:0]), .carry (fba_carry));
  fba fba_1 (.a (a[7:4]), .b (xor_b[7:4]), .c (fba_carry), .sum (S[7:4]), .carry (/*open*/));

endmodule
