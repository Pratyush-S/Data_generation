load('work02');
load('sim','Foz','Teq','flowrate');
assignin('base','Foz',Foz);
assignin('base','Teq',Teq);
assignin('base','flowrate',flowrate);
Tcsm01=(Tc*60)+1;
%tgtvar=zeros(tcm,1);
op_flag=1;
bufData=ones(1,6)*300;
error=0;

conc_o2=mat2cell([0.21;0.21;0.21;0.21;0.21;0.21],[1 1 1 1 1 1],1);
conc_co2=mat2cell([0.0003;0.0003;0.0003;0.0003;0.0003;0.0003],[1 1 1 1 1 1],1);
conc_o2_minute=mat2cell([0.21;0.21;0.21;0.21;0.21;0.21],[1 1 1 1 1 1],1);
conc_co2_minute=mat2cell([0.0003;0.0003;0.0003;0.0003;0.0003;0.0003],[1 1 1 1 1 1],1);
initial_pressure_inside_cabin = 75.73;  pc = initial_pressure_inside_cabin; %kPa
simulink_values = mat2cell([0; 0; 0; 0; 0;], [1 1 1 1 1], 1);
for p=1:Tc
    fprintf("Cruise Time = %d min",p);
    [T, P, H, O3] = getsimulinkdata(Foz, Teq, (factor_T(((p-1)*60)+1)));
    for i=((p-1)*60+1):(p*60)
        for j=1:6
            D0 = (AA{i}.*A);
            D1 = (AC{i}.*C);
            Da=mat2cell(D0, [5 5 5 5 5 6], 3);
            Dc=mat2cell(D1, [5 5 5 5 5 6], 3);
            temp1=Da{j};
            temp2=Dc{j};
            temp=[temp1 temp2];      
            [vtr1,vtr2,pc]=Recirculation(temp,factor_T(i),bias(i,j),conc_co2{j}(end,1),conc_o2{j}(end,1),pc);
            bufData(j,1)=vtr1*1000000;
            conc_co2{j}(end+1,1)=vtr1;
            conc_o2{j}(end+1,1)=vtr2;
        end
    end
    for q=1:6
        conc_o2_minute{q}(end+1,1) =conc_co2{q}(end,1);
        conc_co2_minute{q}(end+1,1)= conc_co2{q}(end,1);
    end
    
    simulink_values{1}(end+1,1) =T;
    simulink_values{2}(end+1,1)= P;
    simulink_values{3}(end+1,1) =H;
    simulink_values{4}(end+1,1)= O3;
    simulink_values{5}(end+1,1)= (factor_T((p-1)*60+1));
    
end
%%%end the spawned process%%%

Tcsm01=(Tc*60)+1;
[N,Zone_1,Zone_2,Zone_3,Zone_4,Zone_5,Zone_6]=deal(zeros(Tcsm01,1));
E=zeros(Tcsm01,7);
assignin('base','conc_co2',conc_co2);
assignin('base','conc_o2',conc_o2);
assignin('base','conc_co2_minute',conc_co2_minute);
assignin('base','conc_o2_minute',conc_o2_minute);
save('work02.mat','-append','conc_co2','conc_o2','conc_o2_minute','conc_co2_minute');
    Zone_1=conc_co2{1};
    Zone_1=Zone_1*1000000;
    Zone_2=conc_co2{2};
    Zone_2=Zone_2*1000000;
    Zone_3=conc_co2{3};
    Zone_3=Zone_3*1000000;
    Zone_4=conc_co2{4};
    Zone_4=Zone_4*1000000;
    Zone_5=conc_co2{5};
    Zone_5=Zone_5*1000000;
    Zone_6=conc_co2{6};
    Zone_6=Zone_6*1000000;
    
   Tcsm02=ceil(Tcsm01/S); 
   %%%Zone_C = zeros(Tcsm02,6);
   Zone_C = zeros(Tcsm02,6);
% %     for i=1:Tcsm01
% %         N(i,1)=i;
% %     end
    %%%E=horzcat(Zone_1,Zone_2,Zone_3,Zone_4,Zone_5,Zone_6,tgtvar);
    E=horzcat(Zone_1,Zone_2,Zone_3,Zone_4,Zone_5,Zone_6);

