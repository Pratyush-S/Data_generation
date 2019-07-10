function varargout = AIOT(varargin)
% AIOT MATLAB code for AIOT.fig
% Edit the above text to modify the response to help test_01
% Last Modified by GUIDE v2.5 24-Jan-2019 17:24:34
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AIOT_OpeningFcn, ...
                   'gui_OutputFcn',  @AIOT_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before AIOT is made visible.
function AIOT_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.simCheck = 0;
handles.countPress = 0;
guidata(hObject, handles);
evalin('base','clear');%clc;
clear ('work02.mat')
save ('work02.mat')
delete Simulink_Data.xlsx
% --- Outputs from this function are returned to the command line.
function varargout = AIOT_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function Tf_Callback(hObject, eventdata, handles) %Flight Duration
Tf=str2num(get(handles.Tf,'String'));
tx01=10; % in minutes
tace=20; % in minutes
tdes=20; % in minutes
tx02=10; % in minutes
Tc= Tf-tx01-tace-tdes-tx02;
handles.Tcn=Tc;
guidata(hObject, handles);
assignin('base', 'Tc',Tc);
save('work02.mat','-append','Tc');
assignin('base', 'Tf',Tf);
save('work02.mat','-append','Tf');

% --- Executes during object creation, after setting all properties.
function Tf_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'));
    set(hObject,'BackgroundColor','white');
end

function P_Callback(hObject, eventdata, handles) %Number of Passengers
P=str2num(get(handles.P,'String'));
assignin('base', 'P',P);
save('work02','-append','P');

% --- Executes during object creation, after setting all properties.
function P_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'));
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Or - Occupancy Distribution -Random.
function Or_Callback(hObject, eventdata, handles)
Or=get(hObject,'Value');
if (get(handles.Or,'Value') == 1 && get(handles.Of,'Value') == 0 && get(handles.Oc,'Value') == 0)
    run Randomise.m
elseif (get(handles.Of,'Value') == 1 && get(handles.Oc,'Value') == 0 && get(handles.Or,'Value') == 0)
    run Fill_Matrix_Alternative.m
elseif (get(handles.Oc,'Value') == 1 && get(handles.Or,'Value') == 0 && get(handles.Of,'Value') == 0)
    run Fill_Matrix_Front.m
else
    (get(handles.Or,'Value') == 0 && get(handles.Of,'Value') == 0 && get(handles.Oc,'Value') == 0)
    clear Ocontrol_loop.mat
end

% --- Executes on button press in Of - Occupancy Distribution - ColumnWise.
function Of_Callback(hObject, eventdata, handles)
Of=get(hObject,'Value');
if (get(handles.Of,'Value') == 1 && get(handles.Or,'Value') == 0 && get(handles.Oc,'Value') == 0)
    run Fill_Matrix_Alternative.m
elseif (get(handles.Or,'Value') == 1 && get(handles.Oc,'Value') == 0 && get(handles.Of,'Value') == 0)
    run Randomise.m
elseif (get(handles.Oc,'Value') == 1 && get(handles.Or,'Value') == 0 && get(handles.Of,'Value') == 0)
    run Fill_Matrix_Front.m
else
    (get(handles.Or,'Value') == 0 && get(handles.Of,'Value') == 0 && get(handles.Oc,'Value') == 0)
    clear O
end

% --- Executes on button press in Oc - Occupancy Distribution - Row-wise.
function Oc_Callback(hObject, eventdata, handles)
Oc=get(hObject,'Value');
if (get(handles.Oc,'Value') == 1 && get(handles.Or,'Value') == 0 && get(handles.Of,'Value') == 0)
    run Fill_Matrix_Front.m
elseif (get(handles.Oc,'Value') == 0 && get(handles.Or,'Value') == 1 && get(handles.Of,'Value') == 0)
    run Randomise.m
elseif (get(handles.Oc,'Value') == 0 && get(handles.Or,'Value') == 0 && get(handles.Of,'Value') == 1)
    run Fill_Matrix_Alternative.m
else
    (get(handles.Or,'Value') == 0 && get(handles.Of,'Value') == 0 && get(handles.Oc,'Value') == 0);
    clear O
end

