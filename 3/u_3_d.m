%% Inicializace hardwaru
tclab;


figure(1);

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


for i = 1:1800
    tic;
    
    if i == 1 
        disp('Zapnutí topení 1')
        ht1 = 100;
        h1(ht1);
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