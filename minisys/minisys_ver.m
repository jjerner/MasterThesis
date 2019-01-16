%% Minisys verification

%% Minisys_complex_dual_3p

% Known
U1=400;
I12=7;
I23=4;
I24=3;
Z1=1+0.1j;
Z2=1+0.1j;
Z3=1.5+0.1j;

% Calculated
U12=sqrt(3)*Z1*I12;
U23=sqrt(3)*Z2*I23;
U24=sqrt(3)*Z3*I24;

U2=U1-U12;
U3=U2-U23;
U4=U2-U24;

P1=sqrt(3)*U1*I12;
P2=sqrt(3)*U2*I12;
P3=sqrt(3)*U3*I23;
P4=sqrt(3)*U4*I24;