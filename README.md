F_clk=40MHz=40*10^6Hz -> Tclk=25 ns

resolution=limit_f2=999
duty_cicle  0%=0
duty_cicle 25%=250
duty_cicle 50%=500
duty_cicle 75%=750
duty_cicle 1000%=999

F1=100Hz -> T=10 ms
F2=200Hz -> T=5 ms
F3=320Hz -> T=3.125 ms
F4=400Hz -> t=2.5 ms

F_pwm=Fclk/(prescalar*(limit_f2+1))
