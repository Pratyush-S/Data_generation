load('work02.mat');     %Get user inputs
%%------------------Normal Data-----------------%%
Tcs=(Tf*60);
crs = Tc*60; %cruise time in seconds
PM10taxiascent = (normrnd(9,0.5,[1,600])).';
PM10ascent = (linspace(9,4,1200).*normrnd(1,0.1,[1,1200])).';
PM10cruise = (normrnd(4,0.5,[1,crs])).';
PM10descent = (linspace(4,8,1200).*normrnd(1,0.1,[1,1200])).';
PM10taxidescent = (normrnd(8,0.5,[1,600])).';
NA_PM = vertcat(PM10taxiascent,PM10ascent,PM10cruise,PM10descent,PM10taxidescent);
%flightDataPM10ma30 = movavg(NA_PM,'linear',300);
flightDataPM10ma30 = movavg(NA_PM,'linear',70);
L=zeros([Tcs,1]);

%%------------------Turbulence-----------------%%
%startTurb = 2200;       %during cruise
%endTurb   = 2500;       %300 seconds = 5 mins (min 3 min, max 6 mins)
%peakValue = 13;
check3 = exist('turbflg','var');%check for GUI user input from tickbox
if(check3 && turbflg == 1)
    %pkVal = 10 + 3*rand;    %random peak value from 10 to 13
    pkVal = 17;
    startTurb = 1800+randi([1,crs-360]);durTurb = randi([180,360]); %any random time within cruise period
    endTurb = startTurb + durTurb;

    startPM = flightDataPM10ma30(startTurb)+1.5 ;
    endPM = flightDataPM10ma30(endTurb);
    remainingTime = endTurb-(startTurb+30)+1;
    turbfirst15secs = (linspace(startPM, pkVal,15).*normrnd(1,0.2,[1,15])).';
    turbpeak15secs  =(normrnd(pkVal,0.5,[1,15])).';
    turbend =(linspace(pkVal, endPM, remainingTime).*normrnd(1,0.1,[1, remainingTime])).';
    TA_PM=vertcat(turbfirst15secs,turbpeak15secs,turbend);
    
    %katora= movavg(TA_PM,'linear',20);
    %flightDataPM10ma30(startTurb:endTurb) = katora;
    flightDataPM10ma30(startTurb:endTurb) = movavg(TA_PM,'linear',20);
    L(startTurb:endTurb) = 1;
end
%%-----------------Formatting Excel Sheet-----------------%%
Tcsm=floor(Tcs/S);
PM10=zeros([Tcsm,1]);
%%----------------TimestampCreation--------------%%
Time=strings([Tcsm,1]);tailNo=Time;flightNo=Time;%Flight_Status=Time;
TotalTimeSec=zeros([Tcsm,1]);activity=TotalTimeSec;Altitude=TotalTimeSec;Flight_Status=Altitude;
%To select teh data as per the sampling time
for i=1:Tcsm
    Sm=(i*S);
    PM10(i,:)=flightDataPM10ma30(Sm,:);
    activity(i)=L(Sm);
    Time(i)=datestr(seconds(Sm),'HH:MM:SS');
    tailNo(i)="TailNo3";
    flightNo(i)="JAI808";
    TotalTimeSec(i)=Sm;
    Altitude(i)=S_Alt(Sm);
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
%     end
end
turbulence=activity;
X = table(Time,TotalTimeSec,Flight_Status,Altitude,PM10,activity,turbulence,flightNo,tailNo);
%flightDataX = table(timeHour,timeMin,timeSec,Zone_C ); %Binding Time with Data
fileName = 'Simulink_Data.xlsx';
% fileName_template='Simulink_Data_Template.xlsx';
% copyfile(fileName_template,fileName)
writetable(X,fileName,'sheet',3);
