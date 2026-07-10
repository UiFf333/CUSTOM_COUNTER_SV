`timescale 1ns/1ps
module prescalar_tb();

logic          rstn_w;
logic          clk_w;
logic [9:0]    limit_f1_w;
logic          prescalar_w;

Prescalar #(
    .Np(10)
) DUT (
    .rstn(rstn_w),
    .clk(clk_w),
    .limit_f1(limit_f1_w),
    .prescalar(prescalar_w)
);

initial begin
    clk_w = 0;
    forever #1 clk_w = ~clk_w;
end

initial begin
    rstn_w     = 0;
    limit_f1_w = 3;
    #1 rstn_w = 1;
    #30 $stop();
end

endmodule