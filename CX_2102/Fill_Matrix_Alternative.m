%Smaller numbers are not giving proper output wth co2 fixed and
%excelgenerator
%alterative fill - window: aisle :middle
% clc
% clear all
P=evalin('base','P') ;
if any(P > 186)
   error('\n Error !! ,We can not accomodate more than 186 passengers, you have entered extra %d passengers',P-186)
end
x= 31;
b1=3; 
M = ceil(P/6);
A=zeros(x,b1);
C=zeros(x,b1);
B=zeros(x,1);
D=[A B C];
   
if any(P>x)
    p0 = x;
        for i=1:p0
        D(i,1)=1;
        end
else
    p0=P;
        for i=1:2:(p0)
        D(i,1)=1;
        end
        for i=2:2:(2*(p0-16))
        D(i,1)=1;
        end
end
p1=(P-p0);
if p1>x
p10=x;
       for i=1:p10
       D(i,7)=1;
       end
else
p10=p1;
        for i=1:2:(p10)
        D(i,7)=1;
        end
        for i=2:2:(2*(p10-16))
        D(i,7)=1;
        end
end
p2=(P-(p0+p10));
if p2>31
p20=x;
        for i=1:p20
        D(i,3)=1;
        end
else
p20=p2;
        for i=1:2:(p20)
        D(i,3)=1;
        end
        for i=2:2:(2*(p20-16))
        D(i,3)=1;
        end
end
p3=(P-(p0+p10+p20));
if p3>31
p30=x;
        for i=1:p30
        D(i,5)=1;
        end 
else
p30=p3;
        for i=1:2:(p30)
        D(i,5)=1;
        end
        for i=2:2:(2*(p30-16))
        D(i,5)=1;
        end
end     
 p4=(P-(p0+p10+p20+p30));
 p40=ceil(p4/2);
 if any(p40<15)
        for i=1:2:(p40)
        D(i,2)=1;
        end
 else
        for i=1:2:(31)
        D(i,2)=1;
        end
        for i=2:2:(2*(p40-16))
        D(i,2)=1;
        end
 end
 p50=(P- (p0+p10+p20+p30+p40));
 if any (p50<15)       
        for i=1:2:(p50)
        D(i,6)=1;
        end
 else 
        for i=1:2:(31)
        D(i,6:6)=1;
        end
        for i=2:2:(2*(p50-16))
        D(i,6)=1;
        end
 end
 p60=(P- (p0+p10+p20+p30+p40+p50));
 for i=1:x
      A(i,1:3)=D(i,1:3);
      C(i,1:3)=D(i,5:7);
 end
assignin('base', 'A', A)
assignin('base', 'C', C)
assignin('base', 'B', B)
O=D
save('work02','-append','A','B','C');
clear b1 x i M D p0 p1 p10 p2 p20 p3 p30 p4 p40 p50 p60   

%D0 = (0.00646*A);
%D1 = (0.00646*C);
% Da=mat2cell(D0, [5 5 5 5 5 6], [3]);
% Dc=mat2cell(D1, [5 5 5 5 5 6], [3]);
% %Db=mat2cell(B, [5 5 5 5 5 6], [1])
% %celldisp(Da);
% %celldisp(Dc);
% % Da{1} and Dc{1}
% Ma1 = mean (mean (Da{1},2));
% Mc1 = mean( mean (Dc{1},2));
% Md1 = mean([Ma1 Mc1]);
% % Da{2} and Dc{2}
% Ma2 = mean (mean (Da{2},2));
% Mc2 = mean (mean (Dc{2},2));
% Md2 = mean ([Ma2 Mc2]);
% % % Da{3} and Dc{3}
% Ma3 = mean (mean (Da{3},2));
% Mc3 = mean (mean (Dc{3},2));
% Md3 = mean ([Ma3 Mc3]);
% % % Da{4} and Dc{4}
% Ma4 = mean (mean (Da{4},2));
% Mc4 = mean (mean (Dc{4},2));
% Md4 = mean ([Ma4 Mc4]);
% % % Da{5} and Dc{5}
% Ma5 = mean (mean (Da{5},2));
% Mc5 = mean (mean (Dc{5},2));
% Md5 = mean ([Ma5 Mc5]);
% % % Da{6} and Dc{6}
% Ma6 = mean (mean (Da{6},2));
% Mc6 = mean (mean (Dc{6},2));
% Md6 = mean ([Ma6 Mc6]);
% M = [Md1; Md2; Md3; Md4;Md5; Md6]
% %Duration of flight 
% x1=t02*60
% t01= floor (x1/s)
% h0=zeros(t01,3);
% [t00,Zone_1,Zone_2,Zone_3,Zone_4,Zone_5,Zone_6]=deal(zeros(t01,1));
% for i=1:t01     
% %     Zone_1(i,1)=Md1;
%     Zone_2(i,1)=Md2;
%     Zone_3(i,1)=Md3;
%     Zone_4(i,1)=Md4;
%     Zone_5(i,1)=Md5;
%     Zone_6(i,1)=Md6;
%     t00(i,1)=(i*s);
%     t=t00(i,1);
%     hr = floor(t/3600);
%     t = t - hr * 3600;
%     mi = floor(t/60);
%     t = t - mi * 60;
%     sc = t;
%     h0(i,1:3) =[hr mi sc];
%     TimeHour(i,1)=h0(i,1);
%     TimeMin(i,1)=h0(i,2);
%     TimeSec(i,1)=h0(i,3);
% % end
% % %TT = timetable(TimeHour,TimeMin,TimeSec,Zone_1,Zone_2,Zone_3,Zone_4,Zone_5,Zone_6);
%  %X = timetable2table(TT)
% X = table(TimeHour,TimeMin,TimeSec,Zone_1,Zone_2,Zone_3,Zone_4,Zone_5,Zone_6);
% fileName = 'result_fixed.xlsx';
% writetable(X,fileName);
% winopen(fileName)
% 


