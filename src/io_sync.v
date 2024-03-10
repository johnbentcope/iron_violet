module io_sync(
    input wire clk,
    input wire rst_n,
    input wire [3:0] in,
    output reg [1:0] out,
    output reg       valid
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out   <= 0;
        valid <= 0;
    end else begin
        out[1] <= in[3] | in[2];
        out[0] <= in[3] | in[1];

        valid  <= in[3] | in[2] | in[1] | in[0];
    end

end

endmodule : io_sync
