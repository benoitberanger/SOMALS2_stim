function [ CURSOR ] = Cursor
global S

diameter   = S.Parameters.Cursor.DimensionRatio*S.PTB.wRect(4);
diskColor  = S.Parameters.Cursor.DiskColor;
frameColor = S.Parameters.Cursor.FrameColor;
Xorigin    = S.PTB.CenterH;
Yorigin    = S.Parameters.Cursor.Ypos * S.PTB.wRect(4);
screenX    = S.PTB.wRect(3);
screenY    = S.PTB.wRect(4);

CURSOR = Dot(...
    diameter   ,...     % diameter  in pixels
    diskColor  ,...     % disk  color [R G B] 0-255
    frameColor ,...     % frame color [R G B] 0-255
    Xorigin    ,...     % X origin  in pixels
    Yorigin    ,...     % Y origin  in pixels
    screenX    ,...     % H pixels of the screen
    screenY    );       % V pixels of the screen

CURSOR.LinkToWindowPtr( S.PTB.wPtr )

CURSOR.AssertReady % just to check

end % function
