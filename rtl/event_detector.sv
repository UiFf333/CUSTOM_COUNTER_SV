module event_detector (
    input logic             clk_i,
    input logic            rstn_i,
    input logic      input_source,
    output logic       rise_event,
    output logic       fall_event
);

logic Q;
    always_ff @(posedge clk_i or negedge rstn_i) begin
        if(rstn_i==0) begin
            Q<=0;
        end
        else
        Q<=input_source; 
    end

assign rise_event=~Q && input_source;
assign fall_event= Q && ~input_source;
endmodule
