clear; close all; clc;

%% Definice konstant (dle zadání a vzorového skriptu)
T_poc = 23 + 273.15;        % Počáteční teplota [K]
T_ok = 21 + 273.15;         % Teplota okolí [K]

m = 0.004;                  % Hmotnost topného tělesa [kg]
c_p = 500;                  % Měrná tepelná kapacita [J/(kg*K)]

A = 7e-4;                   % Plocha přestupu do okolí [m^2]
A_int = 12e-4 - A;          % Interakční plocha mezi tělesy [m^2]

U = 10;                     % Koeficient přestupu tepla [W/(m^2*K)]
sigma = 5.670374e-8;        % Stefan-Boltzmannova konstanta [W/(m^2*K^4)]
epsilon = 0.5;              % Emisivita [-]

alfa = 0.01;                % Přepočet výkonu topení 1 [% -> W]
alfa2 = 0.01;             % Přepočet výkonu topení 2 [% -> W] (opraveno z 0.075)

%% Spuštění simulace v Simulinku
out = sim("mat_model_2_telesa.slx");

%% Vykreslení grafu výsledků simulace
fig = figure(1);
theme(fig, 'light');        % Světlý motiv grafu (MATLAB R2023b+)
set(fig, 'Color', 'w');     % Čistě bílé pozadí okna

plot(out.T_out_1.Time, out.T_out_1.Data, '--r', 'LineWidth', 2, 'DisplayName', 'Simulace T_1');
hold on;
plot(out.T_out_2.Time, out.T_out_2.Data, '--b', 'LineWidth', 2, 'DisplayName', 'Simulace T_2');

xlabel('Čas [s]');
ylabel('Teplota [°C]');
title('Simulace dvou topných těles se vzájemnou interakcí');
ylim([20 70]);
xlim([0 1800]);
legend('Location', 'best');
grid on;