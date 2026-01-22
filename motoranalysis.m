function varargout = motoranalysis(varargin)
% MOTORANALYSIS M-file for motoranalysis.fig
%      MOTORANALYSIS, by itself, creates a new MOTORANALYSIS or raises the existing
%      singleton*.
%
%      H = MOTORANALYSIS returns the handle to a new MOTORANALYSIS or the handle to
%      the existing singleton*.
%
%      MOTORANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTORANALYSIS.M with the given input arguments.
%
%      MOTORANALYSIS('Property','Value',...) creates a new MOTORANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before motoranalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to motoranalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help motoranalysis

% Last Modified by GUIDE v2.5 08-Feb-2018 15:23:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @motoranalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @motoranalysis_OutputFcn, ...
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


% --- Executes just before motoranalysis is made visible.
function motoranalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to motoranalysis (see VARARGIN)

% Choose default command line output for motoranalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% start GeometryEditor and store handles to its figure
GeometryEditor = geometryeditor('motoranalysis', hObject);
GeometryEditorHandles = guidata(GeometryEditor);
handles.GeometryEditor = GeometryEditor;

% start WindingEditor and store handles to its figure
WindingEditor = windingeditor('motoranalysis', hObject);
WindingEditorHandles = guidata(WindingEditor);
handles.WindingEditor = WindingEditor;

% start MeshEditor and store handles to its figure
MeshEditor = mesheditor('motoranalysis', hObject);
MeshEditorHandles = guidata(MeshEditor);
handles.MeshEditor = MeshEditor;

% start Materials and store handles to its figure
MaterialsWnd = materials('motoranalysis', hObject);
MaterialsHandles = guidata(MaterialsWnd);
handles.MaterialsWnd = MaterialsWnd;

% start DriveSettings and store handles to its figure
DriveSettings = drivesettings('motoranalysis', hObject);
DriveSettingsHandles = guidata(DriveSettings);
handles.DriveSettings = DriveSettings;

% start RatedData and store handles to its figure
RatedData = rateddata('motoranalysis', hObject);
RatedDataHandles = guidata(RatedData);
handles.RatedData = RatedData;

% start PlotWizard and store handles to its figure
PlotWizard = plotwizard('motoranalysis', hObject);
PlotWizardHandles = guidata(PlotWizard);
handles.PlotWizard = PlotWizard;
OuterPosition=get(PlotWizard,'OuterPosition');
handles.PlotWizardOuterPosition3=OuterPosition(3);
handles.PlotWizardOuterPosition4=OuterPosition(4);

% start IronLossCalculator and store handles to its figure
IronLossCalculator = ironlosscalculator('motoranalysis', hObject);
handles.IronLossCalculator = IronLossCalculator;

% Load picture to axes_DQstaticmodel
cm = linspace(0,1,16); cm = cm';
cm = [cm cm cm];
newplot(handles.axes_DQstaticmodel);
axes(handles.axes_DQstaticmodel);
image(imread('DQstatic.bmp'));
colormap(cm);
axis image
axis off

% load stop button icon
load('stopicon.mat','stopicon');
set(handles.toolbarStopSimulation,'CData',stopicon);

% Tooltips
Tooltip=sprintf('Specifies the accuracy of FEA solutions while the D-Q model \nparameters are computed.');
set(handles.text_DQ_tol,'TooltipString',Tooltip);
set(handles.edit_DQ_tol,'TooltipString',Tooltip);

tooltip1='Maximum RMS supply current for which the D-Q model parameters \nare computed. For the star connected stator winding the supply';
tooltip2='\ncurrent is equal to the phase current; for the delta connected stator \nwinding the supply current is equal to the phase current multiplied \nby sqrt(3).';
Tooltip=sprintf([tooltip1 tooltip2]);
set(handles.text_DQ_Isrms_max,'TooltipString',Tooltip);
set(handles.edit_DQ_Isrms_max,'TooltipString',Tooltip);

Tooltip=sprintf('Defines the RMS supply current values from zero to the Maximum \nRMS supply current for which the D-Q model parameters are \ncomputed.');
set(handles.text_DQ_Isrms_step,'TooltipString',Tooltip);
set(handles.edit_DQ_Isrms_step,'TooltipString',Tooltip);

Tooltip=sprintf('Defines values of the advance angle of current phasor relative to \nq-axis in the range of 0 to 360 electrical degrees for which the \nD-Q model parameters are computed.');
set(handles.text_DQ_gamma_step,'TooltipString',Tooltip);
set(handles.edit_DQ_gamma_step,'TooltipString',Tooltip);

Tooltip=sprintf('Specifies the number of time steps in one electrical period for \nwhich the finite element simulation runs.');
set(handles.text_MS_npoints,'TooltipString',Tooltip);
set(handles.edit_MS_npoints,'TooltipString',Tooltip);

tooltip1='RMS supply current of the machine used for the finite element \nsimulation. For the star connected stator winding the supply';
tooltip2='\ncurrent is equal to the phase current; for the delta connected stator \nwinding the supply current is equal to the phase current multiplied \nby sqrt(3).';
Tooltip=sprintf([tooltip1 tooltip2]);
set(handles.text_MS_I,'TooltipString',Tooltip);
set(handles.edit_MS_I,'TooltipString',Tooltip);

Tooltip=sprintf('Advance angle of current phasor relative to q-axis in the range \nbetween 0 and 360 electrical degrees.');
set(handles.text_MS_gamma,'TooltipString',Tooltip);
set(handles.edit_MS_gamma,'TooltipString',Tooltip);

Tooltip=sprintf('By definition, the cogging torque is the torque at zero stator current \nso it is computed at a cost of one additional FEA solution for each \ntime step.');
set(handles.checkbox_MS_coggingtorque,'TooltipString',Tooltip);

tooltip1='Enables to store additional data of FEA solution such as magnetic \nvector potential and permeability values for each time step.';
tooltip2='\nIf ''Save each field solution'' is not checked, the Air gap distribution';
tooltip3='\nplot and the Cross-section distribution plot of Plot Wizard will be';
tooltip4='\navailable only for zero time step and the animation option will not';
tooltip5='\nbe available.';
Tooltip=sprintf([tooltip1 tooltip2 tooltip3 tooltip4 tooltip5]);
set(handles.checkbox_MS_saveeachsolution,'TooltipString',Tooltip);
set(handles.text_MS_infolder,'TooltipString',Tooltip);
set(handles.pup_MS_saveeachsolutionfolder,'TooltipString',Tooltip);

Tooltip=sprintf('Specifies how the parameters of the D-Q model are \ninterpolated.');
set(handles.pup_DD_solvertype,'TooltipString',Tooltip);
set(handles.text_DD_solvertype,'TooltipString',Tooltip);

Tooltip=sprintf('Specifies the acceptable variation of RMS current \nfrom one period to the next to check if the steady-state is reached.');
set(handles.pup_DD_Itol,'TooltipString',Tooltip);
set(handles.text_DD_Itol,'TooltipString',Tooltip);

tooltip1='RMS current to be supplied by the inverter. \nFor the star connected stator winding the supply current';
tooltip2='\nis equal to the phase current; for the delta connected stator \nwinding the supply current is equal to the phase current \nmultiplied by sqrt(3).';
Tooltip=sprintf([tooltip1 tooltip2]);
set(handles.edit_DD_Isrms,'TooltipString',Tooltip);
set(handles.text_DD_Isrms,'TooltipString',Tooltip);

tooltip1='General - default simulation script and stator electrical circuit are used;';
tooltip2='\nAdvanced - simulation script and stator electrical circuit are defined by user.';
Tooltip=sprintf([tooltip1 tooltip2]);
set(handles.pup_DF_settings,'TooltipString',Tooltip);
set(handles.text_DF_settings,'TooltipString',Tooltip);

tooltip1='MATLAB-function which is called on each simulation time step and';
tooltip2='\nallows you to change all general simulation settings, compute and';
tooltip3='\nstore user defined variables, control power supply sources and';
tooltip4='\nelectronic switches, implement motor control algorithms and etc.';
Tooltip=sprintf([tooltip1 tooltip2 tooltip3 tooltip4]);
set(handles.pup_DF_script,'TooltipString',Tooltip);
set(handles.text_DF_script,'TooltipString',Tooltip);

tooltip1='RMS current to be supplied by the inverter. \nFor the star connected stator winding the supply current';
tooltip2='\nis equal to the phase current; for the delta connected stator \nwinding the supply current is equal to the phase current \nmultiplied by sqrt(3).';
Tooltip=sprintf([tooltip1 tooltip2]);
set(handles.edit_DF_Isrms,'TooltipString',Tooltip);
set(handles.text_DF_Isrms,'TooltipString',Tooltip);

tooltip1='If checked, the FE simulation is started with the initial state';
tooltip2='\n(initial values of magnetic field, currents and voltages) computed';
tooltip3='\nusing the dynamic D-Q model so the dynamic FE simulation enters';
tooltip4='\nthe steady-state in less number of time steps.';
Tooltip=sprintf([tooltip1 tooltip2 tooltip3 tooltip4]);
set(handles.checkbox_DF_DQinitcnd,'TooltipString',Tooltip);

tooltip1='Enables to store additional data of FEA solution such as magnetic \nvector potential and permeability values for each time step.';
tooltip2='\nIf ''Save each field solution'' is not checked, the Air gap distribution';
tooltip3='\nplot and the Cross-section distribution plot of Plot Wizard will be';
tooltip4='\navailable only for last computed time step and the animation option';
tooltip5='\nwill not be available.';
Tooltip=sprintf([tooltip1 tooltip2 tooltip3 tooltip4 tooltip5]);
set(handles.checkbox_DF_saveeachsolution,'TooltipString',Tooltip);
set(handles.text_DF_infolder,'TooltipString',Tooltip);
set(handles.pup_DF_saveeachsolutionfolder,'TooltipString',Tooltip);

set(handles.text_MS_Iunit1,'String','A');
set(handles.text_MS_Iunit2,'Visible','off');

handles.Simulation = CreateSimulation();
handles.File = [];
handles.Saved = 1;
handles.StopSimulation = 0;
handles.disableall = 0;
strlist = cell(1,1); strlist{1,1} = cd;
set(handles.pup_DF_saveeachsolutionfolder,'String',strlist);
set(handles.pup_MS_saveeachsolutionfolder,'String',strlist);
strlist{1,1} = 'InverterCircuit';
set(handles.pup_DF_statorcircuit,'String',strlist);
strlist = cell(3,1);
strlist{1,1} = 'simscript_hystpwm.m';
strlist{2,1} = 'simscript_spacevecpwm.m';
strlist{3,1} = 'simscript_sixstep.m';
set(handles.pup_DF_script,'String',strlist);
% colormap('default');
% publish functions
handles.Update = @Update;
handles.Save_Callback = @Save_Callback;
% update handles structure
guidata(hObject, handles);
% update main window
Update(hObject);
% load geometry to GeometryEditor
GeometryEditorHandles.UpdateGeometryEditor(GeometryEditor);
% load winding properties to WindingEditor
WindingEditorHandles.UpdateWindingEditor(WindingEditor,0,0);
% load mesh properties to MeshEditor
MeshEditorHandles.UpdateMeshEditor(MeshEditor);
% load materials to Materials window
MaterialsHandles.UpdateMaterials(MaterialsWnd);
% load drive settings to Drive Settings window
DriveSettingsHandles.UpdateDriveSettings(DriveSettings);
% load rated data to Rated Data window
RatedDataHandles.UpdateRatedData(RatedData);
% Update PlotWizard
PlotWizardHandles.UpdatePlotWizard(PlotWizard,[]);
togglebutton_AnalysisType_Callback(handles.togglebutton_MS, eventdata, handles)
% create profile
if ~exist('profilePM.mat','file')
    profile.substepmax='40';
    profile.relaxmin='1.0e-08';
    profile.convreport=1;
    profile.NonconvHnd=2;
    profile.vd='1.0e-10';
    profile.vad='1.0e-09';
    profile.ECLnlayers='20';
    profile.MesherPreference=1;
    save('profilePM.mat','profile');
end
% Check new version
CheckNewVersionDate=[];
if exist('profilePM.mat','file')
    load('profilePM.mat','profile');
    if isfield(profile,'CheckNewVersionDate')
        CheckNewVersionDate=profile.CheckNewVersionDate;
    end
end
NowDate=clock;
NowDate=NowDate(1:3);
if isempty(CheckNewVersionDate) || any(CheckNewVersionDate~=NowDate)    % if did not check new version today
    try
        url = 'http://u.to/spROEA';
        currentversion = urlread(url);
        ind=strfind(currentversion,'motoranalysis-pm:');
        currentversion=currentversion(ind+18:end);
        currentversion=strtrim(currentversion);
        if ~strcmp(currentversion,'1.1')
            msgbox({'New version is available.';
                'Please download from http://motoranalysis.com/'},'MotorAnalysis','modal');
        end
    end
    profile.CheckNewVersionDate=NowDate;
    save('profilePM.mat','profile');
end
uiwait(hObject);


