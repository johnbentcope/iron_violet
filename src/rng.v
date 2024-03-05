module rng(
    input wire clk,
    input wire rst_n,
    output reg [1:0] out
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out <= 1;
    end else begin
        out <= out + 1;
    end
end

endmodule