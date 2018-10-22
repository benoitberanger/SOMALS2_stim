function varargout = GUI_PulseParPort( container )
%GUI_PulseParPort is the function that creates (or bring to focus) GUI_PulseParPort
% You can call PulseParPort.GUI_PulseParPort( figHandle / uipanelHandle ) to UI inside another container

% debug=1 closes previous figure and reopens it, and send the gui handles
% to base workspace.
debug = 0;


%% Open a singleton figure, or gring the actual into focus.

% Is the GUI already open ?
figPtr = findall(0,'Tag',mfilename);

if ~isempty(figPtr) % Figure exists so brings it to the focus
    
    figure(figPtr);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if debug
        close(figPtr); %#ok<UNRCH>
        PulseParPort.GUI_PulseParPort;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
else % Create the figure
    
    if ~exist( 'container' , 'var' )
        
        % Create a figure
        figHandle = figure( ...
            'HandleVisibility', 'off',... % close all does not close the figure
            'MenuBar'         , 'none'                   , ...
            'Toolbar'         , 'none'                   , ...
            'Name'            , mfilename                , ...
            'NumberTitle'     , 'off'                    , ...
            'Units'           , 'Pixels'                 , ...
            'Position'        , [20, 20, 500, 500] , ...
            'Tag'             , mfilename                );
        
        container = figHandle;
        new_fig = 1;
        
    else
        
        figHandle = container;
        new_fig = 0;
        
    end
    
    figureBGcolor = [0.9 0.9 0.9];
    buttonBGcolor = figureBGcolor - 0.1;
    editBGcolor   = [1.0 1.0 1.0];
    
    if new_fig
        set(figHandle,'Color',figureBGcolor);
    end
    
    % Create GUI handles : pointers to access the graphic objects
    handles               = guihandles(figHandle);
    handles.figureBGcolor = figureBGcolor;
    handles.buttonBGcolor = buttonBGcolor;
    handles.editBGcolor   = editBGcolor  ;
    
    
    %% Panel proportions
    
    panelProp.xposP = 0.01; % xposition of panel normalized : from 0 to 1
    panelProp.wP    = 1 - panelProp.xposP * 2;
    
    panelProp.interWidth = 0.01;
    panelProp.vect  = ...
        [2 1]; % relative proportions of each panel, from bottom to top
    panelProp.vectLength    = length(panelProp.vect);
    panelProp.vectTotal     = sum(panelProp.vect);
    panelProp.unitWidth     = ( 1 - (panelProp.interWidth*(panelProp.vectLength + 1)) ) / panelProp.vectTotal ;
    
    panelProp.countP = panelProp.vectLength + 1;
    panelProp.yposP  = @(countP) panelProp.unitWidth*sum(panelProp.vect(1:countP-1)) + panelProp.interWidth *(countP);
    
    
    %% Panel : Open / Close
    
    p_oc.x = panelProp.xposP;
    p_oc.w = panelProp.wP;
    
    panelProp.countP = panelProp.countP - 1;
    p_oc.y = panelProp.yposP(panelProp.countP);
    p_oc.h = panelProp.unitWidth*panelProp.vect(panelProp.countP);
    
    handles.uipanel_PPP_OpenClose = uipanel(container,...
        'Title','Open / Close',...
        'Units', 'Normalized',...
        'Position',[p_oc.x p_oc.y p_oc.w p_oc.h],...
        'BackgroundColor',figureBGcolor);
    
    % ---------------------------------------------------------------------
    % Pushbutton : Close
    
    b_close.x = 0.20;
    b_close.w = 0.60;
    b_close.y = 0.1;
    b_close.h = 0.40;
    b_close.tag = 'pushbutton_PPP_Close';
    handles.(b_close.tag) = uicontrol(handles.uipanel_PPP_OpenClose,...
        'Style','pushbutton',...
        'Units', 'Normalized',...
        'Position',[b_close.x b_close.y b_close.w b_close.h],...
        'String','Close',...
        'BackgroundColor',[1 0 0],...
        'TooltipString','',...
        'Callback',@pushbutton_PPP_Close_Callback);
    
    % ---------------------------------------------------------------------
    % Pushbutton : Open
    
    b_open.x = b_close.x;
    b_open.w = b_close.w;
    b_open.y = b_close.y + b_close.h;
    b_open.h = b_close.h;
    b_open.tag = 'pushbutton_PPP_Open';
    handles.(b_open.tag) = uicontrol(handles.uipanel_PPP_OpenClose,...
        'Style','pushbutton',...
        'Units', 'Normalized',...
        'Position',[b_open.x b_open.y b_open.w b_open.h],...
        'String','Open',...
        'BackgroundColor',buttonBGcolor,...
        'TooltipString','',...
        'Callback',@pushbutton_PPP_Open_Callback);
    
    
    %% Panel : Single shot
    
    p_singleshot.proportions = 0.40;
    
    p_singleshot.x = panelProp.xposP;
    p_singleshot.w = 1 - panelProp.wP*(1-p_singleshot.proportions) - 3*panelProp.xposP;
    
    panelProp.countP = panelProp.countP - 1;
    p_singleshot.y = panelProp.yposP(panelProp.countP);
    p_singleshot.h = panelProp.unitWidth*panelProp.vect(panelProp.countP);
    
    handles.uipanel_singleshot = uibuttongroup(container,...
        'Title','Signle shot',...
        'Units', 'Normalized',...
        'Position',[p_singleshot.x p_singleshot.y p_singleshot.w p_singleshot.h],...
        'BackgroundColor',figureBGcolor);
    
    
    x = 0.05;
    w = 1 - 2*x;
    
    % ---------------------------------------------------------------------
    % Pushbutton : Send
    
    b_ss_send.x   = x;
    b_ss_send.w   = w;
    b_ss_send.y   = 0.05;
    b_ss_send.h   = 0.30;
    b_ss_send.tag = 'pushbutton_SingleShot_SEND';
    handles.(b_ss_send.tag) = uicontrol(handles.uipanel_singleshot,...
        'Style','pushbutton',...
        'Units', 'Normalized',...
        'Position',[b_ss_send.x b_ss_send.y b_ss_send.w b_ss_send.h],...
        'String','SEND',...
        'BackgroundColor',buttonBGcolor,...
        'Tag',b_ss_send.tag,...
        'Callback',@pushbutton_SEND_Callback,...
        'Tooltip','Send the message');
    
    % ---------------------------------------------------------------------
    % Edit : PulseWidth
    
    e_ss_pw.x   = x;
    e_ss_pw.w   = w;
    e_ss_pw.y   = b_ss_send.y + b_ss_send.h;
    e_ss_pw.h   = b_ss_send.h;
    e_ss_pw.tag = 'edit_SingleShot_PulseWidth';
    handles.(e_ss_pw.tag) = uicontrol(handles.uipanel_singleshot,...
        'Style','edit',...
        'Units', 'Normalized',...
        'Position',[e_ss_pw.x e_ss_pw.y e_ss_pw.w e_ss_pw.h],...
        'String','0.005',...
        'BackgroundColor',editBGcolor,...
        'Visible','On',...
        'Tooltip','PulseWidth (in second)');
    
    % ---------------------------------------------------------------------
    % Edit : Message
    
    e_ss_msg.x   = x;
    e_ss_msg.w   = w;
    e_ss_msg.y   = e_ss_pw.y + e_ss_pw.h;
    e_ss_msg.h   = e_ss_pw.h;
    e_ss_msg.tag = 'edit_SingleShot_Message';
    handles.(e_ss_msg.tag) = uicontrol(handles.uipanel_singleshot,...
        'Style','edit',...
        'Units', 'Normalized',...
        'Position',[e_ss_msg.x e_ss_msg.y e_ss_msg.w e_ss_msg.h],...
        'String','255',...
        'BackgroundColor',editBGcolor,...
        'Visible','On',...
        'Tooltip','Message (uint8 : 0,1,2,...,255)');
    
    
    %% Panel : Timer
    
    p_timer.x = p_singleshot.x + p_singleshot.w + panelProp.xposP;
    p_timer.w = 1 - panelProp.wP*p_singleshot.proportions - 3*panelProp.xposP;
    
    p_timer.y = p_singleshot.y;
    p_timer.h = p_singleshot.h;
    
    handles.uipanel_Timer = uibuttongroup(container,...
        'Title','Timer',...
        'Units', 'Normalized',...
        'Position',[p_timer.x p_timer.y p_timer.w p_timer.h],...
        'BackgroundColor',figureBGcolor);
    
    
    x = 0.30;
    w = 1 - 2*x;
    
    % ---------------------------------------------------------------------
    % Pushbutton : StartTimer
    
    b_t_start.x   = x-w/2;
    b_t_start.w   = w;
    b_t_start.y   = b_ss_send.y;
    b_t_start.h   = b_ss_send.h;
    b_t_start.tag = 'pushbutton_Timer_Start';
    handles.(b_t_start.tag) = uicontrol(handles.uipanel_Timer,...
        'Style','pushbutton',...
        'Units', 'Normalized',...
        'Position',[b_t_start.x b_t_start.y b_t_start.w b_t_start.h],...
        'String','Start',...
        'BackgroundColor',buttonBGcolor,...
        'Tag',b_t_start.tag,...
        'Callback',@pushbutton_Timer_Start_Callback,...
        'Tooltip','');
    
    % ---------------------------------------------------------------------
    % Pushbutton : StopTimer
    
    b_t_stop.x   = x+w/2;
    b_t_stop.w   = w;
    b_t_stop.y   = b_ss_send.y;
    b_t_stop.h   = b_ss_send.h;
    b_t_stop.tag = 'pushbutton_Timer_Stop';
    handles.(b_t_stop.tag) = uicontrol(handles.uipanel_Timer,...
        'Style','pushbutton',...
        'Units', 'Normalized',...
        'Position',[b_t_stop.x b_t_stop.y b_t_stop.w b_t_stop.h],...
        'String','Stop',...
        'BackgroundColor',[1 0 0],...
        'Tag',b_t_stop.tag,...
        'Callback',@pushbutton_Timer_Stop_Callback,...
        'Tooltip','Stop');
    
    % ---------------------------------------------------------------------
    % Edit : PulseWidth
    
    e_t_pw.x   = x-w/2;
    e_t_pw.w   = w;
    e_t_pw.y   = b_t_start.y + b_t_start.h;
    e_t_pw.h   = b_t_start.h;
    e_t_pw.tag = 'edit_Timer_PulseWidth';
    handles.(e_t_pw.tag) = uicontrol(handles.uipanel_Timer,...
        'Style','edit',...
        'Units', 'Normalized',...
        'Position',[e_t_pw.x e_t_pw.y e_t_pw.w e_t_pw.h],...
        'String','0.001',...
        'BackgroundColor',editBGcolor,...
        'Visible','On',...
        'Tooltip','PulseWidth (in second)');
    
    % ---------------------------------------------------------------------
    % Edit : Frequency
    
    e_t_freq.x   = x+w/2;
    e_t_freq.w   = w;
    e_t_freq.y   = b_t_start.y + b_t_start.h;
    e_t_freq.h   = b_t_start.h;
    e_t_freq.tag = 'edit_Timer_Frequency';
    handles.(e_t_freq.tag) = uicontrol(handles.uipanel_Timer,...
        'Style','edit',...
        'Units', 'Normalized',...
        'Position',[e_t_freq.x e_t_freq.y e_t_freq.w e_t_freq.h],...
        'String','2',...
        'BackgroundColor',editBGcolor,...
        'Visible','On',...
        'Tooltip','Frequency (in Hertz)');
    
    % ---------------------------------------------------------------------
    % Edit : Message
    
    e_t_msg.x   = x;
    e_t_msg.w   = w;
    e_t_msg.y   = e_t_freq.y + e_t_freq.h;
    e_t_msg.h   = e_t_freq.h;
    e_t_msg.tag = 'edit_Timer_Message';
    handles.(e_t_msg.tag) = uicontrol(handles.uipanel_Timer,...
        'Style','edit',...
        'Units', 'Normalized',...
        'Position',[e_t_msg.x e_t_msg.y e_t_msg.w e_t_msg.h],...
        'String','255',...
        'BackgroundColor',editBGcolor,...
        'Visible','On',...
        'Tooltip','Message (uint8 : 0,1,2,...,255)');
    
    
    %% End of opening
    
    % IMPORTANT
    guidata(figHandle,handles)
    % After creating the figure, dont forget the line
    % guidata(figHandle,handles) . It allows smart retrive like
    % handles=guidata(hObject)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if debug
        assignin('base','handles',handles) %#ok<UNRCH>
        disp(handles)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figPtr = figHandle;
    
    