function Simulation = CreateSimulation()
% Create an empty simulation structure with default parameters
Simulation.Geometry = []; Simulation.Mesh = []; Simulation.Windings = []; Simulation.Materials = []; Simulation.Drive = []; Simulation.RatedData = [];
Simulation.DXFrotor = []; Simulation.DXFstator = []; Simulation.Settings = []; Simulation.Private = []; Simulation.Userdata = [];
Geometry.D1s=[]; Geometry.D2s=[]; Geometry.Ods=[]; Geometry.Ows=[]; Geometry.Tas=0; Geometry.Sds=[]; 
Geometry.Rcs=0; Geometry.Ws=[]; Geometry.Ns=[]; Geometry.lag=[];
Geometry.Dch=0; Geometry.Rch=0; Geometry.Tach=0;
Geometry.motortype='Inner rotor'; Geometry.statorslottype='Parallel tooth'; Geometry.slotlayertype='Single layer'; Geometry.layerpos='Upper/Lower';
Geometry.statorslotcornertype='General'; Geometry.Rcs_ag=[];
Geometry.l=[]; Geometry.rotorskew=0; Geometry.statorskew=0; Geometry.dxfstator=0;
Simulation.Geometry = Geometry;
Windings.Npp=[]; Windings.W=[]; Windings.ks=[]; Windings.windingtype='Lap'; Windings.nstrands=1;
%Windings.Ts=20; Windings.alfa_s=0; 
Windings.wiresizemethod='Wire diameter'; Windings.wiresize='20 AWG'; Windings.wirediameter=1;  Windings.fillfactor=[]; 
Windings.statorcircuit='StarConnection'; Windings.Hsew=[]; Windings.layoutmethod='Manual'; Windings.nPolePairs=[]; Windings.coilspan=[]; 
Windings.Lsew_inputmethod='Automatic'; Windings.Rs_inputmethod='Automatic'; Windings.layout=[]; Windings.Lsew=[]; Windings.Rs=[];
Simulation.Windings = Windings;
Mesh.nAirGapLayers=3; Mesh.Hgrad=1.4; Mesh.agmeshqlt='Medium'; Mesh.nSlices=1; Mesh.perbndcnd='None'; Mesh.nPolePairs=[];
Mesh.p=[]; Mesh.t=[]; Mesh.e=[]; Mesh.b=[]; Mesh.Rotate=[];
Simulation.Mesh = Mesh;
Materials.statorwindingmaterial='Not assigned'; Materials.statorironmaterial='Not assigned'; Materials.k_st_stator=1; 
Materials.rotorironmaterial='Not assigned'; Materials.k_st_rotor=1; Materials.magnetmaterial='Not assigned'; Materials.Nmagnetsegments=1;
Materials.Tsw=20; Materials.Tpm=20;
Simulation.Materials = Materials;
Drive.Vdc = 1; Drive.DriveType = 'Current hysteresis PWM'; Drive.Is_hyst_perc = 15; Drive.fspwm = 1000; 
Drive.SwitchDutyCycle_sixstep = '120'; Drive.CommutationAdvanceAngle_sixstep = 0; Drive.SixStepOptions = 'General'; Drive.Is_max_sixstep = 1; 
Drive.Is_hyst_perc_sixstep = 15; Drive.Vdc_perc_sixstep = 100;
Simulation.Drive = Drive;
RatedData.RatedCurrent = []; RatedData.RatedPower = []; RatedData.RatedSpeed = []; RatedData.MomentInertia = [];
Simulation.RatedData = RatedData;
Settings.Magnetostatic.MS_solvertype = 'Nonlinear'; Settings.Magnetostatic.MS_tol = 0.001;
Settings.Magnetostatic.MS_I = 1; Settings.Magnetostatic.MS_npoints = 1; Settings.Magnetostatic.MS_speed = 1000;
Settings.Magnetostatic.MS_currentwaveform = 'Sinusoidal'; Settings.Magnetostatic.MS_gamma = 0; Settings.Magnetostatic.MS_currentinputmethod = 'RMS supply current';
Settings.Magnetostatic.MS_coggingtorque = 1; Settings.Magnetostatic.MS_saveeachsolution = 0; Settings.Magnetostatic.MS_saveeachsolutionfolder = cd; 
Settings.DQ.DQ_tol = 0.00001; Settings.DQ.DQ_Isrms_max = 1; Settings.DQ.DQ_Isrms_step = 0.02; Settings.DQ.DQ_gamma_step = 5; Settings.DQ.DQ_nRotang=5;

Settings.DynamicFEA.DF_solvertype = 'Nonlinear'; Settings.DynamicFEA.DF_tol = 0.01; Settings.DynamicFEA.DF_settings = 'General';
Settings.DynamicFEA.DF_script = 'simscript_hystpwm.m'; Settings.DynamicFEA.DF_statorcircuit = 'InverterCircuit'; Settings.DynamicFEA.DF_stoptime = 1;
Settings.DynamicFEA.DF_timestep = 10^-6; Settings.DynamicFEA.DF_Isrms = 1; Settings.DynamicFEA.DF_Gamma = 0; Settings.DynamicFEA.DF_motorload = 0; 
Settings.DynamicFEA.DF_SpeedDependency = 'Fixed speed simulation'; Settings.DynamicFEA.DF_Speed = 0; Settings.DynamicFEA.DF_InitSpeed = 0; 
Settings.DynamicFEA.DF_torquemethod = 'Maxwell stress tensor'; Settings.DynamicFEA.DF_force = 0; Settings.DynamicFEA.DF_saveeachsolution = 0; 
Settings.DynamicFEA.DF_saveeachsolutionfolder = cd; Settings.DynamicFEA.DF_ironlossmulti = 0; Settings.DynamicFEA.DF_DQinitcnd = 1;

Settings.DynamicDQ.DD_solvertype = 'Linearized';
Settings.DynamicDQ.DD_StopMethod = 'stop time is reached'; Settings.DynamicDQ.DD_stoptime = 1; Settings.DynamicDQ.DD_Itol = '0.5%';
Settings.DynamicDQ.DD_timestep = 10^-6; Settings.DynamicDQ.DD_Gamma = 0; Settings.DynamicDQ.DD_Isrms = 1; Settings.DynamicDQ.DD_motorload = 0;
Settings.DynamicDQ.DD_SpeedDependency = 'Fixed speed simulation'; Settings.DynamicDQ.DD_Speed = 0; Settings.DynamicDQ.DD_InitSpeed = 0;

Simulation.Settings = Settings;
Magnetostatic.nPolePairs=[]; Magnetostatic.Timesteppingdata=[]; Magnetostatic.Results=[];
Simulation.Magnetostatic = Magnetostatic;
DQmodel.Iphaserms=[]; DQmodel.Gamma=[]; DQmodel.DQ_Ld=[]; DQmodel.DQ_Lq=[]; DQmodel.DQ_Ldq=[]; DQmodel.DQ_Fluxlinkage_md=[]; DQmodel.DQ_Fluxlinkage_mqd=[]; 
DQmodel.nPolePairs=[];
Simulation.DQmodel = DQmodel;
DynamicFEA.nPolePairs=[]; DynamicFEA.gamma0=0; DynamicFEA.CurrentTime = 0; DynamicFEA.time=[]; DynamicFEA.Ia=[]; DynamicFEA.Ib=[]; DynamicFEA.Ic=[]; 
DynamicFEA.Id=[]; DynamicFEA.Iq=[]; DynamicFEA.Va=[]; DynamicFEA.Vb=[]; DynamicFEA.Vc=[]; DynamicFEA.Vd=[]; DynamicFEA.Vq=[]; DynamicFEA.Gamma=[];
DynamicFEA.BackEMFa=[]; DynamicFEA.BackEMFb=[]; DynamicFEA.BackEMFc=[]; DynamicFEA.BackEMFd=[]; DynamicFEA.BackEMFq=[]; DynamicFEA.Psi=[];
DynamicFEA.Fluxlinkage_a=[]; DynamicFEA.Fluxlinkage_b=[]; DynamicFEA.Fluxlinkage_c=[]; DynamicFEA.Fluxlinkage_d=[]; DynamicFEA.Fluxlinkage_q=[];
DynamicFEA.Torque=[]; DynamicFEA.Load=[]; DynamicFEA.Speed=[]; DynamicFEA.Rotang=[]; DynamicFEA.Pinput=[]; DynamicFEA.Pcons=[]; DynamicFEA.Pmech=[]; 
DynamicFEA.Ps=[]; DynamicFEA.Pmf=[]; DynamicFEA.Piron.rotor=[]; DynamicFEA.Piron.stator=[]; DynamicFEA.Piron.details=[]; DynamicFEA.Piron_density=[]; 
DynamicFEA.Fx=[]; DynamicFEA.Fy=[]; DynamicFEA.Torque_maxwell=[]; DynamicFEA.Torque_vwork=[]; DynamicFEA.Torque_fluxlinkage=[]; DynamicFEA.Torque_magnet=[]; 
DynamicFEA.Torque_reluctance=[]; DynamicFEA.DemagH_max=[]; DynamicFEA.DemagHpercent_max=[]; DynamicFEA.MagnetLoss=[];
Simulation.DynamicFEA = DynamicFEA;
DynamicDQ.nPolePairs=[]; DynamicDQ.time=[]; DynamicDQ.Va=[]; DynamicDQ.Vb=[]; DynamicDQ.Vc=[]; DynamicDQ.Ia=[]; DynamicDQ.Ib=[]; DynamicDQ.Ic=[]; 
DynamicDQ.Vd=[]; DynamicDQ.Vq=[]; DynamicDQ.Id=[]; DynamicDQ.Iq=[]; DynamicDQ.Gamma=[]; DynamicDQ.BackEMFd=[]; DynamicDQ.BackEMFq=[];
DynamicDQ.BackEMFa=[]; DynamicDQ.BackEMFb=[]; DynamicDQ.BackEMFc=[]; DynamicDQ.Speed=[]; DynamicDQ.Torque=[]; DynamicDQ.Load=[]; DynamicDQ.Rotang=[];
DynamicDQ.Pinput=[]; DynamicDQ.Preact=[]; DynamicDQ.Ps=[]; DynamicDQ.Pmech=[]; DynamicDQ.Pmf=[]; DynamicDQ.Fluxlinkage_a=[]; DynamicDQ.Fluxlinkage_b=[]; 
DynamicDQ.Fluxlinkage_c=[]; DynamicDQ.Fluxlinkage_d=[]; DynamicDQ.Fluxlinkage_q=[]; DynamicDQ.Torque_magnet=[]; DynamicDQ.Torque_reluctance=[];
DynamicDQ.Ld=[]; DynamicDQ.Lq=[]; DynamicDQ.Ldq=[]; DynamicDQ.Fluxlinkage_md=[]; DynamicDQ.Fluxlinkage_mqd=[];
Simulation.DynamicDQ = DynamicDQ;

Simulation.EfficiencyMap=[];

% --- Outputs from this function are returned to the command line.
function varargout = motoranalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% varargout{1} = handles.mIconCData;
delete(handles.GeometryEditor);
delete(handles.WindingEditor);
delete(handles.MeshEditor);
delete(handles.MaterialsWnd);
delete(handles.DriveSettings);
delete(handles.RatedData);
delete(handles.PlotWizard);
delete(handles.IronLossCalculator);
delete(hObject);


% --- Executes when user attempts to close motoranalysis.
function motoranalysis_CloseRequestFcn(hObject, eventdata, handles)
if ~handles.Saved
    File = handles.File;
    if isempty(File)
        File = 'the current simulation';
    end
    button = questdlg(['Save changes to ' File '?'],'MotorAnalysis');
    if strcmp(button,'No') 
        % no action
    elseif strcmp(button,'Yes')
        Save_Callback(handles.menuSave, [], handles);
    else
        return
    end
end
h_taq=findobj('type','figure','Tag','timeaveragedquantities');
if ~isempty(h_taq)
    close(h_taq);
end
uiresume(hObject);

function editmotoranalysisCallback(hObject, eventdata, handles)
Simulation = handles.Simulation;
Drive=Simulation.Drive;
if get(handles.togglebutton_MS,'Value');
    SettingsChosen = Simulation.Settings.Magnetostatic;
elseif get(handles.togglebutton_DQ,'Value');
    SettingsChosen = Simulation.Settings.DQ;
elseif get(handles.togglebutton_dynamicFEA,'Value');
    SettingsChosen = Simulation.Settings.DynamicFEA;
elseif get(handles.togglebutton_dynamicDQ,'Value');
    SettingsChosen = Simulation.Settings.DynamicDQ;    
else
    return
end
handles.Saved = 0;
% editbox | popupmenu | checkbox   Tag
Tag = get(hObject,'Tag');
if strcmp(Tag(1:4),'edit')     % if editbox changed
    % editbox value
    String = get(hObject,'String');
    Field = Tag(6:end);
    if isfield(SettingsChosen,Field)
        [FieldValue, status] = str2num(String);
        if isempty(FieldValue) || ~status || length(FieldValue)>1 || ~isreal(FieldValue) || isinf(FieldValue) || isnan(FieldValue)
            errordlg('Not a valid value.','Error','modal');
        elseif (strcmp(Field,'DQ_tol') || strcmp(Field,'DQ_Isrms_max') || strcmp(Field,'DQ_Isrms_step') || strcmp(Field,'DQ_gamma_step') || strcmp(Field,'DQ_nRotang')...
                || strcmp(Field,'MS_tol') || strcmp(Field,'MS_I') || strcmp(Field,'MS_npoints') || strcmp(Field,'MS_speed') || strcmp(Field,'DD_stoptime')...
                || strcmp(Field,'DD_timestep') || strcmp(Field,'DD_Isrms') || strcmp(Field,'DD_Speed')  || strcmp(Field,'DD_InitSpeed') || strcmp(Field,'DF_tol') ...
                || strcmp(Field,'DF_tol')  || strcmp(Field,'DF_stoptime') || strcmp(Field,'DF_timestep') || strcmp(Field,'DF_Isrms')) && FieldValue<0
            errordlg('Not a valid value.','Error','modal');
        elseif (strcmp(Field,'MS_gamma') || strcmp(Field,'DF_Gamma') || strcmp(Field,'DD_Gamma')) && (FieldValue<0 || FieldValue>360)
            errordlg('Not a valid value.','Error','modal');
        else
            SettingsChosen = setfield(SettingsChosen,Field,FieldValue);
        end
    end
elseif strcmp(Tag(1:3),'pup')     % if popupmenu changed
    % popupmenu value
    index = get(hObject,'Value');
    strlist = get(hObject,'String');
    String = strlist{index,1};
    Field = Tag(5:end);
    changed=0;
    if isfield(SettingsChosen,Field)
        if ~isempty(String)
            if ~strcmp(SettingsChosen.(Field),String)
                changed=1;
            end
            SettingsChosen = setfield(SettingsChosen,Field,String);
            % index=get(hObject,'Value');
            % set(hObject,'UserData',index);
        else
            error('String is empty');
        end
    end
    if strcmp(Field,'DF_settings')
        if index==1   % General
            if strcmp(Drive.DriveType,'Current hysteresis PWM')
                SettingsChosen.DF_script = 'simscript_hystpwm.m';
                SettingsChosen.DF_SpeedDependency = 'Fixed speed simulation';
            elseif strcmp(Drive.DriveType,'Space vector PWM')
                SettingsChosen.DF_script = 'simscript_spacevecpwm.m';
                SettingsChosen.DF_SpeedDependency = 'Fixed speed simulation';
            elseif strcmp(Drive.DriveType,'Six-step')
                SettingsChosen.DF_script = 'simscript_sixstep.m';
            else
                error('Undefined drive type')
            end
            SettingsChosen.DF_statorcircuit = 'InverterCircuit';
        end
    end
    if strcmp(Field,'MS_currentwaveform')
        if changed
            if strcmp(String,'Sinusoidal')
                if strcmp(SettingsChosen.MS_currentinputmethod,'RMS phase current')
                    SettingsChosen.MS_currentinputmethod='RMS supply current';
                elseif strcmp(SettingsChosen.MS_currentinputmethod,'DC supply current')
                	SettingsChosen.MS_currentinputmethod='Peak supply current';
                end
            elseif strcmp(String,'Trapezoidal')
                if strcmp(SettingsChosen.MS_currentinputmethod,'RMS supply current')
                    SettingsChosen.MS_currentinputmethod='RMS phase current';
                elseif strcmp(SettingsChosen.MS_currentinputmethod,'Peak supply current')
                	SettingsChosen.MS_currentinputmethod='DC supply current';
                end
            end
        end
    end
