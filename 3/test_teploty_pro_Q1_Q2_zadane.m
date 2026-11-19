close all; clear all; clc

% Inicializace TCLab (definice funkcí h1, h2, T1C, T2C, led)[cite: 5, 6]
tclab;

disp('Mereni ustalene teploty pro Q1 = 60 % a Q2 = 80 %')

figure(1)
t1s = [];
t2s = [];
h1s = [];
h2s = [];

% Nastavení konstantních výkonů topení[cite: 5, 6]
ht1 = 60;
ht2 = 80;
h1(ht1);
h2(ht2);

h1 = @(level) writePWMDutyCycle(a,'D3',max(0,min(100,level))*1.0/100);
h2 = @(level) writePWMDutyCycle(a,'D5',max(0,min(100,level))*1.0/100);

N = 600; % Doba měření v sekundách (pro dosažení ustáleného stavu)[cite: 3, 6]

for i = 1:N
    tic;
    
    % Měření teplot ve stupních Celsia[cite: 5, 6]
    t1 = T1C();
    t2 = T2C();

    % Indikace teploty pomocí LED[cite: 6]
    brightness1 = (t1 - 30)/50.0;
    brightness2 = (t2 - 30)/50.0;
    brightness = max(0, min(1, max(brightness1, brightness2)));
    led(brightness);
    
    % Ukládání a vykreslování dat[cite: 6]
    h1s = [h1s, ht1];
    h2s = [h2s, ht2];
    t1s = [t1s, t1];
    t2s = [t2s, t2];
    
    n = length(t1s);
    time = 0:(n-1);
    
    clf
    subplot(2,1,1)
    plot(time, t1s, 'r.', 'MarkerSize', 10); hold on
    plot(time, t2s, 'b.', 'MarkerSize', 10);
    ylabel('Temperature (degC)')
    legend('Temperature 1', 'Temperature 2', 'Location', 'NorthWest')
    grid on
    
    subplot(2,1,2)
    plot(time, h1s, 'r-', 'LineWidth', 2); hold on
    plot(time, h2s, 'b--', 'LineWidth', 2);
    ylabel('Heater (%)')
    xlabel('Time (sec)')
    legend('Heater 1', 'Heater 2', 'Location', 'NorthWest')
    grid on
    drawnow;
    
    t = toc;
    pause(max(0.01, 1.0 - t))
end

% Výpis ustálených teplot (průměr z posledních 10 vzorků proti šumu)[cite: 6, 8]
T1_ust = mean(t1s(end-9:end));
T2_ust = mean(t2s(end-9:end));
disp(['Ustalena teplota T1: ' num2str(T1_ust) ' degC'])
disp(['Ustalena teplota T2: ' num2str(T2_ust) ' degC'])

% Vypnutí topení a LED[cite: 6, 8]
disp('Turn off heaters')
h1(0);
h2(0);
led(0);