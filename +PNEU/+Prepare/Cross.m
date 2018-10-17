function [ cross ] = Cross
global S

dim   = round(S.PTB.wRect(4)*S.Parameters.Cross.ScreenRatio);
width = round(dim * S.Parameters.Cross.lineWidthRatio);
color = S.Parameters.Cross.Color;

cross = FixationCross(...
    dim   ,...                       % dimension in pixels
    width ,...                       % width     in pixels
    color ,...                       % color     [R G B] 0-255
    [S.PTB.CenterH S.PTB.CenterV] ); % center    in pixels

cross.LinkToWindowPtr( S.PTB.wPtr )

cross.AssertReady % just to check

end % function
