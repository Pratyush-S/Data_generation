function Par_cabin()
for i=1:tcm
    control_vf=factor_T(i); 
    if(op_flag==0)
        save('control_loop.mat','-append','op_flag','control_vf');
        while(1)
            load('control_loop.mat','control_vf','control_update','override');
            if(exist(control_update,'var') && control_update~=1)
                continue;
            else
                op_flag=1;
                if(override)
                    factor_T(i)=control_vf;
                end
                control_update=0;
                save('control_loop.mat','-append','control_update');
                break;
            end
        end
        %op_flag=input('Enter the flagval');
    end
    if(op_flag==1)
        for j=1:6
            D0 = (AA{i}.*A);
            D1 = (AC{i}.*C);
            Da=mat2cell(D0, [5 5 5 5 5 6], 3);
            Dc=mat2cell(D1, [5 5 5 5 5 6], 3);
            temp1=Da{j};
            Co2_currenttemp2=Dc{j};
            temp=[temp1 temp2];      
            [vtr1,vtr2,pc]=zoneCalc_sec(temp,factor_T(i),bias(i,j),conc_co2{j}(end,1),conc_o2{j}(end,1),pc);
            bufData(j,1)=vtr1*1000000;
            conc_co2{j}(end+1,1)=vtr1;
            conc_o2{j}(end+1,1)=vtr2;
        end
        op_flag=0;     
    end
end

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