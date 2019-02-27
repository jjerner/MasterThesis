%% Minisys verification

%% Quick checks
S_ver=sqrt(3)*U_out.*conj([I_out(1); I_out])
I_out(1)-(I_out(2)+I_out(3))

%% Minisys_complex

% Known
U_ver(1)=3.2456e+02 + 2.3380e+02i;
I12=3.7042;
I23=3.7042;
Z(1)=1;
Z(2)=1;

% Calculated
U12=sqrt(3)*Z(1)*I12;
U23=sqrt(3)*Z(2)*I23;
U_ver(2)=U_ver(1)-U12;
U_ver(3)=U_ver(2)-U23;

%% Minisys_complex_dual_new2

% Known
U_ver(1)=400;
I12=7.6820 - 1.1290i;
I23=4.6339 - 3.3683i;
I24=3.0481 + 2.2392i;
Z(1)=1+0.1j;
Z(2)=1+0.1j;
Z(3)=1+0.1j;

% Calculated
U12=-sqrt(3)*Z(1)*I12;
U23=-sqrt(3)*Z(2)*I23;
U24=-sqrt(3)*Z(3)*I24;
U_ver(2)=U_ver(1)+U12;
U_ver(3)=U_ver(2)+U23;
U_ver(4)=U_ver(2)+U24;

S_ver(1)=sqrt(3)*U_ver(1)*conj(I12);
S_ver(2)=sqrt(3)*U_ver(2)*conj(I12);
S_ver(3)=sqrt(3)*U_ver(3)*conj(I23);
S_ver(4)=sqrt(3)*U_ver(4)*conj(I24);