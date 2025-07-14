
clear all
close all

syms t t0
T0 = 36;
a = 21;
alpha = -1.0e-02
T(t) = (T0-a)*exp(alpha*(t-t0))+a;
t0_val = solve(T(12*60+36)==26.8, t0);
d0_val = double(t0_val);
hour = floor(d0_val/60);
minute = floor(d0_val /60 - hour) * 60;
fprintf("Todeszeitpunkt nach erster Messung: %02d:%02d Uhr\n", hour, minute);


