% LS1 Semestrální práce
% Pomocný skript pro určení pracovního bodu (konstantní vstupy Q10,Q20 na konstantní výstupní teploty T10,T20)
% a linearizace modelu do formy stavového popisu v okolí pracovního bodu
% Martin Goubej, 2025

clear;
close all;

%Parametry pro simulaci

K2C = 273.15;
%K2C = 0;

t0 = 23; %poc. teplota ve stupnich Celsia
t0 = t0 + K2C;

tinf = 23; %teplota okolniho prostredu
tinf = tinf + K2C;


alfa = 0.01; %skalovani inzenyrskych jednotek z procent na Watty dodavaneho vykonu
alfa2 = 0.0075; %druhe topeni ma mensi vykon 0.75W !

cp = 500; %merna tepelna kapacita topneho telesa
A = 7e-4; %povrch topeni v m^2 - POZOR zmena oproti single-mass modelu, zmenseni ztrat vedenim do prostredi a naopak zvetseni predani tepla mezi telesy
As = 12e-4-A; %povrch kontaktu mezi telesy

m = 4e-3; %hmotnost topneho telesa
U = 10; %koeficient prestupu tepla
eps = 0.5; %emisivita - snizeni z 0.9 od vyrobce, zmenseni ztrat vyzarovanim
sig = 5.67e-8; %SB konstanta


%Priblizna linearizace - zanedbani kvartickych clenu

%Prac.bod
Q10 = 60;
Q20 = 40;


%definice novych pomocnych konstant
k1=U*A/(m*cp);
k2=eps*sig*A/(m*cp);
k3=U*As/(m*cp);
k4=eps*sig*As/(m*cp);
ku1=alfa/(m*cp);
ku2=alfa2/(m*cp);
c1=k1*tinf+k2*tinf^4+ku1*Q10;
c2=k1*tinf+k2*tinf^4+ku2*Q20;

%Analyt. reseni
T10 = (c1*k1+c1*k3+c2*k3)/(k1*(k1+2*k3))
T20 = (c1*k3+c2*k1+c2*k3)/(k1*(k1+2*k3))

%Reseni numericky z linearni soustavy
Arov=[(-k1-k3) k3;k3 (-k1-k3)] %matice koeficientu
brov=[-c1;-c2] %vektor prave strany

x0=Arov\brov %numericke reseni




%% Doiterovani k reseni puvodni nelinearni soustavy - Newtonova metoda druheho radu (viz https://en.wikipedia.org/wiki/Newton%27s_method_in_optimization)

n_it = 10; %pocet iteraci Newtonovy metody
gam = 0.8; %velikost kroku v Newtonovo metode (ladici parametr, rychlost konvergence vs robustnost)

xk=x0; %inicializace


Tplot=zeros(2,n_it);
Tplot(:,1)=xk;

for k=1:n_it
    T10=xk(1);
    T20=xk(2);
    g = [2 * (c1 + T10 * (-k1 - k3) + T20 * k3 + T10 ^ 4 * (-k2 - k4) + T20 ^ 4 * k4) * (-k1 - k3 + 4 * T10 ^ 3 * (-k2 - k4)) + 2 * (c2 + T20 * (-k1 - k3) + T10 * k3 + T20 ^ 4 * (-k2 - k4) + T10 ^ 4 * k4) * (4 * T10 ^ 3 * k4 + k3); 2 * (c1 + T10 * (-k1 - k3) + T20 * k3 + T10 ^ 4 * (-k2 - k4) + T20 ^ 4 * k4) * (4 * T20 ^ 3 * k4 + k3) + 2 * (c2 + T20 * (-k1 - k3) + T10 * k3 + T20 ^ 4 * (-k2 - k4) + T10 ^ 4 * k4) * (-k1 - k3 + 4 * T20 ^ 3 * (-k2 - k4));];
    H = [2 * (-k1 - k3 + 4 * T10 ^ 3 * (-k2 - k4)) ^ 2 + 24 * (c1 + T10 * (-k1 - k3) + T20 * k3 + T10 ^ 4 * (-k2 - k4) + T20 ^ 4 * k4) * T10 ^ 2 * (-k2 - k4) + 2 * (4 * T10 ^ 3 * k4 + k3) ^ 2 + 24 * (c2 + T20 * (-k1 - k3) + T10 * k3 + T20 ^ 4 * (-k2 - k4) + T10 ^ 4 * k4) * T10 ^ 2 * k4 2 * (4 * T20 ^ 3 * k4 + k3) * (-k1 - k3 + 4 * T10 ^ 3 * (-k2 - k4)) + 2 * (-k1 - k3 + 4 * T20 ^ 3 * (-k2 - k4)) * (4 * T10 ^ 3 * k4 + k3); 2 * (4 * T20 ^ 3 * k4 + k3) * (-k1 - k3 + 4 * T10 ^ 3 * (-k2 - k4)) + 2 * (-k1 - k3 + 4 * T20 ^ 3 * (-k2 - k4)) * (4 * T10 ^ 3 * k4 + k3) 2 * (4 * T20 ^ 3 * k4 + k3) ^ 2 + 24 * (c1 + T10 * (-k1 - k3) + T20 * k3 + T10 ^ 4 * (-k2 - k4) + T20 ^ 4 * k4) * T20 ^ 2 * k4 + 2 * (-k1 - k3 + 4 * T20 ^ 3 * (-k2 - k4)) ^ 2 + 24 * (c2 + T20 * (-k1 - k3) + T10 * k3 + T20 ^ 4 * (-k2 - k4) + T10 ^ 4 * k4) * T20 ^ 2 * (-k2 - k4);];

    %Newtonuv krok
    xk = xk-gam*inv(H)*g
    
    %Metoda nejvetsiho spadu
    %xk = xk-gam*g
    


    Tplot(:,k)=xk;
end

%Vizualizace konvergence

plot(Tplot(1,:));
figure;
plot(Tplot(2,:));



%% Stavovy popis systemu
T1=xk(1);
T2=xk(2);
Ass = [-4*k2*T1^3-4*k4*T1^3-k1-k3, 4*k4*T2^3+k3; 4*k4*T1^3+k3, -4*k2*T2^3-4*k4*T2^3-k1-k3];

poly=eig(Ass)
Tkonst = -1./poly


Bss=diag([ku1,ku2])
Css=eye(2)

sys = ss(Ass,Bss,Css,0)
sys_tf = zpk(sys)


figure;
step(sys) %analyza okoskopicky - diagonalni dynamika je dominantni, krizove vazby maji cca 6-8x mensi zesileni (vliv)


%Symbolicka matice prenosu
syms k1 k2 k3 k4 ku1 ku2 T1 T2 s
Asym = [-4*k2*T1^3-4*k4*T1^3-k1-k3, 4*k4*T2^3+k3; 4*k4*T1^3+k3, -4*k2*T2^3-4*k4*T2^3-k1-k3];

Bsym=diag([ku1,ku2])

Fs_s = Css*inv(s*Css-Asym)*Bsym

