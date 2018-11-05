function Open ( self )

opp_path = which('OpenParPort.m');

if isempty(opp_path)
    
    self.status = false;
    error('[%s:%s] : No function '' OpenParPort '' detected \n', class(self), mfilename)
    
else
    
    if self.IsOpened
        
        warning('[%s:%s] : already opened \n', class(self), mfilename)
        
    else
        
        try
            if IsWin
                OpenParPort();
            elseif IsLinux
                OpenParPort(self.port);
            end
            self.status = true;
            fprintf('[%s:%s] : done \n', class(self), mfilename)
            
        catch err
            
            warning('[%s:%s] : ??? \n', class(self), mfilename)
            self.status = false;
            rethrow(err)
            
        end
        
    end
    
end

end % function
