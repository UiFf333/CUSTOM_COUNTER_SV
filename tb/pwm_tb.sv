`timescale 1ns/1ps
module pwm_tb();

localparam Np = 16;

logic       clk_w;
logic       rstn_w;
logic       clear_w;
logic [1:0] prescale_sel_w;
logic       pwm_w;
logic is_running_w;
pwm #(
    .Np(Np)
) DUT (
    .clk_i(clk_w),
    .rstn_i(rstn_w),
    .clear(clear_w),
    .prescale_sel(prescale_sel_w),
    .pwm(pwm_w),
    .is_running(is_running_w)
);

initial begin
    clk_w = 0;
    forever #1 clk_w = ~clk_w;
end

initial begin
    rstn_w         = 0;
    clear_w        = 0;
    prescale_sel_w = 2'b00;
    #5 rstn_w = 1;

    #2000;

    clear_w = 1;
    #2 clear_w = 0;

    #2000;

    prescale_sel_w = 2'b01;
    #2000;

    prescale_sel_w = 2'b10;
    #2000;

    prescale_sel_w = 2'b11;
    #2000;

    $stop();
end


endmodule