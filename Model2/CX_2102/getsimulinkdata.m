function [T, P,H,O3]= getsimulinkdata(Foz, Teq, flowrate)
load('work02');
%load('sim','Foz','Teq','flowrate');
assignin('base','Foz',Foz);
assignin('base','Teq',Teq);
assignin('base','flowrate',flowrate);
%save('work02.mat','-append','Foz','Teq','flowrate');
set(0,'RecursionLimit',100000000);
ModelName = 'ssc_aircraft_ecs_data.mdl';% load the file name
open_system(ModelName); % to open the simulink file to view
simOut = sim(ModelName,'ReturnWorkspaceOutputs','on');
H = simOut.RH_cabin(3000);
O3 = simOut.O3_cabin(3000);
P = simOut.p_cabin(3000);
T = simOut.T_cabin(3000);
end