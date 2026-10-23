%% definice konstant
T_poc = 293.15;%pro SIML integrator, v kelvinech, momentalne je to 20 stupnu C
m = 0.004;
c_p = 500;
T_ok = 293.15; %musi byt v kelvinech
area = 0.0012;
U = 10;
sigma = 5.670374e-8; %stefan-boltzmanova konstanta
epsilon = 0.9; %emisivita (0,1), zatim vychozi hodnota protože nefungujou stranky TCLabu
%% spousteni simulace prubehu
%vstupni promenna
%Q_in = zatim v siml nastaveno pevne na schovy vstup!!!!

out = sim("mat_model.slx");
%% plot
figure(1)
hold on;
subplot(1,2,1);
plot(out.T_out);
title("prubeh pohybove rovnice")
subplot(1,2,2);

plot(out.Q_in_out);
ylim([-0.5, 2]);
xlim([0, 1200]);
title("prubeh vstupu")