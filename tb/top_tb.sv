`timescale 1ns / 1ps

module top_tb();

logic        clk_w;             
logic        rstn_w;
logic        acc_en_w;
logic        wr_en_w;
logic [2:0]  addr_w;
logic [15:0] wdata_w;
logic [15:0] rdata_w;
logic        out_w;
 
logic input1_w, input2_w, input3_w, input4_w, input5_w;
logic input6_w, input7_w, input8_w, input9_w, input10_w;
logic input11_w, input12_w, input13_w, input14_w, input15_w;

top tp(
    .clk(clk_w),
    .rstn(rstn_w),
    .acc_en(acc_en_w),
    .wr_en(wr_en_w),
    .addr(addr_w),
    .wdata(wdata_w),
    .rdata(rdata_w),
    .out(out_w),
    .input1(input1_w), .input2(input2_w), .input3(input3_w),
    .input4(input4_w), .input5(input5_w), .input6(input6_w),
    .input7(input7_w), .input8(input8_w), .input9(input9_w),
    .input10(input10_w), .input11(input11_w), .input12(input12_w),
    .input13(input13_w), .input14(input14_w), .input15(input15_w)
);

initial begin
    clk_w = 0;
    forever #1 clk_w = ~clk_w;
end

initial begin

    rstn_w   = 0;
    acc_en_w = 0;
    wr_en_w  = 0;
    addr_w   = 3'd0;
    wdata_w  = 16'd0;
    
    input1_w=0; input2_w=0; input3_w=0; input4_w=0; input5_w=0;
    input6_w=0; input7_w=0; input8_w=0; input9_w=0; input10_w=0;
    input11_w=0; input12_w=0; input13_w=0; input14_w=0; input15_w=0;
    
    @(posedge clk_w);
    @(posedge clk_w);
    rstn_w = 1; 
    @(posedge clk_w);

    acc_en_w = 1;
    wr_en_w  = 1;

    // //CTRL0-PWM_MODE
    // addr_w  = 3'd0; 
    // wdata_w = 16'h0001; 
    // @(posedge clk_w);

    // // Adresa 1: DUTY 50% 100Hz
    // addr_w  = 3'd1; 
    // wdata_w = {2'b00, 2'b00, 2'b00, 10'd512}; 
    // @(posedge clk_w);
    // #15000000;

    // // Adresa 1: DUTY 50% 200Hz
    // addr_w  = 3'd1; 
    // wdata_w = {2'b00, 2'b01, 2'b00, 10'd512}; 
    // @(posedge clk_w);
    // #10000000;

    // // Adresa 1: DUTY 50% 320Hz
    // addr_w  = 3'd1; 
    // wdata_w = {2'b00, 2'b10, 2'b00, 10'd512}; 
    // @(posedge clk_w);
    // #6000000;
    // // Adresa 1: DUTY 50% 400Hz
    // addr_w  = 3'd1; 
    // wdata_w = {2'b00, 2'b11, 2'b00, 10'd512}; 
    // @(posedge clk_w);
    // #5000000;

    //CTRL0-COUNTER_MODE
    @(posedge clk_w);
     addr_w  = 3'd0; 
    wdata_w = 16'h0002; 
    @(posedge clk_w);
    addr_w  = 3'd2; 
    wdata_w = {2'b00,2'b00,3'b000,1'b1, 2'b00, 2'b00, 4'b0001};
    @(posedge clk_w);
    addr_w  = 3'd3;
    wdata_w = 16'd3;
    @(posedge clk_w);
    acc_en_w = 1;
    wr_en_w  = 0;
    addr_w  = 3'd6;
    for(int i=0; i<16; i++) begin
        @(negedge clk_w);
        @(negedge clk_w);
        @(negedge clk_w);
        @(negedge clk_w);
        input1_w=~input1_w; 
    end
    $stop();
end

endmodule