elseif strcmp(Tag(1:8),'checkbox')     % if checkbox changed
    % checkbox value
    Value = get(hObject,'Value');
    Field = Tag(10:end);
    if Value
        SettingsChosen = setfield(SettingsChosen,Field,1);
    else
        SettingsChosen = setfield(SettingsChosen,Field,0);
    end
    if strcmp(Field,'DF_ironlossmulti')
        if Value
            SettingsChosen.DF_saveeachsolution=1;
        else
            SettingsChosen.DF_saveeachsolution=0;
        end
    end
end
if get(handles.togglebutton_MS,'Value')
    Simulation.Settings.Magnetostatic = SettingsChosen;
elseif get(handles.togglebutton_DQ,'Value')
    Simulation.Settings.DQ = SettingsChosen;    
elseif get(handles.togglebutton_dynamicFEA,'Value')
    Simulation.Settings.DynamicFEA = SettingsChosen;
elseif get(handles.togglebutton_dynamicDQ,'Value')
    Simulation.Settings.DynamicDQ = SettingsChosen;    
else
    return
end
handles.Simulation = Simulation;
guidata(hObject,handles);
Update(hObject);

function noeditCallback(hObject, eventdata, handles)
Update(handles.motoranalysis);

function Update(hObject,loadfile)
handles = guidata(hObject);
Simulation = handles.Simulation;
Drive = Simulation.Drive;
disableall = handles.disableall;
if disableall
    set(findall(handles.panel_MS, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.panel_DQ, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.panel_dynamicFEA, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.panel_dynamicDQ, '-property', 'enable'), 'enable', 'off');
    set(handles.text_DF_processing,'Enable','on');
    set(handles.text608,'Enable','on');
    set(handles.text609,'Enable','on');
    set(handles.text610,'Enable','on');
    set(handles.text611,'Enable','on');
    set(handles.text_MS_processing,'Enable','on');
    set(handles.text616,'Enable','on');
    set(handles.text617,'Enable','on');
    set(handles.pushbutton_buildDQmodel,'Enable','on');
    set(handles.text_DD_processing,'Enable','on'); 
else
    set(findall(handles.panel_MS, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.panel_DQ, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.panel_dynamicFEA, '-property', 'enable'), 'enable', 'on');
    set(findall(handles.panel_dynamicDQ, '-property', 'enable'), 'enable', 'on');
end
set(handles.edit_DF_laststepcalctime,'Enable','inactive');
set(handles.edit_DF_totalcalctime,'Enable','inactive');
set(handles.edit_MS_f1,'Enable','off');
set(handles.edit_MS_nPolePairs,'Enable','off');
set(handles.text_dqmodel,'Enable','on');
if exist('loadfile','var') && loadfile    % update all items if new file is loaded (gather all fields in SettingsChosen)
    SettingsChosen = Simulation.Settings.Magnetostatic;
    tmpstruct=Simulation.Settings.DQ;
    Fields = fieldnames(tmpstruct);
    for n=1:length(Fields)
        Field=Fields{n};
        SettingsChosen.(Field)=tmpstruct.(Field);
    end
    tmpstruct=Simulation.Settings.DynamicFEA;
    Fields = fieldnames(tmpstruct);
    for n=1:length(Fields)
        Field=Fields{n};
        SettingsChosen.(Field)=tmpstruct.(Field);
    end
    tmpstruct=Simulation.Settings.DynamicDQ;
    Fields = fieldnames(tmpstruct);
    for n=1:length(Fields)
        Field=Fields{n};
        SettingsChosen.(Field)=tmpstruct.(Field);
    end
else
    if get(handles.togglebutton_MS,'Value')
        SettingsChosen = Simulation.Settings.Magnetostatic;
    elseif get(handles.togglebutton_DQ,'Value')
        SettingsChosen = Simulation.Settings.DQ;
    elseif get(handles.togglebutton_dynamicFEA,'Value')
        SettingsChosen = Simulation.Settings.DynamicFEA;
    elseif get(handles.togglebutton_dynamicDQ,'Value')
        SettingsChosen = Simulation.Settings.DynamicDQ;        
    else
        return
    end
end

% update editbox, popup menu and checkbox values
Fields = fieldnames(SettingsChosen);
for n=1:length(Fields)
    Field = Fields{n};
    editbox = ['edit_' Field];
    if isfield(handles,editbox)           % if editbox
        FieldValue = getfield(SettingsChosen,Field);
        if iscell(FieldValue)
            FieldValue=[num2str(size(FieldValue,1)) 'x' num2str(size(FieldValue,2)) 'array'];     % for DF_motorload and DD_motorload
            set(getfield(handles,editbox),'String',FieldValue);
        elseif ischar(FieldValue)
            set(getfield(handles,editbox),'String',FieldValue);
        else
            set(getfield(handles,editbox),'String',num2str(FieldValue,10));
        end
    end
    popup = ['pup_' Field];
    if isfield(handles,popup)           % if popup menu
        FieldValue = getfield(SettingsChosen,Field);
        strlist = get(getfield(handles,popup),'String');
        if strcmp(Field,'MS_currentinputmethod')
            strlist = cell(3,1);
            if strcmp(SettingsChosen.MS_currentwaveform,'Sinusoidal')
                strlist{1,1} = 'RMS supply current';
                strlist{2,1} = 'Peak supply current';
                strlist{3,1} = 'RMS current density';
            elseif strcmp(SettingsChosen.MS_currentwaveform,'Trapezoidal')
                strlist{1,1} = 'RMS phase current';
                strlist{2,1} = 'DC supply current';
                strlist{3,1} = 'RMS current density';
            end
        end
        if isempty(strlist)
            strlist = cell(1,1);
            strlist{1,1} = FieldValue;
            set(getfield(handles,popup),'String',strlist);
        end
        for i=1:length(strlist)
            if strcmp(FieldValue,strlist(i))
                break;
            elseif i==length(strlist)  % if thire is no FieldValue in strlist when add it (not for all popup menus)
                if strcmp(Field,'MS_saveeachsolutionfolder') || strcmp(Field,'DF_saveeachsolutionfolder') ||...
                   strcmp(Field,'DF_script') || strcmp(Field,'DF_statorcircuit')
                    strlist_ = strlist;
                    strlist = cell(length(strlist)+1,1);
                    for j=1:length(strlist_)
                        strlist{j,1}=strlist_{j,1};
                    end
                    i = i+1;
                    strlist{i,1} = FieldValue;
                    set(getfield(handles,popup),'String',strlist);
                    break;
                else
                    error(['Inappropriate value for <' Field '>: something goes wrong']);
                end
            end
        end
        set(getfield(handles,popup),'Value',i);
        set(getfield(handles,popup),'UserData',i);        % store item index in UserData
    end
    CheckBox = ['checkbox_' Field];
    if isfield(handles,CheckBox)           % if checkbox
        CheckBoxValue = getfield(SettingsChosen,Field);
        if CheckBoxValue
            set(getfield(handles,CheckBox),'Value',1);
        else
            set(getfield(handles,CheckBox),'Value',0);
        end
    end
end

if get(handles.togglebutton_dynamicFEA,'Value')
    DynamicFEA=Simulation.DynamicFEA;
    if DynamicFEA.CurrentTime<eps  
        set(handles.text_DF_processing,'String','No simulation data');
    else
        set(handles.text_DF_processing,'String',['Simulation stopped at ' num2str(DynamicFEA.time(end)-DynamicFEA.time(1)) ' seconds']);
    end
    if Simulation.DynamicFEA.CurrentTime<eps
        enablebylock='on';     % if dynamic FE simulation not yet started
    else
        enablebylock='off';
    end    
    if strcmp(SettingsChosen.DF_solvertype,'Nonlinear')
        set(handles.text_DF_tol,'Visible','on');
        set(handles.edit_DF_tol,'Visible','on');
    else    % Linear
        set(handles.text_DF_tol,'Visible','off');
        set(handles.edit_DF_tol,'Visible','off');
    end
    if strcmp(SettingsChosen.DF_settings,'Advanced')
        if ~disableall
            set(handles.text_DF_script,'Enable','on');
            set(handles.pup_DF_script,'Enable','on');
            set(handles.pushbutton_DF_chgscript,'Enable','on');
            set(handles.text_DF_statorcircuit,'Enable',enablebylock);
            set(handles.pup_DF_statorcircuit,'Enable',enablebylock);
            set(handles.pushbutton_DF_chgstatorcircuit,'Enable',enablebylock);
        end
    else   % General
        set(handles.text_DF_script,'Enable','off');
        set(handles.pup_DF_script,'Enable','off');
        set(handles.pushbutton_DF_chgscript,'Enable','off');
        set(handles.text_DF_statorcircuit,'Enable','off');
        set(handles.pup_DF_statorcircuit,'Enable','off');
        set(handles.pushbutton_DF_chgstatorcircuit,'Enable','off');
    end
    if (strcmp(Drive.DriveType,'Current hysteresis PWM') || strcmp(Drive.DriveType,'Space vector PWM')) && ...
        strcmp(SettingsChosen.DF_settings,'General')     
        set(handles.text_DF_motorload,'Visible','off');
        set(handles.edit_DF_motorload,'Visible','off');
        set(handles.text_DF_motorloadunit,'Visible','off');
        set(handles.pushbutton_DF_motorloadprofile,'Visible','off');
        set(handles.pup_DF_SpeedDependency,'Enable','off');
    else   % Drive.DriveType=='Six-step' || SettingsChosen.DF_settings=='Advanced'
        set(handles.text_DF_motorload,'Visible','on');
        set(handles.edit_DF_motorload,'Visible','on');
        set(handles.text_DF_motorloadunit,'Visible','on');
        set(handles.pushbutton_DF_motorloadprofile,'Visible','on');
        if ~disableall
            set(handles.pup_DF_SpeedDependency,'Enable','on');
        end
    end
    if strcmp(Drive.DriveType,'Current hysteresis PWM') || strcmp(Drive.DriveType,'Space vector PWM') || ...
       strcmp(SettingsChosen.DF_settings,'Advanced')     
        set(handles.text_DF_gamma,'Visible','on');
        set(handles.edit_DF_Gamma,'Visible','on');
        set(handles.text_DF_gamma_unit2,'Visible','on');
        set(handles.text_DF_gamma_unit1,'Visible','on');
        set(handles.text_DF_Isrms,'Visible','on');
        set(handles.edit_DF_Isrms,'Visible','on');
        set(handles.text_DF_Isrms_units,'Visible','on');
        set(handles.pushbutton_DF_defaultcurrent,'Visible','on');
    else    % Drive.DriveType=='Six-step' && SettingsChosen.DF_settings=='General'
        set(handles.text_DF_gamma,'Visible','off');
        set(handles.edit_DF_Gamma,'Visible','off');
        set(handles.text_DF_gamma_unit2,'Visible','off');
        set(handles.text_DF_gamma_unit1,'Visible','off');
        set(handles.text_DF_Isrms,'Visible','off');
        set(handles.edit_DF_Isrms,'Visible','off');
        set(handles.text_DF_Isrms_units,'Visible','off');
        set(handles.pushbutton_DF_defaultcurrent,'Visible','off');
    end
    if strcmp(SettingsChosen.DF_SpeedDependency,'Variable speed simulation')
        if ~disableall
            set(handles.text_DF_motorload,'Enable','on');
            set(handles.edit_DF_motorload,'Enable','on');
            set(handles.text_DF_motorloadunit,'Enable','on');
            set(handles.pushbutton_DF_motorloadprofile,'Enable','on');
        end
        set(handles.text_DF_InitSpeed,'Visible','on');
        set(handles.edit_DF_InitSpeed,'Visible','on');
        set(handles.text_DF_InitSpeedUnit,'Visible','on');
        set(handles.text_DF_Speed,'Visible','off');
        set(handles.edit_DF_Speed,'Visible','off');
        set(handles.text_DF_Speed_units,'Visible','off');
        set(handles.pushbutton_DF_defaultspeed,'Visible','off');
        set(handles.checkbox_DF_DQinitcnd,'Visible','off');
    else     % Fixed speed simulation
        set(handles.text_DF_motorload,'Enable','off');
        set(handles.edit_DF_motorload,'Enable','off');
        set(handles.text_DF_motorloadunit,'Enable','off');
        set(handles.pushbutton_DF_motorloadprofile,'Enable','off');
        set(handles.text_DF_InitSpeed,'Visible','off');
        set(handles.edit_DF_InitSpeed,'Visible','off');
        set(handles.text_DF_InitSpeedUnit,'Visible','off');
        set(handles.text_DF_Speed,'Visible','on');
        set(handles.edit_DF_Speed,'Visible','on');
        set(handles.text_DF_Speed_units,'Visible','on');
        set(handles.pushbutton_DF_defaultspeed,'Visible','on');
        set(handles.checkbox_DF_DQinitcnd,'Visible','on');
    end   
    if SettingsChosen.DF_saveeachsolution
        set(handles.text_DF_infolder,'Visible','on');
        set(handles.pup_DF_saveeachsolutionfolder,'Visible','on');
        set(handles.pushbutton_DF_chgsaveeachsolutionfolder,'Visible','on');
    else
        set(handles.text_DF_infolder,'Visible','off');
        set(handles.pup_DF_saveeachsolutionfolder,'Visible','off');
        set(handles.pushbutton_DF_chgsaveeachsolutionfolder,'Visible','off');
    end    
    if SettingsChosen.DF_ironlossmulti
        set(handles.checkbox_DF_saveeachsolution,'Enable','off');
        set(handles.text_DF_infolder,'Enable','off');
    else
        if ~disableall
            set(handles.checkbox_DF_saveeachsolution,'Enable','on');
            set(handles.text_DF_infolder,'Enable','on');
        end
    end
    if ~disableall
        set(handles.pup_DF_settings,'Enable',enablebylock);
        set(handles.edit_DF_InitSpeed,'Enable',enablebylock);
        set(handles.text_DF_InitSpeed,'Enable',enablebylock);
        set(handles.text_DF_InitSpeedUnit,'Enable',enablebylock);
        set(handles.checkbox_DF_DQinitcnd,'Enable',enablebylock);
    end
