`timescale 1ns / 1ps

module counter_mode_tb();

    logic clk_i;
    logic rstn_i;
    logic [1:0] cnt_mode;
    logic [9:0] target_value;
    logic input_source;
    logic clear;
    logic [9:0] count_o;
    logic is_running;
    logic [9:0] capture_register;
    logic [1:0] capture_select;

    counter_mode dut (
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .cnt_mode(cnt_mode),
        .target_value(target_value),
        .input_source(input_source),
        .clear(clear),
        .count_o(count_o),
        .is_running(is_running),
        .capture_register(capture_register),
        .capture_select(capture_select)
    );

    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

    initial begin
        rstn_i = 0;
        input_source = 0;
        cnt_mode = 2'b00;
        capture_select = 2'b00;
        target_value = 10'd3;
        clear = 0;

        #15 rstn_i = 1;

        @(negedge clk_i);
        #2 input_source = 1;
        
        @(negedge clk_i);
        @(negedge clk_i);
        #2 input_source = 0;

        @(negedge clk_i);
        #2 input_source = 1;

        @(negedge clk_i);
        @(negedge clk_i);
        @(negedge clk_i);
        @(negedge clk_i);
        #2 input_source = 0;

        @(negedge clk_i);
        @(negedge clk_i);
        #2 input_source = 1;

        @(negedge clk_i);
        #2 input_source = 0;

        #40 $finish;
    end

endmodule