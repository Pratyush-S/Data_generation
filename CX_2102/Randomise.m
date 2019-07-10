%occupancy matrix - randomised
P=evalin('base','P') ;
if any(P > 186)
   error('\n Error !! ,We can not accomodate more than 186 passengers, you have entered extra %d passengers',P-186)
end
x = 31;
n = ceil(P/2);
n1 = P-n;
V=zeros(1,n);
            for i=1:n
                V(1,i)=1;
            end
V1=zeros(1,n1);
            for i=1:n1
                V1(1,i)=1;
            end
[A,C]=deal(zeros(x,3));
B=zeros(x,1);
%[rows,columns]=size(D);
A(randperm(numel(A), numel(V))) = V;
C(randperm(numel(C), numel(V1))) = V1;
O=[A B C]
assignin('base', 'A', A)
assignin('base', 'C', C)
assignin('base', 'B', B)
save('work02','-append','A','B','C');
clear x i n n1 V V1 
%assignin('base', 'O', O)
% D0 = (0.00646*A);
% D1 = (0.00646*C);
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
%Duration of flight 
% x1=Tf*60
% t01= floor (x1/S)
% h0=zeros(t01,3);
% [t00,Zone_1,Zone_2,Zone_3,Zone_4,Zone_5,Zone_6]=deal(zeros(t01,1));
% for i=1:t01     
% %     Zone_1(i,1)=Md1;
%     Zone_2(i,1)=Md2;
%     Zone_3(i,1)=Md3;
%     Zone_4(i,1)=Md4;
%     Zone_5(i,1)=Md5;
%     Zone_6(i,1)=Md6;
%     t00(i,1)=(i*S);
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
% end
%TT = timetable(TimeHour,TimeMin,TimeSec,Zone_1,Zone_2,Zone_3,Zone_4,Zone_5,Zone_6);
 %X = timetable2table(TT)
% X = table(TimeHour,TimeMin,TimeSec,Zone_1,Zone_2,Zone_3,Zone_4,Zone_5,Zone_6);
% fileName = 'result_random.xlsx';
% writetable(X,fileName);
% winopen(fileName)