elseif get(handles.togglebutton_MS,'Value')
    Magnetostatic = Simulation.Magnetostatic;
    nPolePairs = Magnetostatic.nPolePairs;
    speed = SettingsChosen.MS_speed;
    if ~isempty(nPolePairs) && ~isempty(speed)
        f1=speed*nPolePairs/60;
        set(handles.edit_MS_f1,'String',num2str(f1));
        set(handles.edit_MS_nPolePairs,'String',num2str(nPolePairs));
    else
        set(handles.edit_MS_f1,'String','');
        set(handles.edit_MS_nPolePairs,'String','');
    end
    if SettingsChosen.MS_saveeachsolution
        set(handles.text_MS_infolder,'Visible','on');
        set(handles.pup_MS_saveeachsolutionfolder,'Visible','on');
        set(handles.pushbutton_MS_chgsaveeachsolutionfolder,'Visible','on');
    else
        set(handles.text_MS_infolder,'Visible','off');
        set(handles.pup_MS_saveeachsolutionfolder,'Visible','off');
        set(handles.pushbutton_MS_chgsaveeachsolutionfolder,'Visible','off');
    end
    if strcmp(SettingsChosen.MS_currentwaveform,'Sinusoidal')
        strlist = cell(3,1);
        strlist{1,1} = 'RMS supply current';
        strlist{2,1} = 'Peak supply current';
        strlist{3,1} = 'RMS current density';
        set(handles.pup_MS_currentinputmethod,'String',strlist);
        currentinputmethod=get(handles.pup_MS_currentinputmethod,'Value');
        if currentinputmethod==1
            textI='RMS supply current:';
            tooltip1='RMS supply current of the machine used for the finite element \nsimulation. For the star connected stator winding the supply';
            tooltip2='\ncurrent is equal to the phase current; for the delta connected stator \nwindings the supply current is equal to the phase current multiplied \nby sqrt(3).';
            set(handles.pushbutton_MS_defaultcurrent,'TooltipString','Click to setup ''RMS supply current'' to rated supply current');
            set(handles.text_MS_Iunit1,'String','A');
            set(handles.text_MS_Iunit2,'Visible','off');
            if ~disableall
                set(handles.pushbutton_MS_defaultcurrent,'Enable','on');
            end
        elseif currentinputmethod==2
            textI='Peak supply current:';
            tooltip1='Peak supply current of the machine used for the finite element \nsimulation. For the star connected stator winding the supply';
            tooltip2='\ncurrent is equal to the phase current; for the delta connected stator \nwindings the supply current is equal to the phase current multiplied \nby sqrt(3).';
            set(handles.pushbutton_MS_defaultcurrent,'Enable','off');
            set(handles.text_MS_Iunit1,'String','A');
            set(handles.text_MS_Iunit2,'Visible','off');
        elseif currentinputmethod==3
            textI='RMS current density:';
            tooltip1='RMS current density in stator slot used for the finite element simulation.';
            tooltip2=[];
            set(handles.pushbutton_MS_defaultcurrent,'Enable','off');
            set(handles.text_MS_Iunit1,'String','A/mm');
            set(handles.text_MS_Iunit2,'Visible','on');
        end
        Tooltip=sprintf([tooltip1 tooltip2]);
        set(handles.text_MS_I,'TooltipString',Tooltip);
        set(handles.edit_MS_I,'TooltipString',Tooltip);
        set(handles.text_MS_I,'String',textI);
    elseif strcmp(SettingsChosen.MS_currentwaveform,'Trapezoidal')
        strlist = cell(3,1);
        strlist{1,1} = 'RMS phase current';
        strlist{2,1} = 'DC supply current';
        strlist{3,1} = 'RMS current density';
        set(handles.pup_MS_currentinputmethod,'String',strlist);
        currentinputmethod=get(handles.pup_MS_currentinputmethod,'Value');
        if currentinputmethod==1
            textI='RMS phase current:';
            Tooltip='RMS phase current of the machine used for the finite element simulation.';
            set(handles.pushbutton_MS_defaultcurrent,'Enable','off');
            set(handles.text_MS_Iunit1,'String','A');
            set(handles.text_MS_Iunit2,'Visible','off');
        elseif currentinputmethod==2
            textI='DC supply current:';
            Tooltip='DC supply current from the inverter.';
            set(handles.pushbutton_MS_defaultcurrent,'TooltipString','Click to setup ''DC supply current'' to rated supply current');
            set(handles.text_MS_Iunit1,'String','A');
            set(handles.text_MS_Iunit2,'Visible','off');
            if ~disableall
                set(handles.pushbutton_MS_defaultcurrent,'Enable','on');
            end
        elseif currentinputmethod==3
            textI='RMS current density:';
            Tooltip='RMS current density in stator slot used for the finite element simulation.';
            set(handles.pushbutton_MS_defaultcurrent,'Enable','off');
            set(handles.text_MS_Iunit1,'String','A/mm');
            set(handles.text_MS_Iunit2,'Visible','on');
        end
        set(handles.text_MS_I,'TooltipString',Tooltip);
        set(handles.edit_MS_I,'TooltipString',Tooltip);
        set(handles.text_MS_I,'String',textI);
    end
    Results=Magnetostatic.Results;
    if isempty(Results)
        Results.speed=[]; Results.f1=[]; Results.gamma=[]; Results.torque=[]; Results.torque_reluctance=[]; Results.torque_magnet=[];
        Results.Is=[]; Results.Id=[]; Results.Iq=[]; Results.Vs=[]; Results.Vd=[]; Results.Vq=[]; Results.CurrentDensity=[]; Results.backEMF=[];
        Results.Pinput=[]; Results.Pmech=[]; Results.Ps=[]; Results.Piron=[]; Results.Piron_hyst=[]; Results.Piron_eddy=[];
        Results.PowerFactor=[]; Results.Efficiency=[]; Results.TorqueRipple=[]; Results.DemagH_max=[]; Results.DemagHpercent_max=[];
        Results.MagnetLoss=[]; Results.OtherECloss=[]; Results.Error=[];
    end
    ResultsFields = fieldnames(Results);
    for i=1:length(ResultsFields)
        ResultsField=ResultsFields{i};
        set(getfield(handles,['edit_MS_op_' ResultsField]),'String',num2str(getfield(Results,ResultsField),'%11.6g'));
        set(getfield(handles,['edit_MS_op_' ResultsField]),'TooltipString',num2str(getfield(Results,ResultsField),'%11.6g'));
    end
elseif get(handles.togglebutton_DQ,'Value')
    DQmodel=Simulation.DQmodel;
    if ~isempty(DQmodel.DQ_Ld)
        if ~isempty([strfind(Simulation.Windings.statorcircuit,'delta') strfind(Simulation.Windings.statorcircuit,'Delta')])
            DQmodel.Iphaserms=DQmodel.Iphaserms*sqrt(3);
        end
        dqmodeltext={['Maximum RMS supply current: ' num2str(DQmodel.Iphaserms(end)) ' A'];
                     ['Current step: ' num2str(DQmodel.Iphaserms(2)-DQmodel.Iphaserms(1)) ' A'];
                     ['Advance angle step: ' num2str(DQmodel.Gamma(2)-DQmodel.Gamma(1)) ' el.deg.'];
                     ['D-axis inductance array: ' num2str(length(DQmodel.Gamma)) 'x' num2str(length(DQmodel.Iphaserms)) ' values'];
                     ['Q-axis inductance array: ' num2str(length(DQmodel.Gamma)) 'x' num2str(length(DQmodel.Iphaserms)) ' values'];
                     ['Cross saturation inductance array: ' num2str(length(DQmodel.Gamma)) 'x' num2str(length(DQmodel.Iphaserms)) ' values'];
                     ['Magnet flux linkage array: ' num2str(length(DQmodel.Gamma)) 'x' num2str(length(DQmodel.Iphaserms)) ' values'];
                     ['Magnet cross saturation flux linkage array: ' num2str(length(DQmodel.Gamma)) 'x' num2str(length(DQmodel.Iphaserms)) ' values']};
        set(handles.text_dqmodel,'String',dqmodeltext);         
    else
        set(handles.text_dqmodel,'String','No D-Q model built');
    end
elseif get(handles.togglebutton_dynamicDQ,'Value')
    DynamicDQ=Simulation.DynamicDQ;
    if isempty(DynamicDQ.time)
        set(handles.text_DD_processing,'String','No simulation data');
    else
        set(handles.text_DD_processing,'String','Simulation data ready');
    end
    if strcmp(SettingsChosen.DD_StopMethod,'stop time is reached')
        set(handles.text_DD_stoptime,'Visible','on');
        set(handles.edit_DD_stoptime,'Visible','on');
        set(handles.text_DD_stoptime_units,'Visible','on');
        set(handles.text_DD_Itol,'Visible','off');
        set(handles.pup_DD_Itol,'Visible','off');
    else       % SettingsChosen.DD_StopMethod=='steady state is reached'
        set(handles.text_DD_stoptime,'Visible','off');
        set(handles.edit_DD_stoptime,'Visible','off');
        set(handles.text_DD_stoptime_units,'Visible','off');
        set(handles.text_DD_Itol,'Visible','on');
        set(handles.pup_DD_Itol,'Visible','on');        
    end
    if strcmp(Drive.DriveType,'Current hysteresis PWM') || strcmp(Drive.DriveType,'Space vector PWM') 
        set(handles.text_DD_Gamma,'Visible','on');
        set(handles.edit_DD_Gamma,'Visible','on');
        set(handles.text_DD_Gamma_units1,'Visible','on');
        set(handles.text_DD_Gamma_units2,'Visible','on');
        set(handles.text_DD_Isrms,'Visible','on');
        set(handles.edit_DD_Isrms,'Visible','on');
        set(handles.text_DD_Isrms_units,'Visible','on');
        set(handles.pushbutton_DD_defaultcurrent,'Visible','on');
        set(handles.text_DD_motorload,'Visible','off');
        set(handles.edit_DD_motorload,'Visible','off');
        set(handles.text_DD_motorload_units,'Visible','off');
        set(handles.pushbutton_DD_motorloadprofile,'Visible','off');
        set(handles.pup_DD_SpeedDependency,'Enable','off');
    else   % Drive.DriveType=='Six-step'
        set(handles.text_DD_Gamma,'Visible','off');
        set(handles.edit_DD_Gamma,'Visible','off');
        set(handles.text_DD_Gamma_units1,'Visible','off');
        set(handles.text_DD_Gamma_units2,'Visible','off');
        set(handles.text_DD_Isrms,'Visible','off');
        set(handles.edit_DD_Isrms,'Visible','off');
        set(handles.text_DD_Isrms_units,'Visible','off');
        set(handles.pushbutton_DD_defaultcurrent,'Visible','off');
        set(handles.text_DD_motorload,'Visible','on');
        set(handles.edit_DD_motorload,'Visible','on');
        set(handles.text_DD_motorload_units,'Visible','on');
        set(handles.pushbutton_DD_motorloadprofile,'Visible','on');
        if ~disableall
            set(handles.pup_DD_SpeedDependency,'Enable','on');
        end
    end
    if strcmp(SettingsChosen.DD_SpeedDependency,'Variable speed simulation')
        if ~disableall
            set(handles.text_DD_motorload,'Enable','on');
            set(handles.edit_DD_motorload,'Enable','on');
            set(handles.text_DD_motorload_units,'Enable','on');
            set(handles.pushbutton_DD_motorloadprofile,'Enable','on');
        end
        set(handles.text_DD_InitSpeed,'Visible','on');
        set(handles.edit_DD_InitSpeed,'Visible','on');
        set(handles.text_DD_InitSpeed_units,'Visible','on');
        set(handles.text_DD_Speed,'Visible','off');
        set(handles.edit_DD_Speed,'Visible','off');
        set(handles.text_DD_Speed_units,'Visible','off');
        set(handles.pushbutton_DD_defaultspeed,'Visible','off');
    else     % Fixed speed simulation
        set(handles.text_DD_motorload,'Enable','off');
        set(handles.edit_DD_motorload,'Enable','off');
        set(handles.text_DD_motorload_units,'Enable','off');
        set(handles.pushbutton_DD_motorloadprofile,'Enable','off');
        set(handles.text_DD_InitSpeed,'Visible','off');
        set(handles.edit_DD_InitSpeed,'Visible','off');
        set(handles.text_DD_InitSpeed_units,'Visible','off');
        set(handles.text_DD_Speed,'Visible','on');
        set(handles.edit_DD_Speed,'Visible','on');
        set(handles.text_DD_Speed_units,'Visible','on');
        set(handles.pushbutton_DD_defaultspeed,'Visible','on');
    end       
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton_MS_chgsaveeachsolutionfolder.
function pushbutton_chgsaveeachsolutionfolder_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MS_chgsaveeachsolutionfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
Simulation = handles.Simulation;
pushbuttontag = get(hObject,'Tag');
if strcmp(pushbuttontag,'pushbutton_MS_chgsaveeachsolutionfolder')
    SettingsMagnetostatic = Simulation.Settings.Magnetostatic;
elseif strcmp(pushbuttontag,'pushbutton_DF_chgsaveeachsolutionfolder')    
    SettingsDynamicFEA = Simulation.Settings.DynamicFEA;
end
% Allow the user to select the directory
start_path = cd;
directory_name = uigetdir(start_path,'Select a Directory');
if strfind(directory_name,cd)==1
    if length(directory_name)>length(cd)
        directory_name(1:length(cd)+1)=[];
    end
