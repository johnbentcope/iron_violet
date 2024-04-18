// controller.v
localparam [4:0] CTRL_IDLE_S        = 5'b00000;
localparam [4:0] CTRL_START_S       = 5'b00001;
localparam [4:0] CTRL_ADD_COLOR_S   = 5'b00010;
localparam [4:0] CTRL_DISPLAY_S     = 5'b00011;
localparam [4:0] CTRL_DISPLAY2_S    = 5'b00100;
localparam [4:0] CTRL_DISPLAY3_S    = 5'b00101;
localparam [4:0] CTRL_INPUT_S       = 5'b00110;
localparam [4:0] CTRL_INPUT_HOLD_S  = 5'b00111;
localparam [4:0] CTRL_ENDGAME_S     = 5'b01000;
localparam [4:0] CTRL_WIN1_S        = 5'b01001;
localparam [4:0] CTRL_WIN2_S        = 5'b01010;
localparam [4:0] CTRL_WIN3_S        = 5'b01011;
localparam [4:0] CTRL_WIN4_S        = 5'b01100;
localparam [4:0] CTRL_LOSE1_S       = 5'b01101;
localparam [4:0] CTRL_LOSE2_S       = 5'b01110;s
localparam [4:0] CTRL_LOSE3_S       = 5'b01111;
localparam [4:0] CTRL_LOSE4_S       = 5'b10000;
localparam [20:0] MAX_TURN_TIME     = 21'h0_00FFF;

// timer.v
localparam [1:0] TIMR_IDLE_S      = 2'b00;
localparam [1:0] TIMR_COUNT_S     = 2'b01;
localparam [20:0] TIMR_MAX_C      = 21'h00_00F0;

`ifdef QUICK_PLAY
  localparam [24:0] FIVE_SECOND = 25'hFA;
  localparam [24:0] HALF_SECOND = 25'h19;
  localparam [24:0] QRTR_SECOND = 25'h0C;
`else // human-time
  localparam [24:0] FIVE_SECOND = 25'h000_C350; //10KHz time
  localparam [24:0] HALF_SECOND = 25'h000_1388;
  localparam [24:0] QRTR_SECOND = 25'h000_09C4;
`endif
