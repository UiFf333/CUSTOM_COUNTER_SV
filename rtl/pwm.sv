module pwm #(
    parameter Np=10
)(  input logic                  clk_i,
    input logic                  clear,
    input logic                 rstn_i,
    input logic [1:0]     prescale_sel,
    input logic [9:0] duty_cicle_limit,
    output logic                   pwm,
    output logic [9:0]   counter_value,
    output logic            is_running
);


localparam limit0 = 292; // Pentru 100 Hz
localparam limit1 = 145; // Pentru 200 Hz
localparam limit2 = 91;  // Pentru 320 Hz
localparam limit3 = 72;  // Pentru 400 Hz

logic [Np-1:0] limit_f1;
localparam limit_f2=1023;

always_comb begin
    case(prescale_sel)
    0:limit_f1=limit0;
    1:limit_f1=limit1;
    2:limit_f1=limit2;
    3:limit_f1=limit3;
default:limit_f1=0;
    endcase
end

logic  prescalar;

 Prescalar  #(
    .Np(Np)
)presc(
    .rstn(rstn_i),
    .clk(clk_i),
    .limit_f1(limit_f1),
    .prescalar(prescalar)
);


logic [Np-1:0] reg_o;
logic [Np-1:0] in_reg;

always_comb begin
    if(reg_o==limit_f2)
        in_reg=0;
    else 
        in_reg=reg_o+1;
end
 register_pwm registru(
    .clk(clk_i),
    .rstn(rstn_i),
    .en(prescalar),
    .clear(clear),
    .in(in_reg),
    .out(reg_o)
);

assign pwm=reg_o<duty_cicle_limit;
assign is_running=reg_o!=0;
assign counter_value=reg_o;

endmodule
