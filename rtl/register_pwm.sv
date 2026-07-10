module register_pwm (
    input logic        clk,
    input logic        rstn,
    input logic        en,
    input logic        clear,
    input logic [9:0]  in,
    output logic [9:0] out
);

always_ff @(posedge clk or negedge rstn) begin
    if(rstn==0 || clear==1)
        out<=0;
    else if(en==1) begin
        out<=in;
    end
        
end

endmodule
