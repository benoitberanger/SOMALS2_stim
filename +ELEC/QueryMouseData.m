function [newX, newY] = QueryMouseData( wPtr, Xorigin, Yorigin )

% Fetch data
[x,y] = GetMouse(wPtr); % (x,y) in PTB coordiantes

% PTB coordinates to Origin coordinates
newX = x - Xorigin;
newY = y - Yorigin;

end % function
