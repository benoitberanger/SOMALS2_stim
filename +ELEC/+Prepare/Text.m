function [ QUESTION, YES, NO ] = Text
global S

%% Question

color   = S.Parameters.Question.Color;
content = S.Parameters.Question.Content;
Xptb    = S.Parameters.Question.Xpos * S.PTB.wRect(3);
Yptb    = S.Parameters.Question.Ypos * S.PTB.wRect(4);

QUESTION = Text(...
    color   ,...
    content ,...
    Xptb    ,...
    Yptb    );

QUESTION.LinkToWindowPtr( S.PTB.wPtr )
QUESTION.GenRect();
QUESTION.AssertReady % just to check


%% Yes

color   = S.Parameters.Yes.Color;
content = S.Parameters.Yes.Content;
Xptb    = S.Parameters.Yes.Xpos * S.PTB.wRect(3);
Yptb    = S.Parameters.Yes.Ypos * S.PTB.wRect(4);

YES = Text(...
    color   ,...
    content ,...
    Xptb    ,...
    Yptb    );

YES.LinkToWindowPtr( S.PTB.wPtr )
YES.GenRect();
YES.AssertReady % just to check


%% No

color   = S.Parameters.No.Color;
content = S.Parameters.No.Content;
Xptb    = S.Parameters.No.Xpos * S.PTB.wRect(3);
Yptb    = S.Parameters.No.Ypos * S.PTB.wRect(4);

NO = Text(...
    color   ,...
    content ,...
    Xptb    ,...
    Yptb    );

NO.LinkToWindowPtr( S.PTB.wPtr )
NO.GenRect();
NO.AssertReady % just to check


end % function
