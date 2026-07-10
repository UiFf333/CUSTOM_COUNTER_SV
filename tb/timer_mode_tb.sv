`timescale 1ns / 1ps

module timer_mode_tb();

    logic clk_i;
    logic rstn;
    logic input_source;
    logic [1:0] mode_select;
    logic [9:0] target_value;
    logic clear;
    logic [9:0] capture_register;
    logic [1:0] capture_select;
    logic [9:0] counter;
    logic is_running;

    timer_mode dut (
        .clk(clk_i),
        .rstn(rstn),
        .input_source(input_source),
        .mode_select(mode_select),
        .target_value(target_value),
        .clear(clear),
        .capture_register(capture_register),
        .capture_select(capture_select),
        .counter(counter),
        .is_running(is_running)
    );

    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

    initial begin
        rstn = 0;
        input_source = 0;
        mode_select = 2'b00;
        capture_select = 2'b00;
        target_value = 10'd30;
        clear = 0;

        #15 rstn = 1;
        
        @(negedge clk_i); 
        #2 input_source = 1;
        
        @(negedge clk_i);
        @(negedge clk_i);
        #2 input_source = 0;
        
        @(negedge clk_i);
        @(negedge clk_i);
        @(negedge clk_i);
        
        @(negedge clk_i);
        #2 input_source = 1;
        
        @(negedge clk_i);
        @(negedge clk_i);
        @(negedge clk_i);
        #2 input_source = 0;

        #40 $finish;
    end

endmodule