end

if nargout > 0
    
    varargout{1} = guidata(figPtr);
    
end


end % function


%% GUI Functions

% % -------------------------------------------------------------------------
% function obj = Object_Xpos_Xwidth_dispatcher( obj , vect , interWidth )
% 
% obj.vect  = vect; % relative proportions of each panel, from left to right
% 
% obj.interWidth = interWidth;
% obj.vectLength = length(obj.vect);
% obj.vectTotal  = sum(obj.vect);
% obj.unitWidth  = ( 1 - (obj.interWidth*(obj.vectLength + 1)) ) / obj.vectTotal ;
% 
% obj.count  = 0;
% obj.xpos   = @(count) obj.unitWidth*sum(obj.vect(1:count-1)) + obj.interWidth *(count);
% obj.xwidth = @(count) obj.vect(count)*obj.unitWidth;
% 
% end % function


% -------------------------------------------------------------------------
function pushbutton_PPP_Open_Callback(hObject, ~)
handles = guidata(hObject); % load gui data

if isfield(handles, 'PulseParPort')
    warning('PulseParPort is already opened')
    return
end

handles.PulseParPort = PulseParPort(); % create instance
handles.PulseParPort.Open();
handles.PulseParPort.Write(0);

set(handles.pushbutton_PPP_Open ,'BackgroundColor',[0 1 0]              );
set(handles.pushbutton_PPP_Close,'BackgroundColor',handles.buttonBGcolor);

