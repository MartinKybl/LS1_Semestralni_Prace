%% definice konstant
T_poc = 298.15;
m = 0.004;
c_p = 500;
T_ok = 298.15; %musi byt v kelvinech
area = 0.0012;
U = 10;
sigma = 5.670374e-8; %stefan-boltzmanova konstanta
epsilon = 0.9; %emisivita (0,1), zatim vychozi hodnota protože nefungujou stranky TCLabu
K_12 = 0.004; %konstanta????


%% Spuštění simulace pro pozdější porovnání
out = sim("mat_model_2_telesa.slx");

%% Inicializace hardwaru
tclab;

% Nastavení obou topení na 0
h1(0); 
h2(0); 

%Vytvoření polí
t1s = [];
h1s = [];
t2s = [];
h2s = [];
cas = [];

ht1 = 0;
ht2 = 0;


for i = 1:900
    tic;
    
    if i == 1 
        disp('Zapnutí topení 1 na 50 %')
        ht1 = 50;
        h1(ht1);
    end
    if i == 300
        disp('Zapnutí topení 2 na 30 % a 1 na 0%')
        ht2 = 30;
        h2(ht2);

        ht1 = 0;
        h1(ht1);
    end
    if i == 600
        disp('Vypnutí topení 1 a 2 na 0 %')
        ht1 = 0;
        ht2 = 0;
        h1(ht1);
        h2(ht2);
    end
    
    % Čtení a ukládání
    t1 = T1C();
    t1s = [t1s, t1];
    h1s = [h1s, ht1];

    t2 = T2C();
    t2s = [t2s, t2];
    h2s = [h2s, ht2];

    n = length(t1s);
    cas = linspace(0,n+1,n);
    
    % Vykreslování průběžného stavu
    clf;
    subplot(2,2,1);
    plot(cas, t1s, 'r.', 'MarkerSize', 10);
    subplot(2,2,3);
    plot(cas, t2s, 'g.', 'MarkerSize', 10);
    ylabel('Teplota (°C)'); title('Průběh experimentu');
    
    subplot(2,2,2);
    plot(cas, h1s, 'r-', 'LineWidth', 2);
    subplot(2,2,4);
    plot(cas, h2s, 'g-', 'LineWidth', 2);
    ylabel('Výkon topení (%)'); xlabel('Čas (s)');
    drawnow;
    
    pause(1); % Zajištění kroku cca 1 sekunda
end

% Bezpečnostní vypnutí
disp('Konec a vypnutí');
h1(0);

%% Finální porovnání (Zadání 2f)
figure(2);
plot(cas, t1s, 'r', 'LineWidth', 2, 'DisplayName', 'Reálný 1'); hold on;
plot(cas, t2s, 'g', 'LineWidth', 2, 'DisplayName', 'Reálný 2');
% Předpokládá se standardní formát výstupu ze Simulinku 
% Pokud máte pole přímo v out, upravte volání (např. out.tout, out.T_out)
plot(out.T_out_1.Time, out.T_out_1.Data, 'y', 'LineWidth', 2, 'DisplayName', 'Simulace 1');
plot(out.T_out_2.Time, out.T_out_2.Data, 'c', 'LineWidth', 2, 'DisplayName', 'Simulace 2');
title('Porovnání reálného systému a matematického modelu');
xlabel('Čas (s)'); ylabel('Teplota');
legend;
grid on;