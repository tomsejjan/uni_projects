clc
close all
clearvars

[ft, Fs] = audioread("C:\Users\tomse\Matlab\Projekt\256421.wav");
%audiowrite("256421a.wav",ft,10933);

wl = 21503;
T = 1/wl;
Ts = 1/Fs;
z = tf('z',Ts);
Fz = 1 - (z - 1) / (z - exp(-Ts/T)) - Ts/T *(z - 1)*exp(-Ts/T)/(z - exp(-Ts/T))^2;
minreal(Fz,1e-4);
p = tf('p');
Fp = 1/(T*p+1)^2;
Fz_c2d = c2d(Fp,Ts);

figure('Name','Úkol č.3: Diskretizace');
subplot(2,2,1);
hold on;
xlim([0 5e-4]);

[y_step, t_step] = step(Fp, 0.5e-3);
plot(t_step, y_step,DisplayName= 'Spojitý systém',Color = [1 0 1],LineWidth=2.5);

[y_step, t_step] = step(Fz, 0.5e-3);
stairs(t_step,y_step,DisplayName='Diskrétní systém',LineWidth=2.5,LineStyle='-',Color=[0.9290 0.6940 0.1250]);

[y_step, t_step] = step(Fz_c2d, 0.5e-3);
stairs(t_step,y_step,DisplayName='Diskrétní systém (c2d)',LineStyle='--',Color = 'b',LineWidth=2.5);
grid on;
legend;
hold off;
xlabel('t [s]');
ylabel('y[-]');
title("Přechodové charakteristiky");

subplot(2,2,3);
xlim([0 5e-4]);
hold on;
[y_step, t_step] = impulse(Fp, 0.5e-3);
plot(t_step, y_step,DisplayName= 'Spojitý systém', LineWidth=2.5,Color=[1 0 1]);
[y_step, t_step] = impulse(Fz, 0.5e-3);
stairs(t_step,y_step,DisplayName='Diskrétní systém', LineWidth=2.5,Color=[0.9290 0.6940 0.1250]);
[y_step, t_step] = impulse(Fz_c2d, 0.5e-3);
stairs(t_step,y_step,DisplayName='Diskrétní systém (c2d)',LineStyle='--',Color = 'b',LineWidth=2.5);
hold off;
grid on;
legend;
xlabel('t [s]');
ylabel('y[-]');
title("Impulzové charakteristiky");

subplot(2,2,2);
[mag,ph_step, f_step]=bode(Fp);
mag_step = squeeze(mag);
semilogx(f_step, 20*log10(mag_step),DisplayName= 'Spojitý systém', LineWidth=2.5,Color=[1 0 1]);
hold on;
[mag,ph_step, f_step]=bode(Fz);
mag_step = squeeze(mag);
semilogx(f_step, 20*log10(mag_step),DisplayName='Diskrétní systém', LineWidth=2.5,Color=[0.9290 0.6940 0.1250]);
grid on;
[mag,ph_step, f_step]=bode(Fz_c2d);
mag_step = squeeze(mag);
semilogx(f_step, 20*log10(mag_step),DisplayName='Diskrétní systém (c2d)',LineStyle='--',Color = 'b',LineWidth=2.5);
grid on;
xlim([0 1e5]);
legend;
xlabel('\omega [rad \cdot s^{-1}]');
ylabel('|F(jw)| [dB]');
title('Amplitudová frekvenční charakteristika');

subplot(2,2,4);
[mag,ph, f_step] = bode(Fp);
ph_step = squeeze(ph);
semilogx(f_step, ph_step,DisplayName= 'Spojitý systém', LineWidth=2,Color=[1 0 1]);
hold on;
[mag,ph, f_step] = bode(Fz);
ph_step = squeeze(ph);
semilogx(f_step, ph_step,DisplayName='Diskrétní systém', LineWidth=2,Color=[0.9290 0.6940 0.1250]);
grid on;
[mag,ph, f_step] = bode(Fz_c2d);
ph_step = squeeze(ph);
semilogx(f_step, ph_step,DisplayName='Diskrétní systém (c2d)',LineStyle='--',Color = 'b',LineWidth=2);
grid on;
legend;
title('Fázová frekvenční charakteristika');
xlabel('\omega [rad \cdot s^{-1}]');
ylabel('\phi [°]');