guidata(hObject,handles); % store gui data
end % function


% -------------------------------------------------------------------------
function pushbutton_PPP_Close_Callback(hObject, ~)
handles = guidata(hObject); % load gui data

if ~isfield(handles, 'PulseParPort')
    warning('PulseParPort not opened')
    return
end

handles.PulseParPort.Write(0);
handles.PulseParPort.Close();
handles.PulseParPort.delete;
handles = rmfield(handles, 'PulseParPort');

set(handles.pushbutton_PPP_Close ,'BackgroundColor',[1 0 0]              );
set(handles.pushbutton_PPP_Open  ,'BackgroundColor',handles.buttonBGcolor);

guidata(hObject,handles); % store gui data
end % function


% -------------------------------------------------------------------------
function pushbutton_SEND_Callback(hObject, ~)
handles = guidata(hObject); % load gui data

if ~isfield(handles, 'PulseParPort')
    warning('PulseParPort not opened')
    return
end

msg        = str2double(handles.edit_SingleShot_Message   .String);
pulseWidth = str2double(handles.edit_SingleShot_PulseWidth.String);

fprintf('Sending pulse : msg=%d during %g seconds \n', msg, pulseWidth)
handles.PulseParPort.SendPulse( msg , pulseWidth );

guidata(hObject,handles); % store gui data
end % function


