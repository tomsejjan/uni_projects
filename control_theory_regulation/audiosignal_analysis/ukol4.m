clc
close all
clearvars

[ft, Fs] = audioread("C:\Users\tomse\Matlab\Projekt\256421.wav");
%audiowrite("256421a.wav",ft,10933);

N = length(ft);
t = (0:N-1)/Fs;
k = 0:(N-1);
c = fftshift(fft(ft)/N);
w = (-N/2:N/2-1)*Fs/N*2*pi;
wm = abs(w) <= 68000;
lm = wm(:).*c;
lt = ifft(ifftshift(lm)*N);

wl = 21503;
T = 1/wl;
p = tf('p');
Fp = 1/(T*p+1)^2;

Ts = 1/Fs;
z = tf('z',Ts);
Fz = 1 - (z - 1) / (z - exp(-Ts/T)) - Ts/T *(z - 1)*exp(-Ts/T)/(z - exp(-Ts/T))^2;
minreal(Fz,1e-4);
Fz_c2d = c2d(Fp,Ts);

%Konstanty pro diferenční rovnici
a = 1.228;
b = 0.3771;
c = 0.08647;
d = 0.06245;
e = 1;

u = ft;
y(1) = 0;
y(2) = a * y(1) + c * u(1);
%Fz_c2d =
% 
%   0.08647 z + 0.06245
%  ----------------------
%  z^2 - 1.228 z + 0.3771
for m = 3:N
    y(m) = a * y(m-1) - b * y(m-2) + c * u(m-1) + d * u(m-2);
end

citatel =  [0, c, d];
jmenovatel = [e, -a, b];
figure('Name','Úkol č.4: Realizace číslicového filtru - KONTROLA');
ylim("auto");
y2 = filter(citatel,jmenovatel,ft);
subplot(2,1,2);
plot(k,lt, DisplayName='Filtrace z úkolu 1', LineStyle='-', Color='c',LineWidth=1.25);
hold on;
plot(k,y, DisplayName='Filtrace pomocí for cyklu', LineStyle='-', Color='r', LineWidth=1.25);
plot(k,y2, DisplayName='Filtrace pomocí funkce filter',LineStyle='--',Color='b', LineWidth=1.25);
legend;
title('Filtrovaný signál - kontrola správnosti, jen prvních 100 VZORKŮ');
xlabel('k [-]');
xlim([0 100]);
ylabel('y [-]');
hold off;
grid on;

subplot(2,1,1);
plot(k,ft);
xlim([0 100]);
xlabel('k [-]');
ylabel('y [-]');
grid on;
title('Původní signál obsahující rušení - kontrola správnosti, jen prvních 100 VZORKŮ');


figure('Name','Úkol č.4: Realizace číslicového filtru');
ylim("auto");
y2 = filter(citatel,jmenovatel,ft);
subplot(2,1,2);
plot(k,lt, DisplayName='Filtrace z úkolu 1', LineStyle='-', Color='c',LineWidth=1.25);
hold on;
plot(k,y, DisplayName='Filtrace pomocí for cyklu', LineStyle='-', Color='r', LineWidth=1.25);
plot(k,y2, DisplayName='Filtrace pomocí funkce filter',LineStyle='--',Color='b', LineWidth=1.25);
legend;
title('Filtrovaný signál');
xlabel('k [-]');
ylabel('y [-]');
xlim([0 12.3e5]);
hold off;
grid on;

subplot(2,1,1);
plot(k,ft);
xlabel('k [-]');
ylabel('y [-]');
grid on;
xlim([0 12.3e5]);
title('Původní signál obsahující rušení');
