%% definice konstant
m = 0.004;
c_p = 500;
T_ok = 23;
area = 0.0012;
U = 10;

%% spousteni simulace prubehu
%vstupni promenna
%Q_in = zatim v siml nastaveno pevne na schovy vstup!!!!

out = sim("mat_model.slx");
%% plot prubehu
plot(out.T_out);