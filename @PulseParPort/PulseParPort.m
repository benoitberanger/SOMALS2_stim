classdef PulseParPort < handle
    %PULSEPARPORT to command train of pulses sent by parallel port
    
    
    %% Properties
    
    properties
        
        port = 0;  % /dev/parport[port]
        
        status     % opened ? 0 or 1
        last_msg   % last message 
        
        pulseWidth % in second
        frequency  % in hertz
        timer_msg  % message {0,1,2,...,255} uint8
        
        timer      % timer object
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        
        function self = PulseParPort( port )
            
            if nargin > 0
                self.port = port;
            end
            self.status = false;
            
        end % function : ctor
        
    end % methods
    
    methods(Static)
        
        out = GUI_PulseParPort( container )
        
    end % methods static
    
    
end % classdef