end
% If 'Cancel' was selected when return
if isequal(directory_name,0)
    return
else
    if strcmp(pushbuttontag,'pushbutton_MS_chgsaveeachsolutionfolder')
        SettingsMagnetostatic.MS_saveeachsolutionfolder = directory_name;
        Simulation.Settings.Magnetostatic = SettingsMagnetostatic;
    elseif strcmp(pushbuttontag,'pushbutton_DF_chgsaveeachsolutionfolder')    
        SettingsDynamicFEA.DF_saveeachsolutionfolder = directory_name;
        Simulation.Settings.DynamicFEA = SettingsDynamicFEA;
    end
    handles.Simulation = Simulation;
    handles.Saved = 0;
    guidata(hObject,handles);
    Update(hObject);
end


% --- Executes on button press in pushbutton_chgscript.
function pushbutton_chgscript_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_chgscript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
Simulation = handles.Simulation;
SettingsDynamicFEA = Simulation.Settings.DynamicFEA;
% Allow the user to select the script file
[filename, pathname] = uigetfile( ...
    {'*.m'}, ...
    'Select a Simulation Script File');
% If 'Cancel' was selected then return
if isequal([filename,pathname],[0,0])
    return
else
    % Construct the full path
    if strfind(pathname,cd)==1
        if length(pathname)>length(cd)
            pathname(1:length(cd)+1)=[];
        else
            pathname=[];
        end
    end
    Script = fullfile(pathname,filename);
    SettingsDynamicFEA.DF_script = Script;
    Simulation.Settings.DynamicFEA = SettingsDynamicFEA;
    handles.Simulation = Simulation;
    handles.Saved = 0;
    guidata(hObject,handles);
    Update(hObject);
end


% --- Executes on button press in pushbutton_DF_chgstatorcircuit.
function pushbutton_chgstatorcircuit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_DF_chgstatorcircuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
Simulation = handles.Simulation;
SettingsDynamicFEA = Simulation.Settings.DynamicFEA;
% Allow the user to select a stator circuit function
[filename, pathname] = uigetfile( ...
    {'*.m'}, ...
    'Select a Stator Circuit Function');
% If 'Cancel' was selected then return
if isequal([filename,pathname],[0,0])
    return
else
    [pathstr, statorcircuit, ext] = fileparts(filename);
    if ~strcmp(ext,'.m')
        errordlg('Stator Circuit Function should be a M-file','MotorAnalysis Error','modal');
        return
    end
    SettingsDynamicFEA.DF_statorcircuit = statorcircuit;
    Simulation.Settings.DynamicFEA = SettingsDynamicFEA;
    handles.Simulation = Simulation;
    handles.Saved = 0;
    guidata(hObject,handles);
    Update(hObject);
end


% --------------------------------------------------------------------
function GeometryEditor_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarGeometryEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tag = get(hObject,'Tag');
if strcmp(Tag,'menuGeometryEditor')
    Checked = get(hObject,'Checked');
    if strcmp(Checked,'on')
        set(hObject,'Checked','off');
        set(handles.GeometryEditor,'Visible','off');
        return
    end
end
set(handles.menuGeometryEditor,'Checked','on');
set(handles.GeometryEditor,'Visible','on');
GeometryEditor = handles.GeometryEditor;
GeometryEditorHandles = guidata(GeometryEditor);
% load geometry to GeometryEditor
GeometryEditorHandles.UpdateGeometryEditor(GeometryEditor);

function WindingEditor_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarWindingEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tag = get(hObject,'Tag');
if strcmp(Tag,'menuWindingEditor')
    Checked = get(hObject,'Checked');
    if strcmp(Checked,'on')
        set(hObject,'Checked','off');
        set(handles.WindingEditor,'Visible','off');
        return
    end
end
set(handles.menuWindingEditor,'Checked','on');
set(handles.WindingEditor,'Visible','on');
WindingEditor = handles.WindingEditor;
WindingEditorHandles = guidata(WindingEditor);
% load winding properties to WindingEditor
WindingEditorHandles.UpdateWindingEditor(WindingEditor,0,0);

function MeshEditor_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarMeshEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tag = get(hObject,'Tag');
if strcmp(Tag,'menuMeshEditor')
    Checked = get(hObject,'Checked');
    if strcmp(Checked,'on')
        set(hObject,'Checked','off');
        set(handles.MeshEditor,'Visible','off');
        return
    end
end
set(handles.menuMeshEditor,'Checked','on');
set(handles.MeshEditor,'Visible','on');
MeshEditor = handles.MeshEditor;
MeshEditorHandles = guidata(MeshEditor);
% load mesh to MeshEditor
MeshEditorHandles.UpdateMeshEditor(MeshEditor);

function Materials_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarMaterials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tag = get(hObject,'Tag');
if strcmp(Tag,'menuMaterials')
    Checked = get(hObject,'Checked');
    if strcmp(Checked,'on')
        set(hObject,'Checked','off');
        set(handles.MaterialsWnd,'Visible','off');
        return
    end
end
set(handles.menuMaterials,'Checked','on');
set(handles.MaterialsWnd,'Visible','on');
MaterialsWnd = handles.MaterialsWnd;
MaterialsHandles = guidata(MaterialsWnd);
% load materials to Materials window
MaterialsHandles.UpdateMaterials(MaterialsWnd);

function DriveSettings_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarDriveSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tag = get(hObject,'Tag');
if strcmp(Tag,'menuDriveSettings')
    Checked = get(hObject,'Checked');
    if strcmp(Checked,'on')
        set(hObject,'Checked','off');
        set(handles.DriveSettings,'Visible','off');
        return
    end
end
set(handles.menuDriveSettings,'Checked','on');
set(handles.DriveSettings,'Visible','on');
DriveSettings = handles.DriveSettings;
DriveSettingsHandles = guidata(DriveSettings);
% load drive properties to DriveSettings
DriveSettingsHandles.UpdateDriveSettings(DriveSettings);

function RatedData_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarRatedData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tag = get(hObject,'Tag');
if strcmp(Tag,'menuRatedData')
    Checked = get(hObject,'Checked');
    if strcmp(Checked,'on')
        set(hObject,'Checked','off');
        set(handles.RatedData,'Visible','off');
        return
    end
end
set(handles.menuRatedData,'Checked','on');
set(handles.RatedData,'Visible','on');
RatedData = handles.RatedData;
RatedDataHandles = guidata(RatedData);
% load rated data to RatedData
RatedDataHandles.UpdateRatedData(RatedData);

function PlotWizard_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarPlotWizard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tag = get(hObject,'Tag');
if strcmp(Tag,'menuPlotWizard')
    Checked = get(hObject,'Checked');
    if strcmp(Checked,'on')
        set(hObject,'Checked','off');
        set(handles.PlotWizard,'Visible','off');
        return
    end
end
set(handles.menuPlotWizard,'Checked','on');
PlotWizard = handles.PlotWizard;
PlotWizardHandles = guidata(PlotWizard);
set(handles.PlotWizard,'Visible','on');


% --------------------------------------------------------------------
function OpenSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to OpenSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h_taq=findobj('type','figure','Tag','timeaveragedquantities');
if ~isempty(h_taq)
    close(h_taq);
end
PlotWizard = handles.PlotWizard;
PlotWizardHandles = guidata(PlotWizard);
PlotWizardHandles.SavePlotWizardProfile(PlotWizardHandles);
if ~handles.Saved
    File = handles.File;
    if isempty(File)
        File = 'the current simulation';
    end
    button = questdlg(['Save changes to ' File '?'],'MotorAnalysis');
    if strcmp(button,'No') 
        % no action
    elseif strcmp(button,'Yes')
        Save_Callback(handles.menuSave, [], handles);
        return
    else
        return
    end
end

% Allow for the selection of a simulation file.
cd_old=cd;
if exist('SimFiles','dir')
    cd('SimFiles');
end
[filename, pathname] = uigetfile( ...
    {'*.mat', 'All MAT-Files (*.mat)'; ...
        '*.*','All Files (*.*)'}, ...
     'Select a Simulation File');
cd(cd_old);
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file.
else
    Tag = get(hObject,'Tag');
    if strcmp(Tag,'menuOpenSimulation') || strcmp(Tag,'toolbarOpenSimulation')
        Tag = 'OpenSimulation';
    end
    File = fullfile(pathname,filename);
    
    convert=0;
    set(handles.motoranalysis,'Pointer','watch'); drawnow;
    while 1
        handles.Saved = 1;
        guidata(hObject,handles);
        pass=LoadSimulation(File,handles,Tag,convert);
        if pass==1   % simulation file is correct
            handles = guidata(hObject);
            if strcmp(Tag,'OpenAsNewSimulation')
                handles.Saved = 0;
                File = [];
                filename = [];
            end
            handles.File = File;
            SimulationSelected = ['MotorAnalysis-PM - ' File];
            set(handles.motoranalysis,'Name',SimulationSelected);
            set(handles.edit_simfilename,'String',filename);
            guidata(hObject,handles);
            break;
        elseif pass==2 && strcmp(Tag,'OpenAsNewSimulation')    % simulation file needs to be converted
            convert=1;
        elseif pass==2
            msgbox({'Obsolete simulation file format.';
                    'Only ''Open As a New (Empty) Simulation'' option is allowed.'},'modal');
            break;
        else   % simulation file is not correct
            errordlg('Not a valid Simulation File.','Open Simulation Error','modal');
            break;
        end
    end
    set(handles.motoranalysis,'Pointer','arrow');
end

% --- 
function pass = LoadSimulation(file,handles,Tag,convert)
% Initialize the variable "pass" to determine if this is a valid file.
pass = 0;
% if the file exists then load it.
if exist(file,'file') == 2
    data = load(file);
else
    return
end

