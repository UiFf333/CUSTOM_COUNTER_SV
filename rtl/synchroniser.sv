module synchroniser(
        input logic clk,
        input logic rst,
        input logic async_in,
        output logic sync_out
);

logic ff1_o;

always_ff @(posedge clk or negedge rst) begin
    if(rst==0) begin
        ff1_o<=0;
        sync_out<=0;
    end
    else begin
    ff1_o<=async_in;
    sync_out<=ff1_o;
    end
end

endmodule
