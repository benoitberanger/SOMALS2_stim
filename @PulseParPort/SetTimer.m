function SetTimer ( self, timer_msg, pulseWidth, frequency )

self.AssertIsOpened

self.timer_msg  = timer_msg;
self.pulseWidth = pulseWidth;
self.frequency  = frequency;

dt = 1/frequency - pulseWidth;

t = timer(...
    'BusyMode'      , 'queue'          , ...
    'ExecutionMode' , 'fixedSpacing'   , ...
    'Name'          , sprintf('timser_%s',class(self)), ...
    'Period'        , dt               , ...
    'StartDelay'    , 0                , ...
    'Tag'           , sprintf('timser_%s',class(self)), ...
    'TasksToExecute', Inf              , ...
    'TimerFcn'      , { @TimerFcn , self.timer_msg , self.pulseWidth }...
    );

self.timer = t;

end % function

function TimerFcn ( ~ , ~ , timer_msg , pulseWidth )

WriteParPort(timer_msg );
WaitSecs    (pulseWidth);
WriteParPort(0         );

end
