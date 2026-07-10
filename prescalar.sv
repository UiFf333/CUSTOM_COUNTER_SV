module Prescalar #(
    parameter Np = 10
)(
    input  logic          rstn,
    input  logic          clk,
    input  logic [Np-1:0] limit_f1,
    output logic          prescalar
);

logic [Np-1:0] prescalar_cnt;
logic [Np-1:0] in;

always_ff @(posedge clk or negedge rstn) begin
    if (rstn == 0)
        prescalar_cnt <= 0;
    else
        prescalar_cnt <= in;
end

assign prescalar = (limit_f1 == prescalar_cnt);
assign in = prescalar ? 0 : prescalar_cnt + 1;

endmodule