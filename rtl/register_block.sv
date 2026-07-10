module RegisterBlock(
    input  logic        clk_i,
    input  logic        rstn_i,
    input  logic        acc_en_i,
    input  logic        wr_en_i,
    input  logic [2:0]  addr_i,
    input  logic [15:0] wdata_i,
    output logic [15:0] rdata_o,

    input  logic [9:0]  counter_value_i,
    input  logic [9:0]  capture_value_i,
    input  logic        timer_running_i,
    
    output logic [1:0]  mode_o,
    output logic [3:0]  input_selection_o,
    output logic [1:0]  trigger_selection_o,
    output logic        out_function_o,
    output logic [1:0]  capture_selection_o,
    output logic [9:0]  target_value_o,
    
    output logic [9:0]  duty_cicle_limit_o,
    output logic [1:0]  prescale_sel_o,       

    output logic        clear_o,
    output logic        sw_trigger_o
);

logic [15:0] ctrl0;
logic [15:0] pwm_mode;
logic [15:0] cnt_mode0;
logic [15:0] cnt_mode1;

always_ff @(posedge clk_i or negedge rstn_i) begin
    if (rstn_i==0) begin
        ctrl0     <= 16'd0;
        pwm_mode  <= 16'd0;
        cnt_mode0 <= 16'd0;
        cnt_mode1 <= 16'd0;
    end
    else if (acc_en_i && wr_en_i) begin
        case(addr_i)
            3'd0: ctrl0     <= wdata_i;
            3'd1: pwm_mode  <= wdata_i;
            3'd2: cnt_mode0 <= wdata_i;
            3'd3: cnt_mode1 <= wdata_i;
        endcase
    end
end

always_comb begin
    rdata_o = 16'd0; 

    if (acc_en_i && !wr_en_i) begin
        case(addr_i)
            3'd0: rdata_o = ctrl0;
            3'd1: rdata_o = pwm_mode;
            3'd2: rdata_o = cnt_mode0;
            3'd3: rdata_o = cnt_mode1;
            3'd4: rdata_o = {6'd0, counter_value_i};
            3'd6: rdata_o = {3'd0, timer_running_i, 2'd0, capture_value_i}; 
            default: rdata_o = 16'd0;
        endcase
    end
end

assign mode_o              = ctrl0[1:0];
assign input_selection_o   = cnt_mode0[3:0];
assign trigger_selection_o = cnt_mode0[5:4];
assign out_function_o      = cnt_mode0[8];
assign capture_selection_o = cnt_mode0[13:12];
assign target_value_o      = cnt_mode1[9:0];

assign sw_trigger_o        = (acc_en_i && wr_en_i && (addr_i == 3'd5) && wdata_i[4]);
assign clear_o             = (acc_en_i && wr_en_i && (addr_i == 3'd5) && wdata_i[0]);
assign duty_cicle_limit_o  = pwm_mode[9:0];
assign prescale_sel_o      = pwm_mode[13:12];

endmodule
