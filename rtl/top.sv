module top(
    input logic clk,
    input logic rstn,
    input logic acc_en,
    input logic wr_en,
    input logic [2:0] addr,
    input logic [15:0] wdata,
    output logic [15:0] rdata,
    output logic         out,
    input  logic  input1,
    input  logic  input2,
    input  logic  input3,
    input  logic  input4,
    input  logic  input5,
    input  logic  input6,
    input  logic  input7,
    input  logic  input8,
    input  logic  input9,
    input  logic  input10,
    input  logic  input11,
    input  logic  input12,
    input  logic  input13,
    input  logic  input14,
    input  logic  input15      
);

logic [3:0]  input_selection_o_w;
logic mux16_o_w;
logic sync_out_w;
logic input_source_w;
logic sw_trigger_w;

logic [1:0] mode_w;
logic [9:0] duty_cicle_w;
logic [1:0] prescale_sel_w;
logic [1:0] trigger_selection_w;
logic       out_function_w;
logic [1:0] capture_selection_w;
logic [9:0] target_value_w;
logic [15:0] counter_value_w;
logic        clear;  
logic [15:0] capture_value_w;

always_comb begin
    if(input_selection_o_w==0)
        input_source_w = sw_trigger_w;
    else
        input_source_w = sync_out_w;
end

 RegisterBlock rb(
    
     .clk_i(clk),
     .rstn_i(rstn),
     .acc_en_i(acc_en),
     .wr_en_i(wr_en),
     .addr_i(addr),
     .wdata_i(wdata),
     .rdata_o(rdata),  
     .counter_value_i(counter_value_w[9:0]),
     .capture_value_i(capture_value_w[9:0]),
     .timer_running_i(capture_value_w[12]),    
     .mode_o(mode_w),
     .input_selection_o(input_selection_o_w),
     .trigger_selection_o(trigger_selection_w),
     .out_function_o(out_function_w),
     .capture_selection_o(capture_selection_w),
     .target_value_o(target_value_w), 

     .duty_cicle_limit_o(duty_cicle_w),
     .prescale_sel_o(prescale_sel_w), 

     .clear_o(clear),
     .sw_trigger_o(sw_trigger_w)
);

 mux16 mx(
        .in1(input1),
        .in2(input2),
        .in3(input3),
        .in4(input4),
        .in5(input5),
        .in6(input6),
        .in7(input7),
        .in8(input8),
        .in9(input9),
        .in10(input10),
        .in11(input11),
        .in12(input12),
        .in13(input13),
        .in14(input14),
        .in15(input15),
        .sel(input_selection_o_w),
        .out(mux16_o_w)
);

 synchroniser sync(
        .clk(clk),
        .rst(rstn),
        .async_in(mux16_o_w),
        .sync_out(sync_out_w)
);

 counter_core cc(
            .clk(clk),
            .rstn(rstn),
            .ctrl0({14'd0, mode_w}),
            .pwm_mode({2'd0, prescale_sel_w,2'd0, duty_cicle_w}),
            .cnt_mode0({2'd0, capture_selection_w,3'd0,out_function_w,2'd0, trigger_selection_w,4'd0}),
            .cnt_mode1({6'd0, target_value_w}),
            .counter_value(counter_value_w),
            .command({15'd0, clear}),
            .capture_value(capture_value_w),
            .input_source(input_source_w),
            .out_o(out)

);

endmodule
