%plotting simulink data
load('work02');

Tcr_sec=Tc*60;% cruize time
Tcs=(Tf*60); % total flight time

S_data0=zeros(Tcs,1);
[S_data1,S_data2] = deal(zeros(1800,5));
S_data3 = zeros(Tcr_sec,5);

% Conversion of outside pressure to Altitude
[pm,pn]=size(p_atm);
[p_atm1,p_alt] = deal(zeros(pm,1));
p_atm1=p_atm;
format long g;
p0 = 101.325; %KPa  
L = 0.00651802,1; %K/m
T0 = 288.15; %K
g = 9.80665; %m/s2
M = 0.0289644; %kg/mol
R = 8.31447; %J/(mol*K)
A = (R*L)/(g*M);
B = T0/L;
for i=1:pm
    P=p_atm1(i,1);
    C= P/p0;
    p_alt(i,1)=(B*(1-(C)^A))*3.3;
end
%S_data0=horzcat(s_p,s_Oz,s_RH,s_Temp);
S_data0=horzcat(p_alt,p_cabin,O3_cabin,T_cabin,RH_cabin);
%Selection of for ascent ,Cruize and descent 
for i=1:Tcs
    if (i== 1800)
        S_data1=S_data0(2:1801,1:5);
    elseif (i==4200)
        S_data2=S_data0(4201:6000,1:5);
    elseif(i>1800&&i<4200)     
        for k=1:Tcr_sec      
                S_data3(k,:)=S_data0(1802,1:5);
        end      
    end
end

S_datax=vertcat(S_data1,S_data3,S_data2);
S_Alt=S_datax(:,1);
assignin('base', 'S_Alt', S_Alt);
save('work02','-append','S_Alt');
%S=1; % for testing min. sensor time
Tcsm=floor(Tcs/S);
S_dataxm=zeros([Tcsm,5]);
%%----------------TimestampCreation--------------%%
Time=strings([Tcsm,1]);tailNo=Time;flightNo=Time;%Flight_Status=Time;
TotalTimeSec=zeros([Tcsm,1]);Flight_Status=TotalTimeSec;
%To select teh data as per the sampling time
for i=1:Tcsm
    Sm=(i*S);
    S_dataxm(i,:)=S_datax(Sm,:);
    Time(i)=datestr(seconds(Sm),'HH:MM:SS');
    tailNo(i)="TailNo1";
    flightNo(i)="JAI808";
    TotalTimeSec(i)=Sm;
%     if(Sm>1800 && Sm<(Tcs-1800))
%         Flight_Status(i)="C";
%     elseif(Sm<=1800)
%         if(Sm<600)
%             Flight_Status(i)="TA";
%         else
%             Flight_Status(i)="A";
%         end
%     else
%         if(Sm>(Tcs-600))
%             Flight_Status(i)="TD";
%         else
%             Flight_Status(i)="D";
%         end
    if(Sm<=1800)
        if(Sm<600)
            Flight_Status(i)=2;
        else
            Flight_Status(i)=1;
        end
    elseif(Sm>=(Tcs-1800))
        if(Sm>(Tcs-600))
            Flight_Status(i)=-2;
        else
            Flight_Status(i)=-1;
        end
    end
end

% Creation of timesamp in Hr.Min.Sec
% t00=zeros(Tcsm,1);
% h0=zeros(Tcsm,3);
% for i=1:Tcsm
%     t00(i,1)=(i*S);
%     t=t00(i,1);
%     t=(i*S);
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
%S_data=horzcat(Time,TotalTimeSec,S_dataxm,); %Binding Time with Data
%clear i j k m mi sc hr h0 Sm t O3_cabin p_cabin RH_cabin T_cabin s_Oz s_p s_RH s_Temp Tcsm Tcs Tcr_sec t00 S_data0 S_data1 S_data2 S_data3 

Altitude=S_dataxm(:,1);Pressure=S_dataxm(:,2);Ozone=S_dataxm(:,3);Temperature=S_dataxm(:,4);RelHumidity=S_dataxm(:,5);
X = table(Time,TotalTimeSec,Flight_Status,Altitude,Pressure,Ozone,Temperature,RelHumidity,flightNo,tailNo);
fileName = 'Simulink_Data.xlsx';
% copyfile(fileName_template,fileName)
writetable(X,fileName,'sheet',1);