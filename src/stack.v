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
    parameter DEPTH = 16
  ) (
    input                       CLK,
    input                       RST_N,
    input                       PUSH,
    input                       POP,
    input      [DATA_WIDTH-1:0] DATA_IN,
    output reg [DATA_WIDTH-1:0] DATA_OUT,
    output reg                  FULL,
    output reg                  EMPTY
  );

  reg [$clog2(DEPTH)-1:0] ptr;
  reg [   DATA_WIDTH-1:0] stack [DEPTH-1:0];

  // Synchnous stack management state machine with async reset
  // If not in reset, check for a push.
  // If there's no push, check for a pop.
  always @(posedge CLK) begin

    // Handle reset
    if (!RST_N) begin
      ptr           <= 0;
      DATA_OUT      <= 0;
      FULL          <= 0;
      EMPTY         <= 1;

    // Else push or pop from the stack
    end else begin

      // Push operation if not full
      if (PUSH & !FULL) begin
        // Pushes update stack and ptr
        stack[ptr] <= DATA_IN;
        if (ptr != '1) begin
          ptr        <= ptr + 1;
        end

        // I/O operations
        DATA_OUT   <= DATA_IN;
        FULL       <= (ptr == '1); // TODO un-hardcode this
        EMPTY      <= 0;
      end

      // Pop operation if not empty
      else if (POP & !EMPTY) begin
        // Pops only update ptr
        if (ptr != '0) begin
          ptr        <= ptr +-1;
        end

        // I/O operations
        DATA_OUT   <= stack[ptr];
        FULL       <= 0;
        EMPTY      <= (ptr == 0);
      end
    end
  end

endmodule : stack