Time=strings([Tcsm02,1]);tailNo=Time;flightNo=Time;  
k=0;
    for j=1:S:Tcsm01
        k=k+1;
        Zone_C(k,:)=E(j,:);
        Time(k)=datestr(seconds(j-1),'HH:MM:SS');
        tailNo(k)="TailNo2";
        flightNo(k)="JAI808";
    end
CO2_Zone=Zone_C(:,1:6);%Markers=Zone_C(:,7);
%%X = table(Time,CO2_Zone,Markers,flightNo,tailNo); %Binding Time with Data

X = table(Time,CO2_Zone,flightNo,tailNo); %Binding Time with Data
fileName = 'Simulink_Data.xlsx';
% fileName_template='Simulink_Data_Template.xlsx';
% copyfile(fileName_template,fileName)
writetable(X,fileName,'sheet',2);
%winopen(fileName)
%% CO2 perminute samplng file store etc.
    Zonemin_1=conc_co2_minute{1};
    Zonemin_1=Zonemin_1*1000000;
    Zonemin_2=conc_co2_minute{2};
    Zonemin_2=Zonemin_2*1000000;
    Zonemin_3=conc_co2_minute{3};
    Zonemin_3=Zonemin_3*1000000;
    Zonemin_4=conc_co2_minute{4};
    Zonemin_4=Zonemin_4*1000000;
    Zonemin_5=conc_co2_minute{5};
    Zonemin_5=Zonemin_5*1000000;
    Zonemin_6=conc_co2_minute{6};
    Zonemin_6=Zonemin_6*1000000;
 Tcsm03=ceil(Tcsm01/60); 
   %%%Zone_C = zeros(Tcsm02,6);
   Zonemin_C = zeros(Tc,6);
% %     for i=1:Tcsm01
% %         N(i,1)=i;
% %     end
    %%%E=horzcat(Zone_1,Zone_2,Zone_3,Zone_4,Zone_5,Zone_6,tgtvar);
    Ey=horzcat(Zonemin_1,Zonemin_2,Zonemin_3,Zonemin_4,Zonemin_5,Zonemin_6);

Time2=strings([Tc,1]);tailNo2=Time2;flightNo2=Time2;  
k=0;
    for j=1:(Tc)
        k=k+1;
        Zonemin_C(k,:)=Ey(j,:);
        Time2(k)=datestr(seconds((j*60)),'HH:MM:SS');
        tailNo2(k)="TailNo3";
        flightNo2(k)="JAI808";
    end
