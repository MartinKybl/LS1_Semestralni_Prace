clear; close all; clc;

%% Definice konstant (Zadání 2d)
T_poc = 23 + 273.15;        % počáteční teplota [K]
m = 0.004;                  % hmotnost [kg]
c_p = 500;                  % měrná tepelná kapacita [J/(kg*K)]
T_ok = 23 + 273.15;         % teplota okolí [K]

A = 7e-4;                    % plocha [m^2]
U = 10;                     % koeficient přestupu do okolí [W/(m^2*K)]
sigma = 5.670374e-8;        % Stefan-Boltzmannova konstanta [W/(m^2*K^4)]
epsilon = 0.5;              % emisivita [-]

alfa = 0.01;                % převod z procent na watty [W/%]

%% Spuštění simulace
out = sim("mat_model_1_teleso.slx");

%% Vykreslení výstupu ze Simulinku
fig = figure(1);
theme(fig, 'light');        % světlý motiv grafu (MATLAB R2023b+)
set(fig, 'Color', 'w');     % bílé vnější pozadí okna

plot(out.T_out.Time, out.T_out.Data, 'b', 'LineWidth', 2);

% Popisky, legenda a mřížka
xlabel('Čas [s]');
ylabel('Teplota [°C]');
title('Přechodový děj odezvy modelu v Simulinku');
legend('Simulace (mat\_model\_1\_teleso)');
xlim([0 max(out.T_out.Time)]);
ylim([0 100]);
grid on;