% -------------------------------------------------------------------------
function pushbutton_Timer_Start_Callback(hObject, ~)
handles = guidata(hObject); % load gui data

if ~isfield(handles, 'PulseParPort')
    warning('PulseParPort not opened')
    return
end

if ~isempty(handles.PulseParPort.timer)
    warning('PulseParPort timer is already running')
    return
end

msg        = str2double(handles.edit_Timer_Message   .String);
pulseWidth = str2double(handles.edit_Timer_PulseWidth.String);
frequency  = str2double(handles.edit_Timer_Frequency .String);

fprintf('Starting pulse cycle : msg=%d during %g seconds, with frequency=%g Hz \n', msg, pulseWidth, frequency)
handles.PulseParPort.SetTimer( msg , pulseWidth, frequency );
handles.PulseParPort.StartTimer();

set(handles.pushbutton_Timer_Start ,'BackgroundColor',[0 1 0]              );
set(handles.pushbutton_Timer_Stop  ,'BackgroundColor',handles.buttonBGcolor);

guidata(hObject,handles); % store gui data
end % function

% -------------------------------------------------------------------------
function pushbutton_Timer_Stop_Callback(hObject, ~)
handles = guidata(hObject); % load gui data

if ~isfield(handles, 'PulseParPort')
    warning('PulseParPort not opened')
    return
end

if isempty(handles.PulseParPort.timer)
    warning('PulseParPort timer is not running')
    return
end

handles.PulseParPort.StopTimer();
delete(handles.PulseParPort.timer);
handles.PulseParPort.timer = [];

set(handles.pushbutton_Timer_Stop  ,'BackgroundColor', [1 0 0]              );
set(handles.pushbutton_Timer_Start ,'BackgroundColor', handles.buttonBGcolor);

guidata(hObject,handles); % store gui data
end % function

