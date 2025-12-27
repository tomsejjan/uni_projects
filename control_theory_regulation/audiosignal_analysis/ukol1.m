clc
close all
clearvars

[ft, Fs] = audioread("C:\Users\tomse\Matlab\Projekt\256421.wav");
%audiowrite("256421a.wav",ft,10933);

N = length(ft);
t = (0:N-1)/Fs;
c = fftshift(fft(ft)/N);
w = (-N/2:N/2-1)*Fs/N*2*pi;
wm = abs(w) <= 68000;
lm = wm(:).*c;
lt = ifft(ifftshift(lm)*N);

figure('Name','Úkol č.1: Analýza a číslicová filtrace signálu');
subplot(2,1,1)
plot(t,ft,"magenta", 'LineWidth',1.2);
hold on;
plot(t, lt,"green",'LineWidth',1.2);
hold off;
title('Vzor signálu');
grid on;
xlim([0 28]);
xlabel('t [s]');
ylabel('y[-]');
legend('Rušivý signál', 'Vzor signálu s odstraněným rušením');
subplot(2,1,2);
semilogx(w(w>0),20*log10(abs(c(w > 0)) ),"magenta", 'LineWidth',1.2);
hold on;
semilogx(w(w>0),20*log10(abs(lm(w > 0)) ),"green", 'LineWidth',1.2);
hold off;

title('Obraz signálu');
grid on;
xlabel('\omega [rad \cdot s^{-1}]');
ylabel('y [dB]');
legend('Obraz rušivého signálu', 'Obraz signálu s odstraněným rušením');
xlim([0 200000]);