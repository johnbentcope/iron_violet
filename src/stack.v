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

`include "clog2_function.vh"

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

  // Verilog doesn't have clog2(), so don't try to use it.
  // Update the ptr width to be clog2(DEPTH) if DEPTH changes.
  // Or someone write a lil macro here to calculate it
  reg [clog2(DEPTH)-1:0] ptr;
  reg [  DATA_WIDTH-1:0] stack [DEPTH-1:0];

  // Synchnous stack management state machine with async reset
  // If not in reset, check for a push.
  // If there's no push, check for a pop.
  always @(posedge CLK or negedge RST_N) begin
    
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
        ptr        <= ptr + 1;

        // I/O operations
        DATA_OUT   <= DATA_IN;
        FULL       <= (ptr == (DEPTH - 1)[3:0]);
        EMPTY      <= 0;
      end
      
      // Pop operation if not empty
      else if (POP & !EMPTY) begin
        // Pops only update ptr
        ptr        <= ptr - 1;

        // I/O operations
        DATA_OUT   <= stack[ptr];
        FULL       <= 0;
        EMPTY      <= (ptr == 0);
      end
    end
  end

endmodule : stack
