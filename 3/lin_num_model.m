%% Zadané Q
Q10 = 60;
Q20 = 80;

%% Konstanty
T_poc = 23 + 273.15;
m = 0.004; %hmotnost
c_p = 500; %tep. kapacita.
T_ok = 23 + 273.15; %musi byt v kelvinech
A = 7e-4; %ploacha
A_int = 0.0002; %interakční plocha
U = 10; %koeficient přestupu do okolí
sigma = 5.670374e-8; %stefan-boltzmanova konstanta
epsilon = 0.5; %emisivita 
alfa = 0.02; %převoda z % na w

T1 = 95.3666;
T2 = 107.8788;

%% Konstanty

k1 = (U*A)/(m*c_p);
k2 = (sigma * epsilon * A)/(m*c_p);
k3 = (U*A_int)/(m*c_p);
k4 = (epsilon * sigma * A_int);
k5 = alfa/(m*c_p);

%% mat A B C D

A = [-4*k2*T1^3 - 4*k4*T1^3 - k1 - k3, 4*k4*T2^3 + k3;
     4*k4*T1^3 + k3, -4*k2*T2^3 - 4*k4*T2^3 - k1 - k3];

B = [ k5 , 0
      0    k5];

C = eye(2);

D = zeros(2);

disp(A)
disp(B)
disp(C)
disp(D)