load('work02');
load('sim','Foz','Teq','flowrate');
assignin('base','Foz',Foz);
assignin('base','Teq',Teq);
assignin('base','flowrate',flowrate);
fprintf("Sim parameters loaded... \n",i);
   for i=1:10
        set(0,'RecursionLimit',100000000);
        ModelName = 'ssc_aircraft_ecs_data.mdl';% load the file name
        open_system(ModelName); % to open the simulink file to view
        %set_param(ModelName, 'SimulationCommand', 'start'); % automatically run the model file
        simOut = sim(ModelName,'ReturnWorkspaceOutputs','on');
        res(i) = simOut;
%         assignin('base', 'simOut', simOut);
        %run ssc_aircraft_ecs_data %simulate the model
              
        fprintf("ECS model simulation...%d\n",i);
        
   end
%   %  fprintf("Simulation Iteration = %d\n",i);
%     %[PrV,O3V,TpV,RHV]=simCabinECS();
%     simCabinECS();
%     fprintf("CRASHed for loop %d\n",i);
%     %Collect data
%     pCabin(i)=PrV;
%     oCabin(i)=O3V;
%     tCabin(i)=TpV;
%     rhCabin(i)=RHV;
%end
%set(handles.figure1, 'pointer', 'arrow')

assignin('base', 'simRes', res);
fprintf("kiki");