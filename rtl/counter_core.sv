module counter_core(
        input logic clk,
        input logic rstn,
        input logic [15:0] ctrl0,
        input logic [15:0] pwm_mode,
        input logic [15:0] cnt_mode0,
        input logic [15:0] cnt_mode1,
        output logic [15:0] counter_value,
        input logic [15:0] command,
        output logic [15:0] capture_value,
        input logic        input_source,
        output logic       out_o

);

logic pwm_w;
logic is_running_pwm;
logic [9:0] counter_value_pwm;
 pwm #(
    .Np(10)
)pwm(  .clk_i(clk),
    .clear(command[0]),
    .rstn_i(rstn),
    .prescale_sel(pwm_mode[13:12]),
    .duty_cicle_limit(pwm_mode[9:0]),
    .pwm(pwm_w),
    .counter_value(counter_value_pwm),
    .is_running(is_running_pwm)
);

logic [9:0] count_o_counter;
logic [9:0] capture_register_counter;
logic is_running_counter;

 counter_mode cm (
   .clk_i(clk),
   .rstn_i(rstn),
   .cnt_mode(cnt_mode0[5:4]),
   .target_value(cnt_mode1[9:0]),
   .input_source(input_source),
   .clear(command[0]),
   .count_o(count_o_counter),
   .is_running(is_running_counter),
   .capture_register(capture_register_counter),
   .capture_select(cnt_mode0[13:12])
);

logic [9:0] counter_tm;
logic [9:0] capture_register_tm;
logic is_running_tm;

 timer_mode tm(
  .clk(clk),
  .rstn(rstn),
  .input_source(input_source),
  .mode_select(cnt_mode0[5:4]),
  .target_value(cnt_mode1[9:0]),
  .clear(command[0]),
  .capture_register(capture_register_tm),
  .capture_select(cnt_mode0[13:12]),
  .counter(counter_tm),
  .is_running(is_running_tm)
);

logic [1:0] mode_select;

localparam DISABLED = 2'b00;
localparam PWM_MODE = 2'b01;
localparam COUNTER_MODE = 2'b10;
localparam TIMER_MODE = 2'b11;

always_comb begin
    case(ctrl0[1:0])
        DISABLED: mode_select = DISABLED;
        PWM_MODE: mode_select = PWM_MODE;
        COUNTER_MODE: mode_select = COUNTER_MODE;
        TIMER_MODE: mode_select = TIMER_MODE;
        default: mode_select = DISABLED;
    endcase
end

logic target_reached;
logic toggle_state;

always_comb begin
    target_reached = 1'b0;
    if (ctrl0[1:0] == 2'b10 && count_o_counter >= cnt_mode1[9:0] && is_running_counter)
        target_reached = 1'b1;
    else if (ctrl0[1:0] == 2'b11 && counter_tm >= cnt_mode1[9:0] && is_running_tm)
        target_reached = 1'b1;
end

always_ff @(posedge clk or negedge rstn) begin
    if (rstn==0) 
        toggle_state <= 0;
    else if (command[0]) 
        toggle_state <= 0; 
    else if (target_reached) 
        toggle_state <= ~toggle_state;
end


logic is_running;

always_comb begin
     counter_value=16'd0;
     capture_value=16'd0;
     is_running=0;
     out_o = 0;
     
    if(rstn==0) begin
        out_o = 0;
        counter_value = 0;
        capture_value = 0;
        is_running = 0; 
    end
    else if(mode_select == PWM_MODE) begin
        out_o = pwm_w;
        is_running = is_running_pwm;
        counter_value[9:0] = counter_value_pwm;
    end
    else if(mode_select == COUNTER_MODE) begin
        out_o = (cnt_mode0[8]) ? toggle_state : target_reached;
        counter_value[9:0] = count_o_counter;
        capture_value[9:0] = capture_register_counter;
        is_running = is_running_counter;
    end
    else if(mode_select == TIMER_MODE) begin
        out_o = (cnt_mode0[8]) ? toggle_state : target_reached;
        counter_value[9:0] = counter_tm;
        capture_value[9:0] = capture_register_tm;
        is_running = is_running_tm;
    end
    capture_value[12] = is_running;
end

endmodule
