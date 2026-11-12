%% definice konstant
T_poc = 298.15;%pro SIML integrator, v kelvinech, momentalne je to 25 stupnu C
m = 0.004;
c_p = 500;
T_ok = 293.15; %musi byt v kelvinech
area = 0.0012;
U = 10;
sigma = 5.670374e-8; %stefan-boltzmanova konstanta
epsilon = 0.9; %emisivita (0,1), zatim vychozi hodnota protože nefungujou stranky TCLabu
%% Spuštění simulace pro pozdější porovnání
out = sim("mat_model_1_teleso.slx");

%% Inicializace hardwaru
tclab;

% Nastavení obou topení na 0
h1(0); 
h2(0); 

%Vytvoření polí
t1s = [];
h1s = [];
cas = [];

tic;
cas_start = toc;
ht1 = 0;


for i = 1:1200
    t_akt = toc - cas_start;
    
    if i == 1
        disp('Zapnutí topení 1 na 50 %')
        ht1 = 50;
        h1(ht1);
    end
    if i == 600
        disp('Vypnutí topení 1 na 0 %')
        ht1 = 0;
        h1(ht1);
    end
    
    % Čtení a ukládání
    t1 = T1C();
    t1s = [t1s, t1];
    h1s = [h1s, ht1];
    cas = [cas, t_akt];
    
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
plot(cas, t1s, 'r', 'LineWidth', 2); hold on;
% Předpokládá se standardní formát výstupu ze Simulinku 
% Pokud máte pole přímo v out, upravte volání (např. out.tout, out.T_out)
plot(out.T_out.Time, out.T_out.Data, 'b', 'LineWidth', 2);
title('Porovnání reálného systému a matematického modelu');
xlabel('Čas (s)'); ylabel('Teplota');
legend('Reálný systém TCLab', 'Simulace (mat_model.slx)', 'Location', 'SouthEast');
grid on;