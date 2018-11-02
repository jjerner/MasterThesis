j=1i;
n=5;                                % Number of buses
% Line impedances (sample data)
Z_line=[0 0.02+0.1i 0 0 0.05+0.25i
        0.02+0.1i 0 0.04+0.2i 0 0.05+0.25i
        0 0.04+0.2i 0 0.05+0.25i 0.08+0.4i
        0 0 0.05+0.25i 0 0.1+0.5i
        0.05+0.25i 0.05+0.25i 0.08+0.4i 0.1+0.5i 0];
    
% Line charging susceptance (sample data) ???
Y_chg=j*[0 0.03 0 0 0.02
         0.03 0 0.025 0 0.020
         0 0.025 0 0.02 0.01
         0  0 0.02 0 0.075
         0.02 0.02 0.01 0.075 0];

% Create Ybus matrix
Y_bus=zeros(n,n);                   % Preallocating
for it_row=1:n
    for it_col=1:n
        if Z_line(it_row,it_col) == 0
           Y_bus(it_row,it_col)=0;
        else
           Y_bus(it_row,it_col)=-1/Z_line(it_row,it_col);
        end
    end
end
for it_row=1:n
    ysum=0;
    csum=0;
    for it_col=1:n
        ysum=ysum+Y_bus(it_row,it_col);
        csum=csum+Y_chg(it_row,it_col);
    end
    Y_bus(it_row,it_row)=csum-ysum;
end