CO2min_Zone=Zonemin_C(:,1:6);%Markers=Zone_C(:,7);
%%X = table(Time,CO2_Zone,Markers,flightNo,tailNo); %Binding Time with Data
aa = length(Time2)
ab = length(CO2min_Zone)
ac = length(tailNo2)
ad = length(flightNo2)
ae = length(simulink_values)
XY = table(Time2,CO2min_Zone,flightNo2,tailNo2); %Binding Time with Data
XZ = table(simulink_values);
fileName = 'Simulink_Data.xlsx';
% fileName_template='Simulink_Data_Template.xlsx';
% copyfile(fileName_template,fileName)
writetable(XY,fileName,'sheet',4);
writetable(XZ,fileName,'sheet',5);
%winopen(fileName)
function [new_cc,new_co,pc]=zoneCalc_sec(Mat,ff,offset,cc,co,pc)
    co_const = 0.21;
    cc_const = 0.0003;
    volume_of_the_cabin = 164968;          V = volume_of_the_cabin; %litres
    temperature = 293;                     T = temperature; %kelvin
    inflow_pressure = 75.73;                pi = inflow_pressure; %kPa
    initial_outflow_pressure = pc;         po = initial_outflow_pressure; %kPa
    molar_mass_of_air = 28.97;             M = molar_mass_of_air; %g/mol
    mass_flow_rate_inlet = 0.8*ff;            mi = mass_flow_rate_inlet; %kg/sec
    mass_flow_rate_outlet = 0.8*ff;          mo = mass_flow_rate_outlet; %kg/sec
    universal_gas_constant = 8.3145;       R = universal_gas_constant; %L.kPa/(mol.K)

    [m,n] = size(Mat);
    density_of_air = (pi*M)/(R*T);         di = density_of_air; %kg/m3,g/L
    Vz=(m/31)*V;
    volume_rate_flow_inlet = mi/di;        viz = (m/31)*1000*volume_rate_flow_inlet; %L/sec
    volume_rate_flow_outlet = mo/di;       voz = (m/31)*1000*volume_rate_flow_outlet; %L/sec


    % vector_co = [];              %Vector for concentration of Oxygen
    % vector_cc = [];              %Vector for concentration of Carbon dioxide
    % vector_p_o2 = [];            %Vector for partial pressure of Oxygen
    % vector_p_co2 = [];           %Vector for partial pressure of Carbon dioxide
    % vector_pc = [];              %Vector for total pressure of the cabin


    volume_co2_gen=0;
    for k=1:m
        for l=1:n
            volume_co2_gen=volume_co2_gen+Mat(k,l);vic=volume_co2_gen;%L
        end
    end
    volume_o2_con=volume_co2_gen/0.85;           vio = volume_o2_con;%L
    vic=vic+offset;
    
    % start calc here
    num_moles_inlet = (pi*viz)/(R*T);      ni = num_moles_inlet; %mol/s
    num_moles_outlet = (po*voz)/(R*T);     no = num_moles_outlet; %mol/s
    num_moles_in_zone = (pc*Vz)/(R*T);     nz = num_moles_in_zone; %mol/s

    num_moles_o2_con = (vio*pc)/(R*T);            n_oi = num_moles_o2_con; %mol (in one sec)
    num_moles_co2_gen = (vic*pc)/(R*T);           n_ci = num_moles_co2_gen; %mol (in one sec)
       
    %total_moles_inh_and_exh = nio*N;                  t_nie = total_moles_inh_and_exh; %mol (in one sec)
    %total_moles_o2_exhaled = n_oe*N;                  t_noe = total_moles_o2_exhaled; %mol (in one sec)
    %total_moles_co2_exhaled = n_ce*N;                 t_nce = total_moles_co2_exhaled; %mol (in one sec)

    total_num_moles =  nz + (ni+n_ci) - (no+n_oi);                   nt = total_num_moles; %mol
    total_num_moles_o2 = (nz*co)+(ni*co_const) - (no*co) -n_oi;     t_n_o2 = total_num_moles_o2; %mol
    total_num_moles_co2 = (nz*cc)+(ni*cc_const) - (no*cc) +n_ci;   t_n_co2 = total_num_moles_co2; %mol

    pc = (nt*R*T)/Vz;
    %partial_pressure_o2 = (t_n_o2*R*T)/Vz;         p_o2 = partial_pressure_o2; %kPa
    %partial_pressure_co2 = (t_n_co2*R*T)/Vz;       p_co2 = partial_pressure_co2; %kPa

    new_co = t_n_o2/nt;              %New concentrations of Oxygen
    new_cc = t_n_co2/nt;             %and Carbon dioxide

