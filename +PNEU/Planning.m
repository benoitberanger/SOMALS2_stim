function [ EP , Parameters ] = Planning
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    S.OperationMode = 'Acquisition';
end


%% Paradigme

switch S.OperationMode
    case 'Acquisition'
        Parameters.RestDuration        = [10 15];  % second
        Parameters.PulseDuration       = 1;% ms
        Parameters.ActivityDuration    = 25;  % second
        Parameters.NrPulsesTotal       = 600;
        Parameters.Frequency           = 2;% Hz
        Parameters.NrRepetitions       = Parameters.NrPulsesTotal/Parameters.ActivityDuration/Parameters.Frequency;
        Parameters.NrPulsesBlock       = Parameters.ActivityDuration*Parameters.Frequency;
        Parameters.ValidationTime      = 1; % second
    case 'FastDebug'
        Parameters.RestDuration        = [0.5 1];  % second
        Parameters.PulseDuration       = 1;% ms
        Parameters.ActivityDuration    = 5;  % second
        Parameters.NrPulsesTotal       = 10;
        Parameters.Frequency           = 2;% Hz
        Parameters.NrRepetitions       = Parameters.NrPulsesTotal/Parameters.ActivityDuration/Parameters.Frequency;
        Parameters.NrPulsesBlock       = Parameters.ActivityDuration*Parameters.Frequency;
        Parameters.ValidationTime      = 1; % second
    case 'RealisticDebug'
        Parameters.RestDuration        = [10 15];  % second
        Parameters.PulseDuration       = 1;% ms
        Parameters.ActivityDuration    = 25;  % second
        Parameters.NrPulsesTotal       = 100;
        Parameters.Frequency           = 2;% Hz
        Parameters.NrRepetitions       = Parameters.NrPulsesTotal/Parameters.ActivityDuration/Parameters.Frequency;
        Parameters.NrPulsesBlock       = Parameters.ActivityDuration*Parameters.Frequency;
        Parameters.ValidationTime      = 1; % second
end


%% Randomization the trials
% Maximum 3 in a row

Parameters.ListOfConditions_str = {'Nerve', 'Skin'};
Parameters.ListOfConditions_num = [ 1     ,  2    ];

vect = Shuffle([ones(1,Parameters.NrRepetitions)*1 ones(1,Parameters.NrRepetitions)*2]);
while true
    vect_str = num2str(vect);
    vect_str = strrep(vect_str,' ','');
    if any(regexp(vect_str,'1111')) || any(regexp(vect_str,'2222'))
        vect = Shuffle([ones(1,Parameters.NrRepetitions)*1 ones(1,Parameters.NrRepetitions)*2]);
    else
        break
    end
end

Parameters.ConditionOrder_num = vect;
Parameters.ConditionOrder_str = Parameters.ListOfConditions_str(Parameters.ConditionOrder_num);

NrTrials = length(Parameters.ConditionOrder_num);


%% Define a planning <--- paradigme


% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)','#Condition'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};


% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

restdur = Parameters.RestDuration(1) + (Parameters.RestDuration(2)-Parameters.RestDuration(1))*rand;
EP.AddPlanning({ 'Rest' NextOnset(EP) restdur [] })

for evt = 1 : NrTrials
    
    name = Parameters.ConditionOrder_str{evt};
    idx  = Parameters.ConditionOrder_num(evt);
    EP.AddPlanning({ name NextOnset(EP) Parameters.ActivityDuration idx })
    
    restdur = Parameters.RestDuration(1) + (Parameters.RestDuration(2)-Parameters.RestDuration(1))*rand;
    EP.AddPlanning({ 'Rest' NextOnset(EP) restdur [] })
    
end

% --- Stop ----------------------------------------------------------------

EP.AddStopTime('StopTime',NextOnset(EP));


%% Display

% To prepare the planning and visualize it, we can execute the function
% without output argument

if nargout < 1
    
    fprintf( '\n' )
    fprintf(' \n Total stim duration : %g seconds \n' , NextOnset(EP) )
    fprintf( '\n' )
    
    EP.Plot
    
end


end % function