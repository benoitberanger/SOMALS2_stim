function SendPulse ( self, msg , pulseWidth )

if nargin < 2
    msg = 255;
end
if nargin < 3
    pulseWidth = 0.005; % 5 milliseconds
end

%% Send

self.Write( msg      );
WaitSecs  (pulseWidth); % 5 milliseconds
self.Write( 0        );


end % function
