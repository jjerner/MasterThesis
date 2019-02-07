%% Minisys verification

%% Quick checks
sign(real(S_out)).*abs(S_out./(sqrt(3)*U_out))
I_out(1)-(I_out(2)+I_out(3))

%% Minisys_complex_3p

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

%% Minisys_complex_dual_3p

% Known
U_ver(1)=3.2647e+02 + 2.3113e+02i;
I12=7.5590;
I23=4.5361;
I24=3.0228;
Z(1)=1+0.1j;
Z(2)=1+0.1j;
Z(3)=1.5+0.1j;

% Calculated
U12=sqrt(3)*Z(1)*I12;
U23=sqrt(3)*Z(2)*I23;
U24=sqrt(3)*Z(3)*I24;
U_ver(2)=U_ver(1)-U12;
U_ver(3)=U_ver(2)-U23;
U_ver(4)=U_ver(2)-U24;

S_ver(1)=sqrt(3)*U_ver(1)*I12;
S_ver(2)=sqrt(3)*U_ver(2)*I12;
S_ver(3)=sqrt(3)*U_ver(3)*I23;
S_ver(4)=sqrt(3)*U_ver(4)*I24;

%% Minisys_complex_dual_3p_neg-reac-pow

% Known
U_ver(1)=3.2825e+02 - 2.2859e+02i;
I12=7.5120;
I23=4.5065;
I24=3.0055;
Z(1)=1+0j;
Z(2)=1+0j;
Z(3)=1.5+0j;

% Calculated
U12=sqrt(3)*Z(1)*I12;
U23=sqrt(3)*Z(2)*I23;
U24=sqrt(3)*Z(3)*I24;
U_ver(2)=U_ver(1)-U12;
U_ver(3)=U_ver(2)-U23;
U_ver(4)=U_ver(2)-U24;

S_ver(1)=sqrt(3)*U_ver(1)*I12;
S_ver(2)=sqrt(3)*U_ver(2)*I12;
S_ver(3)=sqrt(3)*U_ver(3)*I23;
S_ver(4)=sqrt(3)*U_ver(4)*I24;

%% Minisys_complex_dual_3p_neg

% Known
U_ver(1)=3.0596e+02 + 2.5767e+02i;
I12=-1.3254;
I23=-4.2448;
I24=2.9174;
Z(1)=1+0.1j;
Z(2)=1+0.1j;
Z(3)=1.5+0.1j;

% Calculated
U12=sqrt(3)*Z(1)*I12;
U23=sqrt(3)*Z(2)*I23;
U24=sqrt(3)*Z(3)*I24;
U_ver(2)=U_ver(1)-U12;
U_ver(3)=U_ver(2)-U23;
U_ver(4)=U_ver(2)-U24;

S_ver(1)=sqrt(3)*U_ver(1)*I12;
S_ver(2)=sqrt(3)*U_ver(2)*I12;
S_ver(3)=sqrt(3)*U_ver(3)*I23;
S_ver(4)=sqrt(3)*U_ver(4)*I24;