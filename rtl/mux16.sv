module mux16(
    input logic in1,
    input logic in2,
    input logic in3,
    input logic in4,
    input logic in5,
    input logic in6,
    input logic in7,
    input logic in8,
    input logic in9,
    input logic in10,
    input logic in11,
    input logic in12,
    input logic in13,
    input logic in14,
    input logic in15,
    input logic [3:0] sel,
    output logic out
);

always_comb begin
    case(sel)
        0:  out = 1'b0;   
        1:  out = in1;
        2:  out = in2;
        3:  out = in3;
        4:  out = in4;
        5:  out = in5;
        6:  out = in6;
        7:  out = in7;
        8:  out = in8;
        9:  out = in9;
        10: out = in10;
        11: out = in11;
        12: out = in12;
        13: out = in13;
        14: out = in14;
        15: out = in15;
        default: out = 1'b0;
    endcase
end

endmodule
