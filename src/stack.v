//-------------------------------------------------------------------
// Copyright 2024
// 
// Don't be a jabroni
// 
//-------------------------------------------------------------------
// 
// Module       : Stack
// Description  : So like, there's no need for an almost full signal.
//                Could halve the width and decode 2 to 4 each time
//                or not. Idk how much that takes up. halving the width
//                saves 64 bits of memory space, ~6% of the gates?
//
//-------------------------------------------------------------------

module stack #(
      parameter DATA_WIDTH = 4,
      parameter DEPTH = 32
  ) (
      input clk,
      input rst,
      input push,
      input pop,
      input [DATA_WIDTH-1:0] data_in,
      output reg [DATA_WIDTH-1:0] data_out,
      output reg full,
      output reg empty
  );

  reg [5-1:0] ptr;

  // It's like a state machine eyyyy
  always @(posedge clk) begin
      if (rst) begin
          ptr           <= 0;
          data_out      <= 0;
          full          <= 0;
          empty         <= 1;

      end else begin
          if (push & !full) begin
              ptr       <= ptr + 1;
              data_out  <= data_in;
              full      <= (ptr == DEPTH - 1);
              empty     <= 0;
          end else if (pop & !empty) begin
              ptr       <= ptr - 1;
              data_out  <= stack[ptr];
              full      <= 0;
              empty     <= (ptr == 0);
          end
      end
  end

  reg [DATA_WIDTH-1:0] stack [DEPTH-1:0];

  always @(posedge clk) begin
      if (push & !full) begin
          stack[ptr] <= data_in;
      end
  end

endmodule