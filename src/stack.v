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

  // Verilog doesn't have clog2(), so don't try to use it.
  // Update the ptr width to be clog2(DEPTH) if DEPTH changes.
  // Or someone write a lil macro here to calculate it
  reg [           3:0] ptr;
  reg [DATA_WIDTH-1:0] stack [DEPTH-1:0];

  // It's like a state machine eyyyy
  always @(posedge CLK) begin
      
      // Handle reset
      if (!RST_N) begin
          ptr           <= 0;
          DATA_OUT      <= 0;
          FULL          <= 0;
          EMPTY         <= 1;

      // Else push or pop from the stack
      end else begin

          // Push takes precedence over pop
          if (PUSH & !FULL) begin
              // Update stack when new data is pushed and there's room
              stack[ptr] <= DATA_IN;
              ptr       <= ptr + 1;
              DATA_OUT  <= DATA_IN;
              FULL      <= (ptr == DEPTH - 1);
              EMPTY     <= 0;
          end
          
          // Pop only updates ptr, no need to waste power clearing regs
          else if (POP & !EMPTY) begin
              ptr       <= ptr - 1;
              DATA_OUT  <= stack[ptr];
              FULL      <= 0;
              EMPTY     <= (ptr == 0);
          end
      end
  end


endmodule : stack
