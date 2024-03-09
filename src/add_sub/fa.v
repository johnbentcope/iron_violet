module fa (
  // inputs
  input  wire a, 
  input  wire b,
  input  wire c,
  // outputs
  output reg sum,
  output reg carry
);
  // gate logic
  wire carry_ha_0;
  wire sum_ha_1;
  wire carry_ha_1;  

  ha ha_0 (.a (a), .b (sum_ha_1), .sum (sum),      .carry (carry_ha_0));
  ha ha_1 (.a (a), .b (c),        .sum (sum_ha_1), .carry (carry_ha_1));

  or or_0 (carry, carry_ha_0, carry_ha_1);

endmodule
