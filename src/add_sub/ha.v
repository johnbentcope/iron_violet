module ha (
  // inputs
  input  wire a, 
  input  wire b,
  // outputs
  output reg  sum,
  output reg  carry
);
  // gate logic
  xor xor_0 (sum,   a, b); // sum   = a ^ b
  and and_0 (carry, a, b); // carry = a + b

endmodule
