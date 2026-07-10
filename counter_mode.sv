module counter_mode (
    input logic        clk_i,
    input logic        rstn_i,
    input logic [1:0]  cnt_mode,
    input logic [9:0]  target_value,
    input logic        input_source,
    input logic               clear,
    output logic [9:0]      count_o,
    output logic         is_running,
    output logic [9:0] capture_register,
    input logic [1:0] capture_select
);

logic rise_event;
logic fall_event;
logic count_en;
logic capture_en;

always_comb begin
    case(cnt_mode)
        2'b00: count_en = rise_event;
        2'b01: count_en = fall_event;
        2'b10: count_en = rise_event || fall_event;
        default: count_en = 0;
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

 event_detector cm (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .input_source(input_source),
    .rise_event(rise_event),
    .fall_event(fall_event)
);

always_ff @(posedge clk_i or negedge rstn_i) begin
    
    if(rstn_i==0)begin
        count_o <= 0;
        is_running <= 0;
    end
    else  if(clear==1) begin
        count_o <= 0;
        is_running <= 0;
    end
    else if(count_o>= target_value) begin
        count_o <= 0;
        is_running <= 0;
    end
    else if(count_en)begin
        count_o <= count_o + 1;
        is_running <= 1;  
    end   

    end

    always_ff @(posedge clk_i or negedge rstn_i) begin
        if(rstn_i==0)
            capture_register <= 0;
      else   if(capture_en ) begin
         capture_register <= count_o;
    end    
    end

endmodule 