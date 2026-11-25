% Vstupní data (osa X v procentech, osa Y naměřené hodnoty)
x = [10, 25, 40, 60, 80, 100];
teleso1 = [32, 44.5, 58, 76, 88.5, 100];
teleso2 = [26.5, 30.5, 34.5, 42, 45, 47];

% Vytvoření grafu
figure;

fig = figure;
theme(fig, 'light'); % přepne tmavý motiv grafu na světlý (MATLAB R2023b+)
set(fig, 'Color', 'w'); % zajistí čistě bílé vnější pozadí okna

plot(x, teleso1, '-o', 'LineWidth', 1.5, 'MarkerSize', 6); % Spojení přímkou + body
hold on; % Umožní vykreslit druhou křivku do stejného grafu
plot(x, teleso2, '-s', 'LineWidth', 1.5, 'MarkerSize', 6);
hold off;

% Popisky, mřížka a legenda
grid on;
title('Závislost hodnot pro Těleso 1 a Těleso 2');
xlabel('Procenta [%]');
ylabel('Naměřená hodnota');
legend('Těleso 1', 'Těleso 2', 'Location', 'northwest');