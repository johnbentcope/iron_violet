`default_nettype none `timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module stack_tb ();
  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, stack_tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg  clk;
  reg  rst_n;
  reg  push;
  reg  pop;
  reg  [1:0] data_in;
  wire [1:0] data_out;
  wire full;
  wire empty;

  stack user_project (
    .CLK      (clk),      // clock
    .RST_N    (rst_n),    // reset
    .PUSH     (push),     // reset
    .POP      (pop),     // reset
    .DATA_IN  (data_in),
    .DATA_OUT (data_out),
    .FULL     (full),
    .EMPTY    (empty)
  );

endmodule : stack_tb