% --- Executes on button press in basic_next. - Next Push button 
function basic_next_Callback(hObject, eventdata, handles)
Tcw=handles.Tcn;
set(handles.Tcet,'String',num2str(Tcw));
disp(num2str(Tcw));
tmp=[floor(Tcw/15),floor(Tcw/3),floor(Tcw/10)];tmp(4)=Tcw-(tmp(1)+tmp(2)+tmp(3));
tabmod=get(handles.activitytable,'Data');
for i=1:4
    if(strcmpi(tabmod{i,1},"sitting"))
        tabmod{i,2}=tmp(2);
    elseif(strcmpi(tabmod{i,1},"reading"))
        tabmod{i,2}=tmp(3);
    elseif(strcmpi(tabmod{i,1},"eating"))
        tabmod{i,2}=tmp(1);    
    elseif(strcmpi(tabmod{i,1},"sleeping"))
        tabmod{i,2}=tmp(4);
    else
        tabmod{i,2}=0.0;
    end
end
set(handles.activitytable,'visible','on','Data',tabmod);
activity=get(handles.activitytable,'data');
assignin('base', 'activity', activity);
save('work02','-append','activity');

% --- Executes during object creation, after setting all properties.
function Tcet_CreateFcn(hObject, eventdata, handles) %Cruise time text box

function Tacc_Callback(hObject, eventdata, handles) 
Tacc=str2num(get(handles.Tacc,'String'));
assignin('base', 'Tacc', Tacc);

% --- Executes during object creation, after setting all properties.
function Tacc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when entered data in editable cell(ss) in activitytable.
function activitytable_CellEditCallback(hObject, eventdata, handles) %CO2 Activity Table
columns=2;
activity=get(handles.activitytable,'data');
assignin('base', 'activity', activity);
save('work02','-append','activity');

% --- Executes during object creation, after setting all properties.
function activitytable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to activitytable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%set(handles.activitytable,'visible','on','Data',k);

% --- Executes when entered data in editable cell(ss) in efftable. -
function efftable_CellEditCallback(hObject, eventdata, handles) % Ventilation Efficency data
handles.row_eff=eventdata.Indices(1,1);
handles.event_eff = get(handles.efftable,'data');
guidata(hObject, handles);

% --- Executes on button press in radioventeff.
function effok_Callback(hObject, eventdata, handles) % Ok Push Button to Calculate Meanage of the air
if (get(handles.effok,'Value') == 1)
    input_eff={};k=zeros(handles.row_eff,1);
    for i=1:handles.row_eff
        input_eff(end+1,:)=handles.event_eff(i,:);
        k(i)=180/(str2num(handles.event_eff{i,3}));
    end
    set(handles.agetable,'visible','on','Data',k);
    assignin('base', 'input_eff', input_eff);
    save('work02','-append','input_eff');
        
end

% --- Executes during object creation, after setting all properties.
function agetable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to agetable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes when selected cell(ss) is changed in agetable.

% --- Executes when entered data in editable cell(ss) in C_zone.
function C_zone_CellEditCallback(hObject, eventdata, handles) % Co2 Source- Manual
C_Z=get(handles.C_zone,'data');
assignin('base', 'C_Z', C_Z);
save('work02','-append','C_Z');

function radioco2_Callback(hObject, eventdata, handles) %Co2 Source- Randomise
if(get(handles.radioco2,'Value') == 1)
    rows=randi(4);table={};
    zone=randi(6,rows,1);
    for i=1:rows
        rate=rand*2.75+0.25;table{i,3}=rate;
        if(rate<=0.5)
            tock=randi([7,15]);
        elseif(rate<=1)
            tock=randi([4,15]);
        elseif(rate<=1.5)
            tock=randi([1,5]);
        elseif(rate<=2)
            tock=randi([1,3]);
        elseif(rate<=2.5)
            tock=randi([1,2]);
        else
            tock=1;
        end
        srtt=randi(handles.Tcn-20);table{i,1}=srtt;
        stpt=srtt + tock;table{i,2}=stpt;
        table{i,4}=zone(i);
    end
    C_Z=table;
    set(handles.C_zone,'visible','on','Data',C_Z);
    assignin('base', 'C_Z', C_Z);
    save('work02','-append','C_Z');
end
 
function turbStart_Callback(hObject, eventdata, handles) % PM Start box
% Hints: get(hObject,'String') returns contents of turbStart as text
%        str2double(get(hObject,'String')) returns contents of turbStart as a double
sTurb=str2num(get(handles.turbStart,'String'));
assignin('base', 'sTurb',sTurb);
save('work02','-append','sTurb');

% --- Executes during object creation, after setting all properties.
function turbStart_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function turbStop_Callback(hObject, eventdata, handles) % PM Stop box
% Hints: get(hObject,'String') returns contents of turbStop as text
%        str2double(get(hObject,'String')) returns contents of turbStop as a double
eTurb=str2num(get(handles.turbStop,'String'));
assignin('base', 'eTurb',eTurb);
save('work02','-append','eTurb');

