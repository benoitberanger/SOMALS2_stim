OpenParPort

while ~KbCheck
   
    WriteParPort(2^5);
    WaitSecs(0.001);
    WriteParPort(0);
    
    WaitSecs(0.5);
    
    WriteParPort(2^7);
    WaitSecs(0.001);
    WriteParPort(0);
    
    WaitSecs(0.5);
    
end

CloseParPort
