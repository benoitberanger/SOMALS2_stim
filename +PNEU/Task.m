function [ TaskData ] = Task
global S

try
    %% Tunning of the task
    
    [ EP, Parameters ] = PNEU.Planning;
    TaskData.Parameters = Parameters;
    
    % End of preparations
    EP.BuildGraph;
    TaskData.EP = EP;
    
    
    %% Prepare event record and keybinf logger
    
    [ ER, RR, KL ] = Common.PrepareRecorders( EP );
    
    
    %% Prepare objects
    
    [ QUESTION, YES, NO ] = PNEU.Prepare.Text;
    [ CROSS             ] = PNEU.Prepare.Cross;
    [ CURSOR            ] = PNEU.Prepare.Cursor;
    [ RECT_YES, RECT_NO ] = PNEU.Prepare.Rect;
    
    
    %% Eyelink
    
    Common.StartRecordingEyelink;
    
    
    %% Go
    
    % Initialize some variables
    EXIT = 0;
    onset_YES = [];
    onset_NO  = [];
    
    % Loop over the EventPlanning
    for evt = 1 : size( EP.Data , 1 )
        
        Common.CommandWindowDisplay( EP, evt );
        
        switch EP.Data{evt,1}
            
            case 'StartTime' % --------------------------------------------
                
                % Fetch initialization data
                switch S.InputMethod
                    case 'Joystick'
                        [newX, ~] = PNEU.QueryJoystickData( CURSOR.screenX, CURSOR.screenY );
                    case 'Mouse'
                        SetMouse(CURSOR.Xorigin,CURSOR.Yorigin,CURSOR.wPtr);
                        [newX, ~] = PNEU.QueryMouseData( CURSOR.wPtr, CURSOR.Xorigin, CURSOR.Yorigin );
                end
                
                % Initialize cursor position
                CURSOR.Move(newX,0);
                
                CROSS.Draw
                Screen('DrawingFinished',S.PTB.wPtr);
                Screen('Flip',S.PTB.wPtr);
                
                StartTime = Common.StartTimeEvent;
                
            case 'StopTime' % ---------------------------------------------
                
                [ ER, RR, StopTime ] = Common.StopTimeEvent( EP, ER, RR, StartTime, evt );
                
                
            case 'Rest' % -------------------------------------------------
                
                CROSS.Draw
                
                when = StartTime + EP.Data{evt,2} - S.PTB.slack;
                Screen('DrawingFinished', S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                % Common.SendParPortMessage(EP.Data{evt,1});
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime [] EP.Data{evt,4:end}});
                RR.AddEvent({[EP.Data{evt,1} '_CROSS'] lastFlipOnset-StartTime [] []});
                
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
                
                
            case {'Bone', 'Tendon'} % --------------------------------------
                
                CROSS.Draw
                
                when = StartTime + EP.Data{evt,2} - S.PTB.slack;
                Screen('DrawingFinished', S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                % Common.SendParPortMessage(EP.Data{evt,1});
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime [] EP.Data{evt,4:end}});
                RR.AddEvent({[EP.Data{evt,1} '_CROSS'] lastFlipOnset-StartTime [] []});
                
                when = lastFlipOnset + EP.Data{evt,5} - S.PTB.slack;
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
                
                
                
                
                QUESTION.Draw
                RECT_YES.Draw
                RECT_NO. Draw
                YES.     Draw
                NO.      Draw
                
                PNEU.UpdateCursor( CURSOR )
                CURSOR.  Draw
                
                when = StartTime + EP.Data{evt,4} - S.PTB.slack;
                Screen('DrawingFinished', S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                Common.SendParPortMessage(EP.Data{evt,1});
                RR.AddEvent({[EP.Data{evt,1} '_QUESTION'] lastFlipOnset-StartTime [] []});
                
                when = StartTime + EP.Data{evt+1,2} - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while lastFlipOnset < when
                    
                    is_in_YES = CURSOR.Rect(3)-RECT_YES.currentRect(3) <= 0;
                    is_in_NO  = CURSOR.Rect(1)-RECT_NO .currentRect(1) >= 0;
                    
                    if is_in_YES
                        RECT_YES.currentFrameColor = [0 255 0];
                        if lastFlipOnset - onset_YES > Parameters.TimeToValidate
                            RR.AddEvent({[EP.Data{evt,1} '_QUESTION_validYES'] lastFlipOnset-StartTime [] []});
                            RECT_YES.currentFrameColor  =  RECT_YES.baseFrameColor;
                            break
                        end
                    else
                        RECT_YES.currentFrameColor  =  RECT_YES.baseFrameColor;
                        onset_YES = [];
                    end
                    
                    if is_in_NO
                        RECT_NO.currentFrameColor = [0 255 0];
                        if lastFlipOnset - onset_NO > Parameters.TimeToValidate
                            RR.AddEvent({[EP.Data{evt,1} '_QUESTION_validNO'] lastFlipOnset-StartTime [] []});
                            RECT_NO.currentFrameColor  =  RECT_NO.baseFrameColor;
                            break
                        end
                    else
                        RECT_NO.currentFrameColor  =  RECT_NO.baseFrameColor;
                        onset_NO = [];
                    end

                    QUESTION.Draw
                    RECT_YES.Draw
                    RECT_NO. Draw
                    YES.     Draw
                    NO.      Draw
                    
                    PNEU.UpdateCursor( CURSOR )
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
                    
                    if is_in_YES && isempty(onset_YES)
                        onset_YES = lastFlipOnset;
                        RR.AddEvent({[EP.Data{evt,1} '_QUESTION_inYES'] lastFlipOnset-StartTime [] []});
                    end
                    
                    if is_in_NO && isempty(onset_NO)
                        onset_NO = lastFlipOnset;
                        RR.AddEvent({[EP.Data{evt,1} '_QUESTION_inNO'] lastFlipOnset-StartTime [] []});
                    end
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
                
                
                CROSS.Draw
                
                when = StartTime + EP.Data{evt,2} - S.PTB.slack;
                Screen('DrawingFinished', S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                % Common.SendParPortMessage(EP.Data{evt,1});
                RR.AddEvent({[EP.Data{evt,1} '_validCROSS'] lastFlipOnset-StartTime [] []});
                
                
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