% --- Executes during object creation, after setting all properties.
function turbStop_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pmturb_Callback(hObject, eventdata, handles) % PM turbulance Randomising
crs=handles.Tcn;
if(get(handles.pmturb,'Value') == 1)
    sTurb = randi([1,crs-20]);
    durTurb = randi([3,20]); %any random time within cruise period
    eTurb = sTurb + durTurb;
    %fprintf('Turbflg = %d',turbflg);
    assignin('base', 'sTurb', sTurb);
    assignin('base', 'eTurb', eTurb);
    save('work02','-append','sTurb','eTurb');
    set(handles.turbStart,'String',num2str(sTurb));
    set(handles.turbStop,'String',num2str(eTurb));
end

% --- Executes on selection change in popupS.
function popupS_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns popupS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupS
contents = cellstr(get(hObject,'String'));
S = str2num(contents{get(hObject,'Value')});
assignin('base', 'S', S);
save('work02','-append','S');
set(handles.SS,'String',num2str(S));
%disp(num2str(S));

% --- Executes during object creation, after setting all properties.
function popupS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function SS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'));
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupSource.
function popupSource_Callback(hObject, eventdata, handles) %Flight Takeoff Location
contents = cellstr(get(hObject,'String'));
srce = contents{get(hObject,'Value')};
assignin('base', 'srce', srce);
save('work02','-append','srce');

% --- Executes during object creation, after setting all properties.
function popupSource_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupDest.
function popupDest_Callback(hObject, eventdata, handles) %Flight Landing Location
contents = cellstr(get(hObject,'String'));
dst = contents{get(hObject,'Value')};
assignin('base', 'dst', dst);
save('work02','-append','dst');

% --- Executes during object creation, after setting all properties.
function popupDest_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sim_ECS_Callback(hObject, eventdata, handles) % Simulate ECS 
load('sim','Foz','Teq','flowrate');
assignin('base','Foz',Foz);
assignin('base','Teq',Teq);
assignin('base','flowrate',flowrate);
handles.countPress=handles.countPress+1;
guidata(hObject,handles);
if(handles.countPress == 1)
    set(handles.figure1,'pointer','watch')
    drawnow;
    %----------------------------%
    %delete(instrfindall); %delete all the  
    set(0,'RecursionLimit',100000000); %set the Recursion Limit
    if(get(handles.sim_ECS,'Value') == 1)
        ModelName = 'ssc_aircraft_ecs_data.mdl';% load the file name
        open_system(ModelName); % to open the simulink file to view
        %set_param(ModelName, 'SimulationCommand', 'start'); % automatically run the model file
        simOut = sim(ModelName,'ReturnWorkspaceOutputs','on');
        assignin('base', 'simOut', simOut);
        %run ssc_aircraft_ecs_data %simulate the model
        fprintf("ECS model simulation...\n");
        handles.simCheck = 1;
        guidata(hObject, handles);
    else
       fprintf("error simulating"); 
    end
    set(handles.figure1, 'pointer', 'arrow')
end
handles.countPress=0;
guidata(hObject,handles);

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in acok.
function acok_Callback(hObject, eventdata, handles) %Generate Data
if (get(handles.acok,'Value') == 1)
    fprintf("Initializing flight parameters\n");
    %run dataPullPM10.m %PM data for source and destination
    run activity_matrices.m %Human Activity 
    run venteff_table.m %anomaly creation with chnage in ventilation eff
    run Cn_activity.m %Independent CO2 Source
    %fprintf("Sheet 2 entry and Values generated\n");
    fprintf("Flight data generation \n");
    a=20  
    run co2_gen.m %Integrated CO2 data generation
    %run Simulink_data.m %Sheet 1 entry
    %run loop_data.m
    
%         run pm10_new.m % Particulate matter ppm levels
%%%     x1=evalin('base', 'S');
%%%     cmd=sprintf('sh ./tickstack_automation_v1.11.sh %g 2>&1 | tee tickstack_log.txt', x1);
%%%     system(cmd);
    %%winopen(fileName)                              %For Windows
    %system('libreoffice -o Simulink_Data.xlsx')     %For Ubuntu with LibreOffice
    %%%system('sh ./tickstack_automation.sh 2>&1 | tee tickstack_log.txt');
    %%%system('./tickstack_automation.sh')
    
    %x1=evalin('base', 'S');
    %cmd = sprintf('sh ./tickstack_automation_v1.11.sh %g 2>&1 | tee simple_log.txt', x1); 
    %system(cmd);
     %fprintf("Running Activity");
else
   fprintf("error loading\n"); 
end

% --- Executes during object creation, after setting all properties.
function text15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called






