% Change power factor
if ~exist('S_ana','var'), S_ana = S_bus; end            % Powers for analysis set to inputs
newPowerFactor = input('Enter new power factor: ');
newPowerFactorLeading = input('Lagging/inductive (0) or leading/capacitive (1)? ');
%fprintf('\n');

S_ana(busIsLoad,:)=createComplexPower(abs(S_ana(busIsLoad,:)),'P',newPowerFactor,newPowerFactorLeading);
fprintf('Power factor for all loads changed to %g',newPowerFactor)
if newPowerFactorLeading, fprintf(' leading.\n'); else, fprintf(' lagging.\n'); end