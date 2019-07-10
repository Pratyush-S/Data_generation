load('work02');
tcm_0=(Tc*60);
factor_T=ones(tcm_0,1);
check1 = exist('input_eff','var');
if(check1)
    [Brows,Bcolumns]=size(input_eff);
    for i=1:Brows
        start=60*str2double(input_eff(i,1));
        stop=60*str2double(input_eff(i,2));
        for j=start:stop
            factor_T(j,1)=str2double(input_eff(i,3));
        end
    end
end
assignin('base','factor_T',factor_T);
save('work02.mat','-append','factor_T');