% Validate the MAT-file
Simulation = CreateSimulation();
% check fields
if isfield(data,'Simulation')
    data = data.Simulation;
    if (isfield(data,'Geometry')) && (isfield(data,'Mesh')) && (isfield(data,'Windings')) && (isfield(data,'Materials')) && ...
       (isfield(data,'Settings')) && (isfield(data,'Private')) && (isfield(data,'Userdata')) && (isfield(data,'DXFrotor')) && ...
       (isfield(data,'DXFstator')) && (isfield(data,'Magnetostatic')) && (isfield(data,'DQmodel')) && (isfield(data,'DynamicFEA')) && ...
       (isfield(data,'DynamicDQ')) && (isfield(data,'EfficiencyMap')) && (isfield(data,'Drive')) && (isfield(data,'RatedData'))
        % load Geometry
        Geometry = Simulation.Geometry;
        dataGeometry = data.Geometry;
        GeometryFields = fieldnames(Geometry);
        for i=1:length(GeometryFields)
            if isfield(dataGeometry,GeometryFields{i})
                Geometry = setfield(Geometry,GeometryFields{i},getfield(dataGeometry,GeometryFields{i}));
            elseif convert
                 % no action, default field values are used
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
        end
        % load Windings
        Windings = Simulation.Windings;
        dataWindings = data.Windings;
        WindingsFields = fieldnames(Windings);
        for i=1:length(WindingsFields)
            if isfield(dataWindings,WindingsFields{i})
                Windings = setfield(Windings,WindingsFields{i},getfield(dataWindings,WindingsFields{i}));
            elseif convert
                 % no action, default field values are used
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
        end
        % load Mesh
        Mesh = Simulation.Mesh;
        dataMesh = data.Mesh;
        MeshFields = fieldnames(Mesh);
        for i=1:length(MeshFields)
            if isfield(dataMesh,MeshFields{i})
                Mesh = setfield(Mesh,MeshFields{i},getfield(dataMesh,MeshFields{i}));
                if strcmp(Tag,'OpenAsNewSimulation')
                    if strcmp(MeshFields{i},'p') || strcmp(MeshFields{i},'t') || strcmp(MeshFields{i},'e') || strcmp(MeshFields{i},'b') || strcmp(MeshFields{i},'Rotate')
                        Mesh = setfield(Mesh,MeshFields{i},[]);
                    end
                end
            elseif convert
                % no action, default field values are used
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
        end
        % load Materials
        Materials = Simulation.Materials;
        dataMaterials = data.Materials;
        MaterialsFields = fieldnames(Materials);
        for i=1:length(MaterialsFields)
            if isfield(dataMaterials,MaterialsFields{i})
                Materials = setfield(Materials,MaterialsFields{i},getfield(dataMaterials,MaterialsFields{i}));
            elseif convert
                 % no action, default field values are used
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
        end
        % load Drive
        Drive = Simulation.Drive;
        dataDrive = data.Drive;
        DriveFields = fieldnames(Drive);
        for i=1:length(DriveFields)
            if isfield(dataDrive,DriveFields{i})
                Drive = setfield(Drive,DriveFields{i},getfield(dataDrive,DriveFields{i}));
            elseif convert
                 % no action, default field values are used
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
        end        
        % load RatedData
        RatedData = Simulation.RatedData;
        dataRatedData = data.RatedData;
        RatedDataFields = fieldnames(RatedData);
        for i=1:length(RatedDataFields)
            if isfield(dataRatedData,RatedDataFields{i})
                RatedData = setfield(RatedData,RatedDataFields{i},getfield(dataRatedData,RatedDataFields{i}));
            elseif convert
                 % no action, default field values are used
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
        end        
        % load Magnetostatic
        Magnetostatic = Simulation.Magnetostatic;
        if strcmp(Tag,'OpenSimulation')
            if isfield(data,'Magnetostatic')
                % do nothing
            elseif ~isfield(data,'Magnetostatic') && convert  % convert simulation file
                data.Magnetostatic=[];
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
            dataMagnetostatic = data.Magnetostatic;
            MagnetostaticFields = fieldnames(Magnetostatic);
            for i=1:length(MagnetostaticFields)
                if isfield(dataMagnetostatic,MagnetostaticFields{i})
                    Magnetostatic = setfield(Magnetostatic,MagnetostaticFields{i},getfield(dataMagnetostatic,MagnetostaticFields{i}));
                elseif convert
                    % keep default value
                else
                    pass = 2;    % simulation file needs to be converted
                    return
                end
            end
        end
        % load DQmodel
        DQmodel = Simulation.DQmodel;
        if strcmp(Tag,'OpenSimulation')
            if isfield(data,'DQmodel')
                % do nothing
            elseif ~isfield(data,'DQmodel') && convert  % convert simulation file
                data.DQmodel=[];
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
            dataDQmodel = data.DQmodel;
            DQmodelFields = fieldnames(DQmodel);
            for i=1:length(DQmodelFields)
                if isfield(dataDQmodel,DQmodelFields{i})
                    DQmodel = setfield(DQmodel,DQmodelFields{i},getfield(dataDQmodel,DQmodelFields{i}));
                elseif convert
                    % keep default value
                else
                    pass = 2;    % simulation file needs to be converted
                    return
                end
            end
        end
        % load DynamicFEA
        DynamicFEA = Simulation.DynamicFEA;
        if strcmp(Tag,'OpenSimulation')
            if isfield(data,'DynamicFEA')
                % do nothing
            elseif ~isfield(data,'DynamicFEA') && convert  % convert simulation file
                data.DynamicFEA=[];
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
            dataDynamicFEA = data.DynamicFEA;
            DynamicFEAFields = fieldnames(DynamicFEA);
            for i=1:length(DynamicFEAFields)
                if isfield(dataDynamicFEA,DynamicFEAFields{i})
                    DynamicFEA = setfield(DynamicFEA,DynamicFEAFields{i},getfield(dataDynamicFEA,DynamicFEAFields{i}));
                elseif convert
                    % keep default value
                else
                    pass = 2;    % simulation file needs to be converted
                    return
                end
            end
        end
        % load DynamicDQ
        DynamicDQ = Simulation.DynamicDQ;
        if strcmp(Tag,'OpenSimulation')
            if isfield(data,'DynamicDQ')
                % do nothing
            elseif ~isfield(data,'DynamicDQ') && convert  % convert simulation file
                data.DynamicDQ=[];
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
            dataDynamicDQ = data.DynamicDQ;
            DynamicDQFields = fieldnames(DynamicDQ);
            for i=1:length(DynamicDQFields)
                if isfield(dataDynamicDQ,DynamicDQFields{i})
                    DynamicDQ = setfield(DynamicDQ,DynamicDQFields{i},getfield(dataDynamicDQ,DynamicDQFields{i}));
                elseif convert
                    % keep default value
                else
                    pass = 2;    % simulation file needs to be converted
                    return
                end
            end
        end
        % load Private
        if strcmp(Tag,'OpenSimulation')
            Private = data.Private;
        else
            Private = [];
        end
        % load Userdata
        if strcmp(Tag,'OpenSimulation')
            Userdata = data.Userdata;
        else
            Userdata = [];
        end        
        % load EfficiencyMap
        if strcmp(Tag,'OpenSimulation')
            EfficiencyMap = data.EfficiencyMap;
        else
            EfficiencyMap = [];
        end 
        % load DXFrotor
        DXFrotor = data.DXFrotor;
        % load DXFstator
        DXFstator = data.DXFstator;        
        % load Settings
        Settings = Simulation.Settings;
        SettingsMagnetostatic = Settings.Magnetostatic;
        SettingsDQ = Settings.DQ;
        SettingsDynamicFEA = Settings.DynamicFEA;
        SettingsDynamicDQ = Settings.DynamicDQ;
        dataSettings = data.Settings;
        % Settings.Magnetostatic
        dataSettingsMagnetostatic = dataSettings.Magnetostatic;
        SettingsMagnetostaticFields = fieldnames(SettingsMagnetostatic);
        for i=1:length(SettingsMagnetostaticFields)
            if isfield(dataSettingsMagnetostatic,SettingsMagnetostaticFields{i})
                SettingsMagnetostatic = setfield(SettingsMagnetostatic,SettingsMagnetostaticFields{i},getfield(dataSettingsMagnetostatic,SettingsMagnetostaticFields{i}));
            elseif convert
                if strcmp(SettingsMagnetostaticFields{i},'MS_currentinputmethod')
                    if isfield(dataSettingsMagnetostatic,'MS_currentwaveform')
                        if strcmp(dataSettingsMagnetostatic.MS_currentwaveform,'Trapezoidal')
                            SettingsMagnetostatic.MS_currentinputmethod='RMS phase current';
                        end
                    end
                end
                % keep default value
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
        end
        Settings.Magnetostatic=SettingsMagnetostatic;
        % Settings.DQ
        dataSettingsDQ = dataSettings.DQ;
        SettingsDQFields = fieldnames(SettingsDQ);
        for i=1:length(SettingsDQFields)
            if isfield(dataSettingsDQ,SettingsDQFields{i})
                SettingsDQ = setfield(SettingsDQ,SettingsDQFields{i},getfield(dataSettingsDQ,SettingsDQFields{i}));
            elseif convert
                % keep default value
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
        end
        Settings.DQ=SettingsDQ;
        % Settings.DynamicFEA
        dataSettingsDynamicFEA = dataSettings.DynamicFEA;
        SettingsDynamicFEAFields = fieldnames(SettingsDynamicFEA);
        for i=1:length(SettingsDynamicFEAFields)
            if isfield(dataSettingsDynamicFEA,SettingsDynamicFEAFields{i})
                SettingsDynamicFEA = setfield(SettingsDynamicFEA,SettingsDynamicFEAFields{i},getfield(dataSettingsDynamicFEA,SettingsDynamicFEAFields{i}));
            elseif convert
                % keep default value
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
        end
        if strcmp(Tag,'OpenAsNewSimulation')
            if strcmp(SettingsDynamicFEA.DF_settings,'General')
                if strcmp(Drive.DriveType,'Current hysteresis PWM')
                    SettingsDynamicFEA.DF_script = 'simscript_hystpwm.m';
                elseif strcmp(Drive.DriveType,'Space vector PWM')
                    SettingsDynamicFEA.DF_script = 'simscript_spacevecpwm.m';
                elseif strcmp(Drive.DriveType,'Six-step')
                    SettingsDynamicFEA.DF_script = 'simscript_sixstep.m';
                else
                    error('Undefined drive type')
                end
                SettingsDynamicFEA.DF_statorcircuit = 'InverterCircuit';
            end
        end
        Settings.DynamicFEA=SettingsDynamicFEA;
        % Settings.DynamicDQ
        dataSettingsDynamicDQ = dataSettings.DynamicDQ;
        SettingsDynamicDQFields = fieldnames(SettingsDynamicDQ);
        for i=1:length(SettingsDynamicDQFields)
            if isfield(dataSettingsDynamicDQ,SettingsDynamicDQFields{i})
                SettingsDynamicDQ = setfield(SettingsDynamicDQ,SettingsDynamicDQFields{i},getfield(dataSettingsDynamicDQ,SettingsDynamicDQFields{i}));
            elseif convert
                % keep default value
            else
                pass = 2;    % simulation file needs to be converted
                return
            end
        end
        Settings.DynamicDQ=SettingsDynamicDQ;    
        pass = 1;
    else
        return
    end
else
    return
end
if pass
    Simulation.Geometry = Geometry;
    Simulation.Windings = Windings;
    Simulation.Mesh = Mesh;
    Simulation.Materials = Materials;
    Simulation.Drive = Drive;
    Simulation.RatedData = RatedData;
    Simulation.Settings = Settings;
    Simulation.Private = Private;
    Simulation.Userdata = Userdata;
    Simulation.DXFrotor = DXFrotor;
    Simulation.DXFstator = DXFstator;
    Simulation.Magnetostatic = Magnetostatic;
    Simulation.DQmodel = DQmodel;
    Simulation.DynamicFEA = DynamicFEA;
    Simulation.DynamicDQ = DynamicDQ;
    Simulation.EfficiencyMap = EfficiencyMap;
    
    handles.Simulation = Simulation;
    guidata(handles.motoranalysis,handles);
    
    GeometryEditor = handles.GeometryEditor;
    GeometryEditorHandles = guidata(GeometryEditor);
    % load geometry to Geometry Editor
    GeometryEditorHandles.UpdateGeometryEditor(GeometryEditor);
    
    WindingEditor = handles.WindingEditor;
    WindingEditorHandles = guidata(WindingEditor);    
    % load winding properties to Winding Editor
    WindingEditorHandles.UpdateWindingEditor(WindingEditor,1,1);
    
    MeshEditor = handles.MeshEditor;
    MeshEditorHandles = guidata(MeshEditor);    
    % load mesh to Mesh Editor
    MeshEditorHandles.UpdateMeshEditor(MeshEditor);    
    
    MaterialsWnd = handles.MaterialsWnd;
    MaterialsHandles = guidata(MaterialsWnd);    
    % load materials to Materials window
    MaterialsHandles.UpdateMaterials(MaterialsWnd);   
    
    DriveSettings = handles.DriveSettings;
    DriveSettingsHandles = guidata(DriveSettings);    
    % load drive settings to Drive Settings window
    DriveSettingsHandles.UpdateDriveSettings(DriveSettings);       
    
    RatedData = handles.RatedData;
    RatedDataHandles = guidata(RatedData);    
    % load rated data to Rated Data window
    RatedDataHandles.UpdateRatedData(RatedData);
     
    IronLossCalculator = handles.IronLossCalculator;
    IronLossCalculatorHandles = guidata(IronLossCalculator); 
    if isempty(DynamicFEA.time)
        currenttime=0;
    else
        currenttime=DynamicFEA.time(end)-DynamicFEA.time(1);
    end
    IronLossCalculatorHandles.setupironlosscalc(IronLossCalculatorHandles,currenttime,Settings.DynamicFEA.DF_saveeachsolutionfolder)

    % Update PlotWizard
    PlotWizard = handles.PlotWizard;
    PlotWizardHandles = guidata(PlotWizard);
    PlotWizardHandles.UpdatePlotWizard(PlotWizard,file);
    
    % update main window
    Update(handles.motoranalysis,1);
end

% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
set(handles.motoranalysis,'Pointer','watch'); drawnow;
% Get the Tag of the menu selected
Tag = get(hObject,'Tag');
if strcmp(Tag,'menuSave') || strcmp(Tag,'toolbarSave')
    Tag = 'Save';
end
Simulation = handles.Simulation;
File = handles.File;
if isempty(File)
    Tag = 'SaveAs';   % take 'Save_As' action if the file name is not specified
end
% Based on the item selected, take the appropriate action
switch Tag
case 'Save'
    save(File,'Simulation');
    handles.Saved = 1;
    guidata(hObject,handles);
