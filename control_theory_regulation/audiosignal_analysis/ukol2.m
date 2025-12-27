clc
close all
clearvars

[ft, Fs] = audioread("C:\Users\tomse\Matlab\Projekt\256421.wav");
%audiowrite("256421a.wav",ft,10933);

wl = 21503;
T = 1/wl;
p = tf('p');
Fp = 1/(T*p+1)^2;

figure('Name','Úkol č.2: Návrh spojitého filtru');
bode(Fp);
xlabel('w');
grid on;