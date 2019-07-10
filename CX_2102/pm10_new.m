load('work02.mat');     %Get user inputs
fields={'city','last_update','pollutant_avg'};
srcePM=pmlist(strcmpi(pmlist.city,srce),fields);
dstPM=pmlist(strcmpi(pmlist.city,dst),fields);
fls=Tf*60;crs=Tc*60;
asval=str2num(srcePM{1,3}{1});
dsval=str2num(dstPM{1,3}{1});

crsval=randi([6,12]);
%bl_aout = [asval*ones(1,600) linspace(asval,8,120) normrnd(crsval,0.1,[1,fls-1440]) linspace(8,dsval,120) dsval*ones(1,600)];
bl_aout = [asval*ones(1,600) linspace(asval,8,120) crsval*ones(1,fls-1440) linspace(8,dsval,120) dsval*ones(1,600)];

%%------------------Normal Data-----------------%%
pm_cab(1)=asval; %Cabin Door closed
V = 164.968; %cubic Metre
dns = 0.9006; %kg/m3
fout = 0.8/dns; %m3/sec
fin = 0.8/dns; %m3/sec

%bl_aout = [150*ones(1,600) linspace(150,8,1200) 8*ones(1,7200) linspace(8,150,1200) 150*ones(1,600)];
%bl_aout = [150*ones(1,600) linspace(150,8,120) linspace(8,8,1080) 8*ones(1,7200) linspace(8,8,1080) linspace(8,150,120) 150*ones(1,600)];
%bl_aout = [150*ones(1,600) linspace(150,8,120) ones(1,9360).*normrnd(8,2,[1,9360]) linspace(8,150,120) 150*ones(1,600)];

for i=1:fls
    apm_out=pm_cab(i)*fout; %ug
    apm_in=fin*((bl_aout(i)*(0.8/dns))+(0.0003*apm_out))/(fout+(0.8/dns)); %ug
    pm_cab(i+1)=((pm_cab(i)*V)+apm_in-apm_out)/V;
end
multiplicationfactor = [normrnd(1,0.00001,[1,1800]) normrnd(1,0.05,[1,fls-2520]) normrnd(1,0.00001,[1,720])];
%%pm_cab = pm_cab.*normrnd(1,0.01,[1,fls+1]);
flightDataPM10ma30 = ((pm_cab(2:fls+1)).*multiplicationfactor).';
flightDataPM10ma30(1801:fls-720) = movavg(flightDataPM10ma30(1801:fls-720),'linear',20);
L=zeros([fls,1]);

%%------------------Turbulence-----------------%%
check3 = exist('sTurb','var') && exist('eTurb','var');%check for GUI user input from tickbox
if(check3)
    %pkVal = 10 + 3*rand;    %random peak value from 10 to 13
    %pkVal = randi([15,50]);  %random peak value from 15 to 50
    pkVal = randi([70,90]);
    startTurb = (sTurb+30)*60;
    endTurb = (eTurb+30)*60;

    startPM = flightDataPM10ma30(startTurb)+1.5 ;
    endPM = flightDataPM10ma30(endTurb);
    remainingTime = endTurb-(startTurb+30)+1;
    turbfirst15secs = (linspace(startPM, pkVal,15).*normrnd(1,0.2,[1,15])).';
    turbpeak15secs  =(normrnd(pkVal,0.5,[1,15])).';
    turbend =(linspace(pkVal, endPM, remainingTime).*normrnd(1,0.1,[1, remainingTime])).';
    TA_PM=vertcat(turbfirst15secs,turbpeak15secs,turbend);
  
    flightDataPM10ma30(startTurb:endTurb) = movavg(TA_PM,'linear',20);
    L(startTurb:endTurb) = 1;
end

%%-----------------Formatting Excel Sheet-----------------%%
Tcsm=floor(fls/S);
PM10=zeros([Tcsm,1]);
%%----------------TimestampCreation--------------%%
Time=strings([Tcsm,1]);tailNo=Time;flightNo=Time;%Flight_Status=Time;
TotalTimeSec=zeros([Tcsm,1]);activity=TotalTimeSec;Altitude=TotalTimeSec;Flight_Status=Altitude;
%To select the data as per the sampling time
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
    elseif(Sm>=(fls-1800))
        if(Sm>(fls-600))
            Flight_Status(i)=-2;
        else
            Flight_Status(i)=-1;
        end
    end
end
turbulence=activity;
X = table(Time,TotalTimeSec,Flight_Status,Altitude,PM10,activity,turbulence,flightNo,tailNo);
%flightDataX = table(timeHour,timeMin,timeSec,Zone_C ); %Binding Time with Data
fileName = 'Simulink_Data.xlsx';
% fileName_template='Simulink_Data_Template.xlsx';
% copyfile(fileName_template,fileName)
writetable(X,fileName,'sheet',3);