case 'SaveAs'
    % Allow the user to select the file name to menusave to
    cd_old=cd;
    if exist('SimFiles','dir')
        cd('SimFiles');
    end
    [filename, pathname] = uiputfile( ...
        {'*.mat';'*.*'}, ...
        'Save as');
    cd(cd_old);
    % If 'Cancel' was selected then return
    if isequal([filename,pathname],[0,0])
        set(handles.motoranalysis,'Pointer','arrow');
        return
    else
        % Construct the full path and menusave
        File = fullfile(pathname,filename);
        Simulation.Settings.Magnetostatic.MS_saveeachsolutionfolder=['SimFiles\' filename(1:end-4) '_MSdata'];
        Simulation.Settings.DynamicFEA.DF_saveeachsolutionfolder=['SimFiles\' filename(1:end-4) '_dynFEdata'];
        handles.Simulation=Simulation;
        save(File,'Simulation');
        handles.File = File;
        handles.Saved = 1;
        SimulationSelected = ['MotorAnalysis-PM - ' File];
        set(handles.motoranalysis,'Name',SimulationSelected);
        set(handles.edit_simfilename,'String',filename);
        guidata(hObject,handles);
        Update(hObject);
    end
end
PlotWizard = handles.PlotWizard;
PlotWizardHandles = guidata(PlotWizard);
PlotWizardHandles.SavePlotWizardProfile(PlotWizardHandles);
set(handles.motoranalysis,'Pointer','arrow');
  

function ok = startanalysis(analysistype,hObject,handles)
ok=0;
if isempty(handles.File)
    errordlg('No simulation file opened.','Start Simulation Error','modal');
    return;
end
handles.StopSimulation=0;
handles.disableall=1;
guidata(hObject,handles);
set(handles.motoranalysis,'Pointer','watch');drawnow;
set(handles.toolbarRunSimulation,'Enable','off');
set(handles.toolbarSave,'Enable','off');
set(handles.toolbarOpenSimulation,'Enable','off');
set(handles.toolbarUnlock,'Enable','off');
set(handles.toolbarRatedData,'Enable','off');
set(handles.toolbarGeometryEditor,'Enable','off');
set(handles.toolbarWindingEditor,'Enable','off');
set(handles.toolbarMaterials,'Enable','off');
set(handles.toolbarMeshEditor,'Enable','off');
set(handles.toolbarDriveSettings,'Enable','off');
set(handles.toolbarPlotWizard,'Enable','off');
set(handles.toolbarTimeAveragedQuantities,'Enable','off');
set(handles.menu_File,'Enable','off');
set(handles.menu_Desktop,'Enable','off');
set(handles.menu_About,'Enable','off');
set(handles.menu_Help,'Enable','off');
set(handles.togglebutton_MS,'Enable','off');
set(handles.togglebutton_DQ,'Enable','off');
set(handles.togglebutton_dynamicFEA,'Enable','off');
set(handles.togglebutton_dynamicDQ,'Enable','off');
set(handles.GeometryEditor,'Visible','off');
set(handles.menuGeometryEditor,'Checked','off');
set(handles.WindingEditor,'Visible','off');
set(handles.menuWindingEditor,'Checked','off');
set(handles.MaterialsWnd,'Visible','off');
set(handles.menuMaterials,'Checked','off');
set(handles.MeshEditor,'Visible','off');
set(handles.menuMeshEditor,'Checked','off');
set(handles.DriveSettings,'Visible','off');
set(handles.menuDriveSettings,'Checked','off');
set(handles.RatedData,'Visible','off');
set(handles.menuRatedData,'Checked','off');
set(handles.PlotWizard,'Visible','off');
set(handles.menuPlotWizard,'Checked','off');
drawnow;
Simulation = handles.Simulation;
if isempty(Simulation.Private)
    Geometry=Simulation.Geometry; Mesh=Simulation.Mesh; Windings=Simulation.Windings;
    Ns=Geometry.Ns; nAirGapLayers=Mesh.nAirGapLayers; AirGapSlidingLayer = round(nAirGapLayers/2);
    nSlotLayers=1;
    if strcmp(Geometry.slotlayertype,'Double layer')
        nSlotLayers=2;
    end
    DXFrotor = Simulation.DXFrotor;
    DXFstator = Simulation.DXFstator;
    dxfstator=Geometry.dxfstator;
    if isfield(DXFrotor,'geometry')
        RotorGeometry = DXFrotor.geometry;
    else
        errordlg('No rotor geometry found.','Start Simulation Error','modal');
        return
    end
    StatorGeometry = [];
    if isfield(DXFstator,'geometry')
        StatorGeometry = DXFstator.geometry;
    elseif dxfstator
        errordlg('No stator geometry found.','Start Simulation Error','modal');
        return
    end
    [nper, periodicity] = VerifyPerBndCnd(Ns,Mesh.nPolePairs,Mesh.perbndcnd);
    if isempty(nper), return; end
    [geom, ~, ~, lag]=initgeom(Geometry,RotorGeometry,StatorGeometry,Mesh,[],dxfstator);
    [p,e,t]=createmesh(geom,Geometry,lag,Mesh.nAirGapLayers,Mesh.agmeshqlt,Mesh.Hgrad);
    [p,t,e,b,Rotate]=replicatemesh(p,e,t,Geometry,lag,nAirGapLayers,AirGapSlidingLayer,nSlotLayers,nper,periodicity,Geometry.dxfstator,DXFstator);   
    meshok=0;
    if size(p)==size(Mesh.p)
        if ~nnz(p-Mesh.p)
             if size(t)==size(Mesh.t)
                  if ~nnz(t-Mesh.t)
                      if size(e)==size(Mesh.e)
                           if ~nnz(e-Mesh.e)
                              if size(b)==size(Mesh.b)
                                   if ~nnz(b-Mesh.b)                           
                                       meshok=1;
                                   end
                              end
                           end
                      end
                  end
             end
        end
    end
    if ~meshok
        button = questdlg('Mesh has not been generated. Generate mesh and run simulation?',...
                          'MotorAnalysis','Yes','No','No');
        if strcmp(button,'No') 
            return
        end
        handles.Saved = 0;
    end
    Mesh.p = p;
    Mesh.t = t;
    Mesh.e = e;
    Mesh.b = b;
    Mesh.Rotate = Rotate;
    Simulation.Mesh = Mesh;
    handles.Simulation = Simulation;
    guidata(hObject,handles);
end
% save data before run simulation
Save_Callback(handles.menuSave, [], handles);
handles = guidata(hObject);
if ~handles.Saved
    return
end
set(handles.motoranalysis,'Pointer','watch');
Update(hObject);
drawnow;
ok=1;


function finishanalysis(analysistype,handles)
if strcmp(analysistype,'DQ')
    set(handles.toolbarRunSimulation,'Enable','off');
    set(handles.toolbarStopSimulation,'Enable','off');
else           % 'MS' | 'DFE' | 'DDQ'
    set(handles.toolbarRunSimulation,'Enable','on');
    set(handles.toolbarStopSimulation,'Enable','on');
end
if strcmp(analysistype,'DFE') || strcmp(analysistype,'DDQ')
    set(handles.toolbarTimeAveragedQuantities,'Enable','on');
end
set(handles.toolbarSave,'Enable','on');
set(handles.toolbarOpenSimulation,'Enable','on');
set(handles.toolbarUnlock,'Enable','on');
set(handles.toolbarRatedData,'Enable','on');
set(handles.toolbarGeometryEditor,'Enable','on');
set(handles.toolbarWindingEditor,'Enable','on');
set(handles.toolbarMaterials,'Enable','on');
set(handles.toolbarMeshEditor,'Enable','on');
set(handles.toolbarDriveSettings,'Enable','on');
set(handles.toolbarPlotWizard,'Enable','on');
set(handles.menu_File,'Enable','on');
set(handles.menu_Desktop,'Enable','on');
set(handles.menu_About,'Enable','on');
set(handles.menu_Help,'Enable','on');
set(handles.togglebutton_MS,'Enable','on');
set(handles.togglebutton_DQ,'Enable','on');
set(handles.togglebutton_dynamicFEA,'Enable','on');
set(handles.togglebutton_dynamicDQ,'Enable','on');
set(handles.motoranalysis,'Pointer','arrow');
handles.disableall=0;
guidata(handles.motoranalysis,handles);
Update(handles.motoranalysis);


% --------------------------------------------------------------------
function toolbarRunSimulation_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarRunSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
h_taq=findobj('type','figure','Tag','timeaveragedquantities');
if ~isempty(h_taq)
    close(h_taq);
end
if get(handles.togglebutton_dynamicFEA,'Value');
    if startanalysis('DFE',hObject,handles)
        disp(['Chosen file' blanks(1) handles.File]);
        runsimulation(handles.File,handles.motoranalysis);
        % load simulation file
        handles.Simulation = CreateSimulation();
        guidata(hObject,handles);
        if ~LoadSimulation(handles.File,handles,'OpenSimulation',0)
            error('Failed to load simulation file');
        end
        handles = guidata(hObject);
    end
    finishanalysis('DFE',handles);
elseif get(handles.togglebutton_MS,'Value')
    if startanalysis('MS',hObject,handles)
        handles = guidata(hObject);    % update handles after calling startanalysis
        Simulation = handles.Simulation;
        ticid=tic;
        [Simulation, stopped] = runMStimestepping(Simulation,handles);
        if ~stopped
            handles = guidata(handles.motoranalysis);
            handles.Simulation = Simulation;
            guidata(hObject,handles);
            Save_Callback(handles.menuSave, [], handles);
            strtime=time2str(toc(ticid));
            disp(['Simulation completed in ' strtime]);
        else
            disp('Simulation canceled');
        end
        Update(hObject);
        drawnow;
    end
    finishanalysis('MS',handles);
elseif get(handles.togglebutton_dynamicDQ,'Value')
    if startanalysis('DDQ',hObject,handles)
        handles = guidata(hObject);    % update handles after calling startanalysis
        Simulation = handles.Simulation;
        ticid=tic;
        [Simulation, stopped] = runDynDQ(Simulation,handles);
        if ~stopped
            handles = guidata(handles.motoranalysis);
            handles.Simulation = Simulation;
            guidata(hObject,handles);
            Save_Callback(handles.menuSave, [], handles);
            strtime=time2str(toc(ticid));
            disp(['Simulation completed in ' strtime]);
        else
            disp('Simulation canceled');
        end
        Update(hObject);
        drawnow;
    end
    finishanalysis('DDQ',handles);    
end


%%% D-Q Analysis
% --- Executes on button press in pushbutton_buildDQmodel.
function pushbutton_buildDQmodel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_buildDQmodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if strcmp(get(handles.pushbutton_buildDQmodel,'String'),'Build D-Q model *')
    if startanalysis('DQ',hObject,handles)
        handles = guidata(hObject);    % update handles after calling startanalysis
        Simulation = handles.Simulation;
        ok=1;
        if ~isempty(Simulation.DQmodel.DQ_Ld)
            button = questdlg('D-Q model previously built will be deleted. Continue?',...
                                  'MotorAnalysis','Yes','No','No');
            if strcmp(button,'No') 
                ok=0;
            end
        end
        if ok    
            set(handles.pushbutton_buildDQmodel,'String','Stop');
            ticid=tic;
            [Simulation, stopped] = BuildDQmodel(Simulation,handles);
            if ~stopped
                handles = guidata(handles.motoranalysis);
                handles.Simulation = Simulation;
                guidata(hObject,handles);
                Save_Callback(handles.menuSave, [], handles);
                strtime=time2str(toc(ticid));
                disp(['Operation completed in ' strtime])
            else
                disp('Operation canceled')
            end
            set(handles.pushbutton_buildDQmodel,'String','Build D-Q model *');
            Update(hObject);
            pause(0.0001);
        end
    end
    finishanalysis('DQ',handles);
elseif strcmp(get(handles.pushbutton_buildDQmodel,'String'),'Stop')
    button = questdlg('All simulation data of current D-Q model will be lost. Stop operation?',...
        'D-Q Analysis','Yes','No','No');
    if strcmp(button,'No')
        return;
    end
    handles.StopSimulation=1;
    guidata(hObject,handles);
end


function strtime = time2str(time)
% dd:hh:mm:ss
dd=floor(time/(24*60*60));
time=rem(time,(24*60*60));
hh=floor(time/(60*60));
time=rem(time,(60*60));
mm=floor(time/60);
time=rem(time,60);
ss=floor(time);
strtime='';
if dd
    strtime=[strtime num2str(dd) ' days, '];
end
if hh
    strtime=[strtime num2str(hh) ' hours, '];
else
    if ~isempty(strtime)
        strtime=[strtime '0 hours.'];
    end
end
if mm
    strtime=[strtime num2str(mm) ' minutes, '];
else
    if ~isempty(strtime)
        strtime=[strtime '0 minutes.'];
    end
end
if ss
    strtime=[strtime num2str(ss) ' seconds.'];
else
    if ~isempty(strtime)
        strtime=[strtime '0 seconds.'];
    end
end
if isempty(strtime)
    strtime=[num2str(time) ' seconds.'];
end


% --------------------------------------------------------------------
function toolbarStopSimulation_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarStopSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.StopSimulation = 1;
guidata(hObject,handles);


% --------------------------------------------------------------------
function toolbarTimeAveragedQuantities_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarTimeAveragedQuantities (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Simulation = handles.Simulation;
if get(handles.togglebutton_dynamicDQ,'Value')          % dynamic D-Q analysis
    results=Simulation.DynamicDQ;
elseif get(handles.togglebutton_dynamicFEA,'Value')     % dynamic FE analysis 
    results=Simulation.DynamicFEA;
    results.motoranalysis=handles.motoranalysis;
else
    return
end 
timeaveragedquantities('results',results);


% --- Executes on button press in pushbutton_DD_motorloadprofile.
function pushbutton_motorloadprofile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_DD_motorloadprofile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Tag = get(hObject,'Tag');
Simulation = handles.Simulation;
if strcmp(Tag,'pushbutton_DD_motorloadprofile')             % dynamic D-Q analysis
    loadprofile=Simulation.Settings.DynamicDQ.DD_motorload;
elseif strcmp(Tag,'edit_DD_motorload')                      % dynamic D-Q analysis
    loadprofile=Simulation.Settings.DynamicDQ.DD_motorload;        
    if ~iscell(loadprofile)
        return
    end
elseif strcmp(Tag,'pushbutton_DF_motorloadprofile')         % dynamic FE analysis 
    loadprofile=Simulation.Settings.DynamicFEA.DF_motorload;
elseif strcmp(Tag,'edit_DF_motorload')                      % dynamic FE analysis 
    loadprofile=Simulation.Settings.DynamicFEA.DF_motorload;
    if ~iscell(loadprofile)
        return
    end
end 
newloadprofile=motorloadprofile('LoadPrfl',loadprofile);
if ~isempty(newloadprofile)
    saved = 0;
    if ~iscell(newloadprofile) && ~iscell(loadprofile)
        if newloadprofile==loadprofile
            saved = 1;
        end
    end
    if strcmp(Tag,'pushbutton_DD_motorloadprofile') || strcmp(Tag,'edit_DD_motorload')    % dynamic D-Q analysis
        Simulation.Settings.DynamicDQ.DD_motorload=newloadprofile;
    elseif strcmp(Tag,'pushbutton_DF_motorloadprofile') || strcmp(Tag,'edit_DF_motorload')     % dynamic FE analysis 
        Simulation.Settings.DynamicFEA.DF_motorload=newloadprofile;
    end
    handles.Simulation = Simulation;
    handles.Saved = saved;
    guidata(hObject,handles);
    Update(hObject);
end


% --- Executes on button press in pushbutton_ironlosscalculator.
function pushbutton_ironlosscalculator_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ironlosscalculator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.IronLossCalculator,'Visible','on');


% --------------------------------------------------------------------
function menuAbout_Callback(hObject, eventdata, handles)
% hObject    handle to menuAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = msgbox({'MotorAnalysis-PM 1.1','Apr 2 2018 ',' ','Vladimir Kuptsov','2v.kuptsov@gmail.com',...
         'www.motoranalysis.com',' ','VEPCO Technologies, Inc.','www.vepcotech.com',' ','Copyright (C) 2008-2018'},'About MotorAnalysis','modal');
    %' ','www.motoranalysis.com                                           .',...
% rect = get(h,'Position');
% %rect = [left, bottom, width, height]
% rect(1) = rect(1)-rect(3)/2;
% rect(3) = 2*rect(3);
% set(h,'Position',rect);

% --------------------------------------------------------------------
function togglebutton_AnalysisType_Callback(hObject, eventdata, handles)

h_taq=findobj('type','figure','Tag','timeaveragedquantities');
if ~isempty(h_taq)
    close(h_taq);
end
Tag = get(hObject,'Tag');
if strcmp(Tag,'togglebutton_MS')
    set(handles.togglebutton_MS,'Value',1);
    set(handles.togglebutton_DQ,'Value',0);
    set(handles.togglebutton_dynamicFEA,'Value',0);
    set(handles.togglebutton_dynamicDQ,'Value',0);
    set(handles.panel_MS,'Visible','on');
    set(handles.panel_DQ,'Visible','off');
    set(handles.panel_dynamicFEA,'Visible','off');
    set(handles.panel_dynamicDQ,'Visible','off');
    set(handles.toolbarRunSimulation,'Enable','on');
    set(handles.toolbarStopSimulation,'Enable','on');
    set(handles.toolbarTimeAveragedQuantities,'Enable','off');
    load('stopicon.mat','stopicon');
    set(handles.toolbarStopSimulation,'CData',stopicon);
    set(handles.toolbarStopSimulation,'TooltipString','Stop simulation');
    set(handles.toolbarRunSimulation,'TooltipString','Start magnetostatic simulation');
    set(handles.IronLossCalculator,'Visible','off');
elseif strcmp(Tag,'togglebutton_DQ')
    set(handles.togglebutton_MS,'Value',0);
    set(handles.togglebutton_DQ,'Value',1);
    set(handles.togglebutton_dynamicFEA,'Value',0);
    set(handles.togglebutton_dynamicDQ,'Value',0);
    set(handles.panel_MS,'Visible','off');
    set(handles.panel_DQ,'Visible','on');
    set(handles.panel_dynamicFEA,'Visible','off');
    set(handles.panel_dynamicDQ,'Visible','off');
    set(handles.toolbarRunSimulation,'Enable','off');
    set(handles.toolbarStopSimulation,'Enable','off');
    set(handles.toolbarTimeAveragedQuantities,'Enable','off');
    load('stopicon.mat','stopicon');
    set(handles.toolbarStopSimulation,'CData',stopicon);
    set(handles.IronLossCalculator,'Visible','off');
elseif strcmp(Tag,'togglebutton_dynamicFEA')
    set(handles.togglebutton_MS,'Value',0);
    set(handles.togglebutton_DQ,'Value',0);
    set(handles.togglebutton_dynamicFEA,'Value',1);
    set(handles.togglebutton_dynamicDQ,'Value',0);
    set(handles.panel_MS,'Visible','off');
    set(handles.panel_DQ,'Visible','off');
    set(handles.panel_dynamicFEA,'Visible','on');
    set(handles.panel_dynamicDQ,'Visible','off');
    set(handles.toolbarRunSimulation,'Enable','on');
    set(handles.toolbarStopSimulation,'Enable','on');
    set(handles.toolbarTimeAveragedQuantities,'Enable','on');
    load('pauseicon.mat','pauseicon');
    set(handles.toolbarStopSimulation,'CData',pauseicon);
    set(handles.toolbarStopSimulation,'TooltipString','Pause simulation');
    set(handles.toolbarRunSimulation,'TooltipString','Start dynamic FEA simulation');
elseif strcmp(Tag,'togglebutton_dynamicDQ')
    set(handles.togglebutton_MS,'Value',0);
    set(handles.togglebutton_DQ,'Value',0);
    set(handles.togglebutton_dynamicFEA,'Value',0);
    set(handles.togglebutton_dynamicDQ,'Value',1);
    set(handles.panel_MS,'Visible','off');
    set(handles.panel_DQ,'Visible','off');
    set(handles.panel_dynamicFEA,'Visible','off');
    set(handles.panel_dynamicDQ,'Visible','on');
    set(handles.toolbarRunSimulation,'Enable','on');
    set(handles.toolbarStopSimulation,'Enable','on');
    set(handles.toolbarTimeAveragedQuantities,'Enable','on');
    load('stopicon.mat','stopicon');
    set(handles.toolbarStopSimulation,'CData',stopicon);
    set(handles.toolbarStopSimulation,'TooltipString','Stop simulation');
    set(handles.toolbarRunSimulation,'TooltipString','Start dynamic D-Q simulation');
    set(handles.IronLossCalculator,'Visible','off');
else
    error('Something goes wrong!')
end
Update(hObject);
PlotWizard = handles.PlotWizard;
PlotWizardHandles = guidata(PlotWizard);
OuterPosition=get(handles.PlotWizard,'OuterPosition');
OuterPosition3init=handles.PlotWizardOuterPosition3;
OuterPosition4init=handles.PlotWizardOuterPosition4;
if strcmp(get(PlotWizardHandles.pushbutton_showplottedquantities,'String'),'Plotted quantities  <<')
    OuterPosition(3) = OuterPosition3init*2/3;
    OuterPosition(4) = OuterPosition4init;
    set(PlotWizardHandles.PlotWizard,'OuterPosition',OuterPosition);
    set(PlotWizardHandles.pushbutton_showplottedquantities,'String','Plotted quantities  >>');
    set(PlotWizardHandles.pushbutton_showplottedquantities,'TooltipString','Click to show plotted quantities');
end
if get(handles.togglebutton_DQ,'Value')
    set(handles.PlotWizard,'Name','Plot Wizard: D-Q Analysis');
    set(PlotWizardHandles.panel_tm_plot,'Visible','off');
    set(PlotWizardHandles.panel_ag_plot,'Visible','off');
    set(PlotWizardHandles.panel_cs_plot,'Visible','off');
    set(PlotWizardHandles.panel_animation,'Visible','off');
    set(PlotWizardHandles.text_source,'Visible','off');
    set(PlotWizardHandles.pup_source,'Visible','off');
    set(PlotWizardHandles.pushbutton_chgsource,'Visible','off');
    set(PlotWizardHandles.panel_DQplot,'Visible','on');
    set(PlotWizardHandles.panel_DQplottedquantities,'Visible','on');
    set(PlotWizardHandles.panel_efficiencymap,'Visible','on');
    OuterPosition(3) = OuterPosition3init/2;
    OuterPosition(4) = OuterPosition4init*1;
elseif get(handles.togglebutton_dynamicDQ,'Value') 
    set(handles.PlotWizard,'Name','Plot Wizard: Dynamic D-Q Analysis');
    set(PlotWizardHandles.panel_tm_plot,'Visible','on');
    set(PlotWizardHandles.panel_ag_plot,'Visible','off');
    set(PlotWizardHandles.panel_cs_plot,'Visible','off');
    set(PlotWizardHandles.panel_animation,'Visible','off');
    set(PlotWizardHandles.text_source,'Visible','off');
    set(PlotWizardHandles.pup_source,'Visible','off');
    set(PlotWizardHandles.pushbutton_chgsource,'Visible','off');
    set(PlotWizardHandles.panel_DQplot,'Visible','off');
    set(PlotWizardHandles.panel_DQplottedquantities,'Visible','off');
    set(PlotWizardHandles.panel_efficiencymap,'Visible','off');
    OuterPosition(3) = OuterPosition3init;
    OuterPosition(4) = OuterPosition4init/3;   
    % Move panel_tm_plot to the bottom
    Position_panel_tm_plot=get(PlotWizardHandles.panel_tm_plot,'Position');
    Position_bottom=get(PlotWizardHandles.pushbutton_chgsource,'Position');
    Position_panel_tm_plot(2)=Position_bottom(2);
    set(PlotWizardHandles.panel_tm_plot,'Position',Position_panel_tm_plot);
else
   if get(handles.togglebutton_dynamicFEA,'Value')
       set(handles.PlotWizard,'Name','Plot Wizard: Dynamic FE Analysis');
   elseif get(handles.togglebutton_MS,'Value')
       set(handles.PlotWizard,'Name','Plot Wizard: Magnetostatic Analysis');
   end
   set(PlotWizardHandles.panel_tm_plot,'Visible','on');
   set(PlotWizardHandles.panel_ag_plot,'Visible','on');
   set(PlotWizardHandles.panel_cs_plot,'Visible','on');
   set(PlotWizardHandles.panel_animation,'Visible','on');
   set(PlotWizardHandles.text_source,'Visible','on');
    set(PlotWizardHandles.pup_source,'Visible','on');
    set(PlotWizardHandles.pushbutton_chgsource,'Visible','on');
   set(PlotWizardHandles.panel_DQplot,'Visible','off');
   set(PlotWizardHandles.panel_DQplottedquantities,'Visible','off');
   set(PlotWizardHandles.panel_efficiencymap,'Visible','off');
   OuterPosition(3) = OuterPosition3init;
   OuterPosition(4) = OuterPosition4init;
   % Move panel_tm_plot to its initial place
   Position_panel_tm_plot=get(PlotWizardHandles.panel_tm_plot,'UserData');
   set(PlotWizardHandles.panel_tm_plot,'Position',Position_panel_tm_plot);
end
set(0,'Units',get(PlotWizardHandles.PlotWizard,'Units'));
scnsize = get(0,'ScreenSize');
if OuterPosition(1)+OuterPosition(3)>scnsize(3)
    OuterPosition(1) = scnsize(3)-OuterPosition(3);
end
if OuterPosition(2)+OuterPosition(4)>scnsize(4)
    OuterPosition(2) = scnsize(4)-OuterPosition(4);
end
if OuterPosition(1)<0
    OuterPosition(1)=0;
end
if OuterPosition(2)<0
    OuterPosition(2)=0;
end
set(PlotWizardHandles.PlotWizard,'OuterPosition',OuterPosition);
PlotWizardHandles.UpdatePlotWizard(PlotWizard,[]);


% --- Executes on button press in pushbutton_xx_defaultspeed or pushbutton_xx_defaultcurrent.
function pushbutton_setupdefault_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_DF_defaultspeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Simulation = handles.Simulation;
RatedData=Simulation.RatedData;
Settings=Simulation.Settings;
Tag = get(hObject,'Tag');
if strfind(Tag,'defaultcurrent')
    RatedCurrent=RatedData.RatedCurrent;   % rated supply current
    if isempty(RatedCurrent)
        errordlg('No rated supply current specified in Rated Data window.','Default Current Setup','modal');
        return
    end
    if strcmp(Tag,'pushbutton_MS_defaultcurrent')
        Settings.Magnetostatic.MS_I = RatedCurrent;
    elseif strcmp(Tag,'pushbutton_DF_defaultcurrent')    
        Settings.DynamicFEA.DF_Isrms = RatedCurrent;
    elseif strcmp(Tag,'pushbutton_DD_defaultcurrent')       
        Settings.DynamicDQ.DD_Isrms = RatedCurrent;
    end    
elseif strfind(Tag,'defaultspeed')
    RatedSpeed=RatedData.RatedSpeed;
    if isempty(RatedSpeed)
        errordlg('No rated speed specified in Rated Data window.','Default Speed Setup','modal');
        return
    end
    if strcmp(Tag,'pushbutton_MS_defaultspeed')
        Settings.Magnetostatic.MS_speed = RatedSpeed;
    elseif strcmp(Tag,'pushbutton_DF_defaultspeed')    
        Settings.DynamicFEA.DF_Speed = RatedSpeed;
    elseif strcmp(Tag,'pushbutton_DD_defaultspeed')     
        Settings.DynamicDQ.DD_Speed = RatedSpeed;
    end    
end
Simulation.Settings=Settings;
handles.Simulation=Simulation;
handles.Saved = 0;
guidata(handles.motoranalysis,handles);
Update(handles.motoranalysis);


% --- Executes on button press in pushbutton_DF_clear.
function pushbutton_DF_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_DF_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button = questdlg('All simulation data of Dynamic FE Analysis will be deleted. Continue?',...
        'Dynamic FE Analysis','Yes','No','No');
if strcmp(button,'No')
    return;
end
Simulation = handles.Simulation;
Simulation_new = CreateSimulation();
Simulation.DynamicFEA = Simulation_new.DynamicFEA;
Simulation.Userdata = [];
handles.Simulation=Simulation;
handles.Saved = 0;
guidata(handles.motoranalysis,handles);
Update(handles.motoranalysis);


% --------------------------------------------------------------------
function toolbarUnlock_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolbarUnlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Simulation = handles.Simulation;
if ~isempty(Simulation.Private)
    button = questdlg('All simulation data of all analysis types will be deleted. Continue?',...
        'MotorAnalysis','Yes','No','No');
    if strcmp(button,'No')
        return;
    end
    set(handles.motoranalysis,'Pointer','watch');drawnow;
    Save_Callback(handles.menuSave, [], handles);
    handles = guidata(handles.motoranalysis);
    pass = LoadSimulation(handles.File,handles,'OpenAsNewSimulation',0);
    if ~pass
        set(handles.motoranalysis,'Pointer','arrow');
        error('Operation failed');
    end
    handles = guidata(handles.motoranalysis);
    Save_Callback(handles.menuSave, [], handles);
    set(handles.motoranalysis,'Pointer','arrow');
end


% --------------------------------------------------------------------
function MenuSettings_Callback(hObject, eventdata, handles)
% hObject    handle to MenuSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
motoranalysissettingsgui();

% --------------------------------------------------------------------
function menuOpenHelp_Callback(hObject, eventdata, handles)
% hObject    handle to menuOpenHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    winopen manual.pdf;
catch
    errordlg('Failed to open manual.pdf','MotorAnalysis Error','modal');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CreateFcn

% --- Executes during object creation, after setting all properties.
function edit_MS_tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function pup_MS_solvertype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_MS_solvertype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_MS_gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_MS_f1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_f1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_MS_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_MS_npoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_npoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function pup_MS_currentwaveform_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_MS_currentwaveform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function pup_MS_saveeachsolutionfolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_MS_saveeachsolutionfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_simfilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_simfilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_f1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_f1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_torque_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_torque (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Is_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Is (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Vs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Vs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Pinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Pinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Pmech_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Pmech (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Efficiency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Efficiency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_PowerFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_PowerFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Ps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Piron_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Piron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_torque_reluctance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_torque_reluctance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_torque_magnet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_torque_magnet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_TorqueRipple_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_TorqueRipple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Piron_eddy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Piron_eddy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Piron_hyst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Piron_hyst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Iq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Iq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Error_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Vd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Vd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_Vq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_Vq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DQ_tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DQ_tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DQ_Isrms_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DQ_Isrms_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DQ_Isrms_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DQ_Isrms_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DQ_gamma_step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DQ_gamma_step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_nPolePairs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_nPolePairs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DF_tol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DF_tol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DF_solvertype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DF_solvertype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DF_Gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DF_Gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DF_saveeachsolutionfolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DF_saveeachsolutionfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DF_stoptime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DF_stoptime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DF_timestep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DF_stoptime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DF_stoptime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DF_stoptime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DF_script_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DF_script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DF_statorcircuit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DF_statorcircuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DF_motorload_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DF_motorload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DF_torquemethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DF_torquemethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DF_Speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DF_Speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DF_SpeedDependency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DF_SpeedDependency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DF_InitSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DF_InitSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DF_laststepcalctime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DF_laststepcalctime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DF_totalcalctime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DF_totalcalctime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DF_settings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DF_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DF_Isrms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DF_Isrms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DD_solvertype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DD_solvertype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DD_Gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DD_Gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DD_timestep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DD_timestep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DD_stoptime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DD_stoptime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DD_StopMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DD_StopMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DD_Isrms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DD_Isrms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DD_motorload_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DD_motorload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DD_Speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DD_Speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DD_SpeedDependency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DD_SpeedDependency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DD_InitSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DD_InitSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_DD_Itol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_DD_Itol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_backEMF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_backEMF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_CurrentDensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_CurrentDensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_I_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_DQ_nRotang_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DQ_nRotang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_DemagHpercent_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_DemagHpercent_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_DemagH_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_DemagH_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_MagnetLoss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_MagnetLoss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_MS_op_OtherECloss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MS_op_OtherECloss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pup_MS_currentinputmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pup_MS_currentinputmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
