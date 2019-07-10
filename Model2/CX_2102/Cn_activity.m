%carbon dioxide source
load('work02');
% x=activity
tcm_0=(Tc*60);
Zone=zeros(tcm_0,6);
M_sec=horzcat(Zone);
check2 = exist('C_Z','var');
if(check2)
    y=C_Z;
    [Brows,Bcolumns]=size(y);
    %format short g
    for i=1:Brows;
        E1=y(i,1);
        E11=cell2mat(E1);
        E12=(E11*60);

        E2=y(i,2);
        E21=cell2mat(E2);
        E22=(E21*60);

        E3=y(i,3);
        E31=cell2mat(E3);

        E4=y(i,4);
        E41=cell2mat(E4);

           for j=1:tcm_0       
                if (j== E12)
                    for k=E12:E22
                        f=E41;
                        M_sec(k,f)=E31;
                    end
%                 fprintf("%d\n",k)
%                 fprintf("%d\n",j)
                end
           end
    end
end
clear Brows Bcolumns E1 E11 E12 E2 E21 E22 E3 E31 E4 E41 f i j k tcm_0 y tc_sec Zone_1 Zone_2 Zone_3 Zone_4 Zone_5 Zone_6
bias=M_sec;
assignin('base','bias',bias);
save('work02.mat','-append','bias');