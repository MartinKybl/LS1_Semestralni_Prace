clear; close all; clc;

%% 1. Zadaný pracovní bod a fyzikální parametry
Q10 = 60; % [%]
Q20 = 80; % [%]

K2C = 273.15;
tinf = 23 + K2C;   % teplota okolí [K]
m = 4e-3;          % hmotnost topného tělesa [kg]
cp = 500;          % měrná tepelná kapacita [J/(kg*K)]
A = 7e-4;          % povrch topení do okolí [m^2]
As = 12e-4 - A;    % povrch kontaktu mezi tělesy [m^2]
U = 10;            % koeficient přestupu tepla [W/(m^2*K)]
eps = 0.5;         % emisivita [-]
sig = 5.67e-8;     % Stefan-Boltzmannova konstanta [W/(m^2*K^4)]
alfa = 0.01;       % převod výkonu 1. topení [W/%]
alfa2 = 0.0075;    % převod výkonu 2. topení [W/%]

% Pomocné konstanty
k1 = U*A/(m*cp);
k2 = eps*sig*A/(m*cp);
k3 = U*As/(m*cp);
k4 = eps*sig*As/(m*cp);
ku1 = alfa/(m*cp);
ku2 = alfa2/(m*cp);

%% 2. Výpočet pracovního bodu T10, T20 (bod 3b)
% Počáteční odhad (lineární soustava bez T^4)
c1 = k1*tinf + k2*tinf^4 + ku1*Q10;
c2 = k1*tinf + k2*tinf^4 + ku2*Q20;
Arov = [(-k1 - k3), k3; k3, (-k1 - k3)];
xk = Arov \ [-c1; -c2];

% Newtonova metoda pro dT1/dt = 0, dT2/dt = 0
for k = 1:15
    f = [
        k1*(tinf - xk(1)) + k2*(tinf^4 - xk(1)^4) + k3*(xk(2) - xk(1)) + k4*(xk(2)^4 - xk(1)^4) + ku1*Q10;
        k1*(tinf - xk(2)) + k2*(tinf^4 - xk(2)^4) - k3*(xk(2) - xk(1)) - k4*(xk(2)^4 - xk(1)^4) + ku2*Q20
    ];
    J = [
        -4*k2*xk(1)^3 - 4*k4*xk(1)^3 - k1 - k3,   4*k4*xk(2)^3 + k3;
         4*k4*xk(1)^3 + k3,                      -4*k2*xk(2)^3 - 4*k4*xk(2)^3 - k1 - k3
    ];
    xk = xk - J \ f;
end

T10 = xk(1);       % [K]
T20 = xk(2);       % [K]
T10_C = T10 - K2C; % [°C]
T20_C = T20 - K2C; % [°C]

fprintf('=== Úkol 3b: Pracovní bod ===\n');
fprintf('T10 = %.4f K (%.4f °C), T20 = %.4f K (%.4f °C)\n\n', T10, T10_C, T20, T20_C);

%% 3. Lineární numerický model v přírůstkových souřadnicích (bod 3b)
Ass = [-4*k2*T10^3 - 4*k4*T10^3 - k1 - k3,  4*k4*T20^3 + k3;
        4*k4*T10^3 + k3,                   -4*k2*T20^3 - 4*k4*T20^3 - k1 - k3];
Bss = diag([ku1, ku2]);
Css = eye(2);
Dss = zeros(2);

%% 4. Ustálené stavy lineárního a nelineárního modelu (bod 3c)
% Matice statického zesílení lineárního modelu: dT_u = K_stat * dQ
K_stat = -Css * (Ass \ Bss);
fprintf('=== Úkol 3c: Matice statického zesílení K [K/%%] ===\n');
disp(K_stat);

Q1_range = linspace(0, 100, 101);
T1_lin   = zeros(size(Q1_range));
T2_lin   = zeros(size(Q1_range));
T1_nelin = zeros(size(Q1_range));
T2_nelin = zeros(size(Q1_range));

xk_step = [T10; T20];

for i = 1:length(Q1_range)
    Q1 = Q1_range(i);

    % a) Ustálený stav lineárního modelu (dQ2 = 0, tj. Q2 = Q20)
    dQ = [Q1 - Q10; 0];
    dT_u = K_stat * dQ;
    T1_lin(i) = (T10 + dT_u(1)) - K2C;
    T2_lin(i) = (T20 + dT_u(2)) - K2C;

    % b) Ustálený stav nelineárního modelu pro Q1 a fixní Q20 (bod 3a)
    for k = 1:15
        f = [
            k1*(tinf - xk_step(1)) + k2*(tinf^4 - xk_step(1)^4) + k3*(xk_step(2) - xk_step(1)) + k4*(xk_step(2)^4 - xk_step(1)^4) + ku1*Q1;
            k1*(tinf - xk_step(2)) + k2*(tinf^4 - xk_step(2)^4) - k3*(xk_step(2) - xk_step(1)) - k4*(xk_step(2)^4 - xk_step(1)^4) + ku2*Q20
        ];
        J = [
            -4*k2*xk_step(1)^3 - 4*k4*xk_step(1)^3 - k1 - k3,   4*k4*xk_step(2)^3 + k3;
             4*k4*xk_step(1)^3 + k3,                           -4*k2*xk_step(2)^3 - 4*k4*xk_step(2)^3 - k1 - k3
        ];
        xk_step = xk_step - J \ f;
    end
    T1_nelin(i) = xk_step(1) - K2C;
    T2_nelin(i) = xk_step(2) - K2C;
end

%% 5. Vykreslení statických charakteristik do dvou grafů (bod 3c)
figure('Name', 'Staticke charakteristiky (3c)');


fig = figure;
theme(fig, 'light'); % přepne tmavý motiv grafu na světlý (MATLAB R2023b+)
set(fig, 'Color', 'w'); % zajistí čistě bílé vnější pozadí okna
subplot(2,1,1);
plot(Q1_range, T1_nelin, 'b-', 'LineWidth', 1.8); hold on;
plot(Q1_range, T1_lin, 'r--', 'LineWidth', 1.5);
plot(Q10, T10_C, 'ko', 'MarkerSize', 7, 'MarkerFaceColor', 'g');
grid on;
xlabel('Výkon prvního topení Q_1 [%]');
ylabel('Ustálená teplota T_1 [°C]');
title('Statická charakteristika pro T_1 (Q_{20} = 80 %)');
legend('Nelineární model', 'Lineární model', 'Pracovní bod', 'Location', 'NorthWest');

subplot(2,1,2);
plot(Q1_range, T2_nelin, 'b-', 'LineWidth', 1.8); hold on;
plot(Q1_range, T2_lin, 'r--', 'LineWidth', 1.5);
plot(Q10, T20_C, 'ko', 'MarkerSize', 7, 'MarkerFaceColor', 'g');
grid on;
xlabel('Výkon prvního topení Q_1 [%]');
ylabel('Ustálená teplota T_2 [°C]');
title('Statická charakteristika pro T_2 (Q_{20} = 80 %)');
legend('Nelineární model', 'Lineární model', 'Pracovní bod', 'Location', 'NorthWest');