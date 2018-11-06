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
    
    [ ER, RR, KL, SR ] = Common.PrepareRecorders( EP );
    
    % This is a pointer copy, not a deep copy
    S.EP = EP;
    S.ER = ER;
    S.RR = KL;
    S.SR = SR;
    
    
    %% Prepare objects
    
    [ CROSS ] = PNEU.Prepare.Cross;
    
    
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
                
                CROSS.Draw
                Screen('DrawingFinished',S.PTB.wPtr);
                Screen('Flip',S.PTB.wPtr);
                
                StartTime = Common.StartTimeEvent;
                
            case 'StopTime' % ---------------------------------------------
                
                [ ER, RR, StopTime ] = Common.StopTimeEvent( EP, ER, RR, StartTime, evt );
                
                
            case 'Rest' % -------------------------------------------------
                
                lastFlipOnset = WaitSecs('UntilTime', StartTime + EP.Data{evt,2});
                
                SR.AddSample([lastFlipOnset-StartTime 0 0])
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime [] EP.Data{evt,4:end}});
                RR.AddEvent({[EP.Data{evt,1} '_CROSS'] lastFlipOnset-StartTime [] []});
                
                when = StartTime + EP.Data{evt+1,2} - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                secs = lastFlipOnset;
                while secs < when
                    
                    SR.AddSample([secs-StartTime 0 0])
                    
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
                
                
            case {'Nerve', 'Skin'} % --------------------------------------
                
                % Send stim
                if strcmp(S.StimONOFF,'ON')
                    switch EP.Data{evt,1}
                        case 'Nerve'
                            msg = {2^6 ; [1 0]};
                            fprintf('Started NERVE channel=7 stimulation \n')
                        case 'Skin'
                            msg = {2^7 ; [0 1]};
                            fprintf('Started SKIN  channel=8 stimulation \n')
                        otherwise
                                error('cond ?')
                    end
                end
                
                when = StartTime + EP.Data{evt+1,2} - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                secs = GetSecs;
                lastStim = secs;
                counter = 0;
                while secs < when
                    
                    counter = counter + 1;
                    
                    if counter > 1
                        lastStim = WaitSecs('UntilTime', lastStim + 1/Parameters.Frequency);
                    else
                        WaitSecs('UntilTime', StartTime + EP.Data{evt,2});
                    end
                    WriteParPort(msg{1});
                    SR.AddSample([GetSecs-StartTime msg{2}])
                    WaitSecs(Parameters.PulseDuration/1000);
                    WriteParPort( 0    );
                    SR.AddSample([GetSecs-StartTime [0 0]])
                       
                    if counter == 1
                        ER.AddEvent({EP.Data{evt,1} lastStim-StartTime [] EP.Data{evt,4:end}});
                        RR.AddEvent({[EP.Data{evt,1} '_CROSS'] lastStim-StartTime [] []});
                    end
                    
                    fprintf('N=%.2d \n', counter);
                    
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
                
                % Send stim
                if strcmp(S.StimONOFF,'ON')
                    switch EP.Data{evt,1}
                        case 'Nerve'
                            fprintf('Stopped NERVE channel=1 stimulation \n')
                        case 'Skin'
                            fprintf('Stopped SKIN  channel=2 stimulation \n')
                        otherwise
                                error('cond ?')
                    end
                end
                
                
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
    
    TaskData = Common.EndOfStimulation( TaskData, EP, ER, RR, KL, SR, StartTime, StopTime );
    
    % TaskData.BR = BR;
    % assignin('base','BR', BR)
    
    
catch err
    
    Common.Catch( err );
    
end

end % function
