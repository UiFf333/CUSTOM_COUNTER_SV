`timescale 1ns / 1ps

module counter_core_tb();

    // --- Declararea semnalelor ---
    logic        clk;
    logic        rstn;
    logic [15:0] ctrl0;
    logic [15:0] pwm_mode;
    logic [15:0] cnt_mode0;
    logic [15:0] cnt_mode1;
    logic [15:0] command;
    logic        input_source;
    
    logic [15:0] counter_value;
    logic [15:0] capture_value;
    logic        out_o;

    // --- Instanțierea modulului (Unit Under Test) ---
    counter_core dut (
        .clk(clk),
        .rstn(rstn),
        .ctrl0(ctrl0),
        .pwm_mode(pwm_mode),
        .cnt_mode0(cnt_mode0),
        .cnt_mode1(cnt_mode1),
        .counter_value(counter_value),
        .command(command),
        .capture_value(capture_value),
        .input_source(input_source),
        .out_o(out_o)
    );

    // --- Generarea ceasului (Perioada 2ns) ---
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // --- Scenariul de testare ---
    initial begin
        // ==========================================
        // 0. INIȚIALIZARE ȘI RESET
        // ==========================================
        rstn         = 0;
        ctrl0        = 16'd0; 
        pwm_mode     = 16'd0;
        cnt_mode0    = 16'd0;
        cnt_mode1    = 16'd0;
        command      = 16'd0;
        input_source = 0;

        @(negedge clk);
        @(negedge clk);
        rstn = 1;
        @(negedge clk);

        // Activăm modul PWM (bit 0 = 1)
        ctrl0 = 16'h0001; 
        @(negedge clk);

        // ==========================================
        // FRECVENȚA 1: 100 Hz (2'b00) | Duty: 250
        // Perioadă = 10ms. Așteptăm 25ms (2.5 cicluri)
        // ==========================================
        
        pwm_mode = {2'b00, 2'b00, 2'b00, 10'd250}; 
        #25_000_000;

        // ==========================================
        // FRECVENȚA 2: 200 Hz (2'b01) | Duty: 250
        // Perioadă = 5ms. Așteptăm 12.5ms (2.5 cicluri)
        // ==========================================
       
        pwm_mode = {2'b00, 2'b01, 2'b00, 10'd250}; 
        #12_500_000;

        // ==========================================
        // FRECVENȚA 3: 320 Hz (2'b10) | Duty: 250
        // Perioadă = ~3.125ms. Așteptăm 8ms (~2.5 cicluri)
        // ==========================================
        pwm_mode = {2'b00, 2'b10, 2'b00, 10'd250}; 
        #8_000_000;

        // ==========================================
        // FRECVENȚA 4: 400 Hz (2'b11) | Duty: 250
        // Perioadă = 2.5ms. Așteptăm 6.5ms (~2.5 cicluri)
        // ==========================================
        pwm_mode = {2'b00, 2'b11, 2'b00, 10'd250}; 
        #6_500_000;

        // ==========================================
        // CLEAR (Curățăm la final)
        // ==========================================
        
        command = 16'h0001; 
        @(negedge clk);
        command = 16'd0;
        @(negedge clk);

        $stop();
    end

endmodule