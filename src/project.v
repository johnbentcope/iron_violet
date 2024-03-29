/*
 * Copyright (c) 2023 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_iron_violet_simon
// #(
  // parameter CLK_FREQ    = 50_000_000_000, // 50 billion mHz aka 50 MHz
  // parameter NUM_BUTTONS = 4,
  // parameter DEPTH       = 16
// )
(
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // Will go high when the design is enabled
  input  wire       clk,      // Clock
  input  wire       rst_n     // Reset_n - active low
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7]    = 0;
  assign uio_out      = 0;
  assign uio_oe       = 0;

  wire [1:0] in_sync;
  wire       in_valid;

  wire [1:0] lamp_out;
  wire       lamp_ena;

  wire [1:0] rand_num;

  assign uo_out[0] = lamp_ena & !lamp_out[1] & !lamp_out[0];
  assign uo_out[1] = lamp_ena & !lamp_out[1] &  lamp_out[0];
  assign uo_out[2] = lamp_ena &  lamp_out[1] & !lamp_out[0];
  assign uo_out[3] = lamp_ena &  lamp_out[1] &  lamp_out[0];

  wire timer_pulse;
  wire timer_go;

  //add IO debbounce/ sync/encode
  io_sync io_sync_u1(
    .clk(clk),
    .rst_n(rst_n),
    .in(ui_in[3:0]),
    .out(in_sync),
    .valid(in_valid)
  );

  rng rng_u1(
    .clk(clk),
    .rst_n(rst_n),
    .out(rand_num)
  );

  controller controller_u1(
    .CLK          ( clk         ),
    .RST_N        ( rst_n       ),
    .IN           ( in_sync     ),
    .IN_VALID     ( in_valid    ),
    .OUT          ( lamp_out    ),
    .OUT_ENA      ( lamp_ena    ),
    .RAND         ( rand_num    ),
    .TIMER_GO     ( timer_go    ),
    .TIMER_PULSE  ( timer_pulse ), //TODO add timer
    .START_GAME   ( ui_in [5]   ), //TODO add sync
    .WIN          ( uo_out[5]   ),
    .LOSE         ( uo_out[6]   ),
    .HS           ( uo_out[4]   )
  );

  timer timer_u1(
    .CLK        ( clk         ),
    .RST_N      ( rst_n       ),
    .START_TMR  ( timer_go    ),
    .PULSE      ( timer_pulse )
  );
  //TODO ad sound nmodule, will get copy of output, hs, win, lose
  // and will drive spreaker output

  //TODO use gate level modules to improve existing code

endmodule : tt_um_iron_violet_simon
