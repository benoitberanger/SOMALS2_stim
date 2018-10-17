function [ TaskData ] = Task
global S

try
    %% Tunning of the task
    
    [ EP, Parameters ] = ELEC.Planning;
    TaskData.Parameters = Parameters;
    
    % End of preparations
    EP.BuildGraph;
    TaskData.EP = EP;
    
    
    %% Prepare event record and keybinf logger
    
    [ ER, RR, KL ] = Common.PrepareRecorders( EP );
    
    
    %% Prepare objects
    
    [ QUESTION, YES, NO ] = ELEC.Prepare.Text;
    [ CROSS             ] = ELEC.Prepare.Cross;
    [ CURSOR            ] = ELEC.Prepare.Cursor;
    [ RECT_YES, RECT_NO ] = ELEC.Prepare.Rect;
    
    
    %% Eyelink
    
    Common.StartRecordingEyelink;
    
    
    %% Go
    
    % Initialize some variables
    EXIT = 0;
    
    % Loop over the EventPlanning
    for evt = 1 : size( EP.Data , 1 )
        
        Common.CommandWindowDisplay( EP, evt );
        
        switch EP.Data{evt,1}
            
            case 'StartTime' % --------------------------------------------
                
                % Fetch initialization data
                switch S.InputMethod
                    case 'Joystick'
                        [newX, ~] = ELEC.QueryJoystickData( CURSOR.screenX, CURSOR.screenY );
                    case 'Mouse'
                        SetMouse(CURSOR.Xorigin,CURSOR.Yorigin,CURSOR.wPtr);
                        [newX, ~] = ELEC.QueryMouseData( CURSOR.wPtr, CURSOR.Xorigin, CURSOR.Yorigin );
                end
                
                % Initialize cursor position
                CURSOR.Move(newX,0);
                
                CROSS.Draw
                Screen('DrawingFinished',S.PTB.wPtr);
                Screen('Flip',S.PTB.wPtr);
                
                StartTime = Common.StartTimeEvent;
                
            case 'StopTime' % ---------------------------------------------
                
                [ ER, RR, StopTime ] = Common.StopTimeEvent( EP, ER, RR, StartTime, evt );
                
                
            case 'Rest'
                
                CROSS.Draw
                
                when = StartTime + EP.Data{evt,2} - S.PTB.slack;
                Screen('DrawingFinished', S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                Common.SendParPortMessage(EP.Data{evt,1});
                
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime [] EP.Data{evt,4:end}});
                
                when = StartTime + EP.Data{evt+1,2} - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                secs = lastFlipOnset;
                while secs < when
                    
                    % Fetch keys
                    [keyIsDown, secs, keyCode] = KbCheck;
                    
                    if keyIsDown
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                    end
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
            case {'Nerve', 'Skin'}
                
                QUESTION.Draw
                RECT_YES.Draw
                RECT_NO. Draw
                YES.     Draw
                NO.      Draw
                
                ELEC.UpdateCursor( CURSOR )
                CURSOR.  Draw
                
                when = StartTime + EP.Data{evt,2} - S.PTB.slack;
                Screen('DrawingFinished', S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                Common.SendParPortMessage(EP.Data{evt,1});
                
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime [] EP.Data{evt,4:end}});
                
                
                when = StartTime + EP.Data{evt+1,2} - S.PTB.slack*3;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while lastFlipOnset < when
                    
                    
                    QUESTION.Draw
                    RECT_YES.Draw
                    RECT_NO. Draw
                    YES.     Draw
                    NO.      Draw
                    
                    ELEC.UpdateCursor( CURSOR )
                    CURSOR.  Draw
                    
                    Screen('DrawingFinished', S.PTB.wPtr);
                    lastFlipOnset = Screen('Flip', S.PTB.wPtr);
                    
                    % Fetch keys
                    [keyIsDown, ~, keyCode] = KbCheck;
                    
                    if keyIsDown
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                    end
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
            otherwise % ---------------------------------------------------
                
                error('unknown envent')
                
        end % switch
        
        % This flag comes from Common.Interrupt, if ESCAPE is pressed
        if EXIT
            break
        end
        
    end % for
    
    
    %% End of stimulation
    
    % Close the audio device
    % PsychPortAudio('Close');
    
    TaskData = Common.EndOfStimulation( TaskData, EP, ER, RR, KL, StartTime, StopTime );
    
    % TaskData.BR = BR;
    % assignin('base','BR', BR)
    
    
catch err
    
    Common.Catch( err );
    
end

end % function
