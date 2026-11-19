%% Skript pro kontrolu ustálené okolní teploty
% Inicializace hardwaru
tclab;

% Zajištění nulového výkonu na obou topeních
h1(0); 
h2(0);

disp('Měřím aktuální teplotu (topení jsou vypnuta).');
disp('Pro předčasné ukončení stiskněte Ctrl+C v Command Window.');

% Cyklus poběží 60 sekund (hodnotu lze libovolně upravit)
for i = 1:600
    tic; % Začátek měření času pro přesné vzorkování
    
    % Čtení reálné teploty z obou senzorů
    t1 = T1C();
    t2 = T2C();
    
    % Výpis hodnot do konzole v reálném čase
    fprintf('Čas: %3d s | Teplota T1: %5.2f °C | Teplota T2: %5.2f °C\n', i, t1, t2);
    
    % Zajištění vzorkovací periody 1 sekunda
    t = toc;
    pause(max(0.01, 1.0 - t)); 
end

disp('Monitorování dokončeno.');