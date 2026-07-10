module timer_mode(
    input logic                 clk,
    input logic                rstn,
    input logic        input_source,
    input logic [1:0]   mode_select,
    input logic [9:0]  target_value,
    input                     clear,
    output logic [9:0] capture_register,
    input logic [1:0] capture_select,
    output logic [9:0]      counter,
    output logic         is_running
);

logic rise_event;
logic fall_event;
logic     cnt_en;
logic capture_en;

event_detector cm(
    .clk_i(clk),
    .rstn_i(rstn),
    .input_source(input_source),
    .rise_event(rise_event),
    .fall_event(fall_event)
);

always_comb begin
    case(mode_select)
        2'b00: cnt_en = rise_event;
        2'b01: cnt_en = fall_event;
        2'b10: cnt_en = rise_event || fall_event;
        default: cnt_en = 0;
    endcase
end

always_comb begin
    case(capture_select)
        2'b00: capture_en = rise_event;
        2'b01: capture_en = fall_event;
        2'b10: capture_en= rise_event || fall_event;
        default: capture_en = 0;
    endcase
end


always_ff @(posedge clk or negedge rstn) begin
    
    if(rstn == 0) begin
        counter <= 0;
        is_running <= 0;
    end
    else if(clear == 1) begin
        counter <= 0;
        is_running <= 0;
    end
    else if(cnt_en) begin
        counter <= 1;
        is_running <= 1;     
    end
    else if(counter >= target_value && is_running == 1) begin
        counter <= 0;
        is_running <= 0;
    end
    else if(is_running == 1) begin
        counter <= counter + 1;
    end

end

always_ff @(posedge clk or negedge rstn) begin
    if(rstn == 0)
        capture_register <= 0;
    else if(capture_en) begin
        capture_register <= counter;
    end
end
endmodule