%     po = pc;                         %Outflow pressure equals the Cabin pressure (Assumption)
%     vectorfor i=1:tcm
%Updating all the five arrays
%     vector_cc(end+1) = [cc];
%     vector_p_o2(end+1) = [p_o2];
%     vector_p_co2(end+1) = [p_co2];
%     vector_pc(end+1) = [pc];
%     num_iterations = num_iterations+1;      
end
function [new_cc,new_co,pc] = Recirculation(Mat,ff,offset,cc,co,pc)
    co_const_bleed = 0.21;
    cc_const_bleed = 0.0003;
    co_const_recirc = 0.2086;
    cc_const_recirc = 0.0016;
    co_var_recirc = co;
    cc_var_recirc = cc;
    x=0.5;
    co_in_fin = (x * co_const_bleed) + ((1-x)*co_var_recirc);
    cc_in_fin = (x * cc_const_bleed) + ((1-x)*cc_var_recirc);
    volume_of_the_cabin = 164968;          V = volume_of_the_cabin; %litres
    temperature = 293;                     T = temperature; %kelvin
    inflow_pressure = 75.73;                pi = inflow_pressure; %kPa
    initial_outflow_pressure = pc;         po = initial_outflow_pressure; %kPa
    molar_mass_of_air = 28.97;             M = molar_mass_of_air; %g/mol
    mass_flow_rate_inlet = 1.2*ff;            mi = mass_flow_rate_inlet; %kg/sec
    mass_flow_rate_outlet = 1.2*ff;          mo = mass_flow_rate_outlet; %kg/sec
    universal_gas_constant = 8.3145;       R = universal_gas_constant; %L.kPa/(mol.K)

    [m,n] = size(Mat);
    density_of_air = (pi*M)/(R*T);         di = density_of_air; %kg/m3,g/L
    Vz=(m/31)*V;
    volume_rate_flow_inlet = mi/di;        viz = (m/31)*1000*volume_rate_flow_inlet; %L/sec
    volume_rate_flow_outlet = mo/di;       voz = (m/31)*1000*volume_rate_flow_outlet; %L/sec


    % vector_co = [];              %Vector for concentration of Oxygen
    % vector_cc = [];              %Vector for concentration of Carbon dioxide
    % vector_p_o2 = [];            %Vector for partial pressure of Oxygen
    % vector_p_co2 = [];           %Vector for partial pressure of Carbon dioxide
    % vector_pc = [];              %Vector for total pressure of the cabin


    volume_co2_gen=0;
    for k=1:m
        for l=1:n
            volume_co2_gen=volume_co2_gen+Mat(k,l);vic=volume_co2_gen;%L
        end
    end
    volume_o2_con=volume_co2_gen/0.85;           vio = volume_o2_con;%L
    vic=vic+offset;
    
    % start calc here
    num_moles_inlet = (pi*viz)/(R*T);      ni = num_moles_inlet; %mol/s
    num_moles_outlet = (po*voz)/(R*T);     no = num_moles_outlet; %mol/s
    num_moles_in_zone = (pc*Vz)/(R*T);     nz = num_moles_in_zone; %mol/s

    num_moles_o2_con = (vio*pc)/(R*T);            n_oi = num_moles_o2_con; %mol (in one sec)
    num_moles_co2_gen = (vic*pc)/(R*T);           n_ci = num_moles_co2_gen; %mol (in one sec)
       
    %total_moles_inh_and_exh = nio*N;                  t_nie = total_moles_inh_and_exh; %mol (in one sec)
    %total_moles_o2_exhaled = n_oe*N;                  t_noe = total_moles_o2_exhaled; %mol (in one sec)
    %total_moles_co2_exhaled = n_ce*N;                 t_nce = total_moles_co2_exhaled; %mol (in one sec)

    total_num_moles =  nz + (ni+n_ci) - (no+n_oi);                   nt = total_num_moles; %mol
    total_num_moles_o2 = (nz*co)+(ni*co_in_fin) - (no*co) -n_oi;     t_n_o2 = total_num_moles_o2; %mol
    total_num_moles_co2 = (nz*cc)+(ni*cc_in_fin) - (no*cc) +n_ci;   t_n_co2 = total_num_moles_co2; %mol

    pc = (nt*R*T)/Vz;
    %partial_pressure_o2 = (t_n_o2*R*T)/Vz;         p_o2 = partial_pressure_o2; %kPa
    %partial_pressure_co2 = (t_n_co2*R*T)/Vz;       p_co2 = partial_pressure_co2; %kPa

    new_co = t_n_o2/nt;              %New concentrations of Oxygen
    new_cc = t_n_co2/nt;             %and Carbon dioxide

%     po = pc;                         %Outflow pressure equals the Cabin pressure (Assumption)
%     vector_co(end+1) = [co];                 %Updating all the five arrays
%     vector_cc(end+1) = [cc];
%     vector_p_o2(end+1) = [p_o2];
%     vector_p_co2(end+1) = [p_co2];
%     vector_pc(end+1) = [pc];
%     num_iterations = num_iterations+1;      
end