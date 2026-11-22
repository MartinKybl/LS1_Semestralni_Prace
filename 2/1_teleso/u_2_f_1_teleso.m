%% definice konstant
T_poc = 23 + 273.15;
m = 0.004; %hmotnost
c_p = 500; %tep. kapacita.
T_ok = 23 + 273.15; %musi byt v kelvinech

A = 0.0012; %ploacha


U = 10; %koeficient přestupu do okolí
sigma = 5.670374e-8; %stefan-boltzmanova konstanta
epsilon = 0.9; %emisivita

alfa = 0.02; %převod z procent na watty

%% Spuštění simulace pro pozdější porovnání
out = sim("mat_model_1_teleso.slx");

%% Inicializace hardwaru
tclab;


h1 = @(level) writePWMDutyCycle(a,'D3',max(0,min(100,level))*1.0/100);

% Nastavení obou topení na 0
h1(0); 
h2(0); 

%Vytvoření polí
t1s = [];
h1s = [];
cas = [];
ht1 = 0;
figure(1);

for i = 1:1800
    tic;
    
    if i == 1
        disp('Zapnutí topení 1 na 50 %')
        ht1 = 50;
        h1(ht1);
    end
    if i == 900
        disp('Vypnutí topení 1 na 0 %')
        ht1 = 0;
        h1(ht1);
    end
    
    % Čtení a ukládání
    t1 = T1C();
    t1s = [t1s, t1];
    h1s = [h1s, ht1];

    n = length(t1s);
    cas = linspace(0,n+1,n);
    
    % Vykreslování průběžného stavu
    clf;
    subplot(2,1,1);
    plot(cas, t1s, 'r.', 'MarkerSize', 10);
    ylabel('Teplota (°C)'); title('Průběh experimentu');
    
    subplot(2,1,2);
    plot(cas, h1s, 'r-', 'LineWidth', 2);
    ylabel('Výkon topení (%)'); xlabel('Čas (s)');
    drawnow;
    
    pause(1); % Zajištění kroku cca 1 sekunda
end

% Bezpečnostní vypnutí
disp('Konec a vypnutí');
h1(0);

%% Finální porovnání (Zadání 2f)
figure(2);

fig = figure(2);
theme(fig, 'light'); % přepne tmavý motiv grafu na světlý (MATLAB R2023b+)
set(fig, 'Color', 'w'); % zajistí čistě bílé vnější pozadí okna

% Levá osa Y: Teploty (reálný systém vs. simulace)
yyaxis left
plot(cas, t1s, 'r', 'LineWidth', 2); hold on;
plot(out.T_out.Time, out.T_out.Data, 'b', 'LineWidth', 2);
ylabel('Teplota [°C]');
ylim([0 100]);
xlim([0 1800]);
% Pravá osa Y: Vstupní signál topení
yyaxis right
% 1) Pokud vykreslujete výkon v procentech (0 - 100 %):
stairs(cas, h1s, 'Color', [1 0.5 0], 'LineWidth', 1.8);
ylabel('Výkon topení Q_1 [%]');
ylim([0 100]); % rozsah pro přehledné zobrazení schodu

% Popisky, legenda a mřížka
xlabel('Čas [s]');
legend('Reálný systém TCLab', 'Simulace', 'Vstup topení Q_1');
grid on;