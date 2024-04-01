// controller.v
localparam [3:0] CTRL_IDLE_S        = 4'b0000;
localparam [3:0] CTRL_START_S       = 4'b0001;
localparam [3:0] CTRL_ADD_COLOR_S   = 4'b0010;
localparam [3:0] CTRL_DISPLAY_S     = 4'b0011;
localparam [3:0] CTRL_DISPLAY2_S    = 4'b0100;
localparam [3:0] CTRL_INPUT_S       = 4'b0101;
localparam [3:0] CTRL_INPUT_HOLD_S  = 4'b0110;
localparam [3:0] CTRL_WIN_S         = 4'b0111;
localparam [3:0] CTRL_LOSE_S        = 4'b1000;


// timer.v
localparam [1:0] TIMR_IDLE_S      = 2'b00;
localparam [1:0] TIMR_COUNT_S     = 2'b01;

localparam [20:0] TIMR_MAX_C      = 21'h00_0003;
// localparam [20:0] TIMR_MAX_C      = 21'h0F_FFFF;

`ifdef QUICK_PLAY
  localparam [7:0] HALF_SECOND = 8'h19;
  localparam [3:0] QRTR_SECOND = 4'hC;
`else // humam-time
  localparam [24:0] HALF_SECOND = 25'h17D_7840;
  localparam [21:0] QRTR_SECOND = 22'h5F_5E10;
`endif
