module test_i(
    input clk,
    input rst_n,
    input test_input
);
    logic a;
    always_ff @(posedge clk) begin
        a <= test_input;
    end
endmodule