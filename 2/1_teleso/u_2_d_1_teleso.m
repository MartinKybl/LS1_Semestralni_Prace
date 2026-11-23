%% definice konstant
T_poc = 23 + 273.15;
m = 0.004; %hmotnost
c_p = 500; %tep. kapacita.
T_ok = 23 + 273.15; %musi byt v kelvinech

A = 7e-4;  %ploacha


U = 10; %koeficient přestupu do okolí
sigma = 5.670374e-8; %stefan-boltzmanova konstanta
epsilon = 0.5; %emisivita

alfa = 0.01; %převod z procent na watty

%% Spuštění simulace pro pozdější porovnání
out = sim("mat_model_1_teleso.slx");

%% Vykreslení simulace a manuálně definovaného vstupu (Zadání 2d)
t = out.T_out.Time; % časový vektor ze simulace

% Manuální vytvoření vstupu: 50 % pro čas od 1 do 900 s, jinak 0 %
Q1_man = zeros(size(t));
Q1_man(t >= 1 & t <= 900) = 50;

fig = figure(2);
theme(fig, 'light');   % přepne tmavý motiv grafu na světlý (MATLAB R2023b+)
set(fig, 'Color', 'w'); % zajistí čistě bílé vnější pozadí okna

% Levá osa Y: Simulovaná teplota
yyaxis left
plot(t, out.T_out.Data, 'b', 'LineWidth', 2);
ylabel('Teplota [°C]');
ylim([0 100]);
xlim([0 1800]);

% Pravá osa Y: Vstupní signál topení Q_1
yyaxis right
stairs(t, Q1_man, 'Color', [1 0.5 0], 'LineWidth', 1.8);
ylabel('Výkon topení Q_1 [%]');
ylim([-5 105]);

% Popisky, legenda a mřížka
xlabel('Čas [s]');
legend('Simulace', 'Vstup topení Q_1', 'Location', 'NorthEast');
grid on;