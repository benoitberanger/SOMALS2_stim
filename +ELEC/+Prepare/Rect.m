function [ RECT_YES, RECT_NO ] = Rect
global S


%% Yes

rect       = [
    0 
    S.PTB.wRect(4)*(1 - S.Parameters.Yes.RectY)
    S.PTB.wRect(3)*S.Parameters.Yes.RectX
    S.PTB.wRect(4)
    ]';
framecolor = S.Parameters.Yes.FrameColor;
fillcolor  = S.Parameters.Yes.FillColor;

RECT_YES = Rect(...
    rect       ,...
    framecolor ,...
    fillcolor  );

RECT_YES.LinkToWindowPtr( S.PTB.wPtr )

RECT_YES.AssertReady % just to check


%% No

rect       = [
    S.PTB.wRect(3)*(1 - S.Parameters.No.RectX)
    S.PTB.wRect(4)*(1 - S.Parameters.No.RectY)
    S.PTB.wRect(3)
    S.PTB.wRect(4)
    ]';
framecolor = S.Parameters.No.FrameColor;
fillcolor  = S.Parameters.No.FillColor;

RECT_NO = Rect(...
    rect       ,...
    framecolor ,...
    fillcolor  );

RECT_NO.LinkToWindowPtr( S.PTB.wPtr )

RECT_NO.AssertReady % just to check

end % function
