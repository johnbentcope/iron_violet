//-------------------------------------------------------------------
// Copyright 2024
// 
// Don't be a jabroni
// 
//-------------------------------------------------------------------
// 
// Module       : Stack
// Description  : No almost full/almost empty because meat is slow.
//                Data will need decoding because regs are expensive
//
//-------------------------------------------------------------------

module stack #(
      parameter DATA_WIDTH = 2,
      parameter DEPTH = 32
  ) (
      input CLK,
      input RST_N,
      input PUSH,
      input POP,
      input [DATA_WIDTH-1:0] DATA_IN,
      output reg [DATA_WIDTH-1:0] DATA_OUT,
      output reg FULL,
      output reg EMPTY
  );

  reg [5-1:0] ptr;

  // It's like a state machine eyyyy
  always @(posedge CLK) begin
      if (!RST_N) begin
          ptr           <= 0;
          DATA_OUT      <= 0;
          FULL          <= 0;
          EMPTY         <= 1;

      end else begin
          if (PUSH & !FULL) begin
              ptr       <= ptr + 1;
              DATA_OUT  <= DATA_IN;
              FULL      <= (ptr == DEPTH - 1);
              EMPTY     <= 0;
          end else if (POP & !EMPTY) begin
              ptr       <= ptr - 1;
              DATA_OUT  <= stack[ptr];
              FULL      <= 0;
              EMPTY     <= (ptr == 0);
          end
      end
  end

  reg [DATA_WIDTH-1:0] stack [DEPTH-1:0];

  always @(posedge CLK) begin
      if (PUSH & !FULL) begin
          stack[ptr] <= DATA_IN;
      end
  end

endmodule