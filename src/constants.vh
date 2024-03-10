// controller.v
localparam [2:0] CTRL_IDLE_S      = 3'b000;
localparam [2:0] CTRL_ADD_COLOR_S = 3'b001;
localparam [2:0] CTRL_DISPLAY_S   = 3'b010;
localparam [2:0] CTRL_DISPLAY2_S  = 3'b011;
localparam [2:0] CTRL_INPUT_S     = 3'b100;
localparam [2:0] CTRL_WIN_S       = 3'b101;
localparam [2:0] CTRL_LOSE_S      = 3'b110;


// timer.v
localparam [1:0] TIMR_IDLE_S      = 2'b00;
localparam [1:0] TIMR_COUNT_S     = 2'b01;

localparam [20:0] TIMR_MAX_C      = 21'h00_0003;
// localparam [20:0] TIMR_MAX_C      = 21'h0F_FFFF;
