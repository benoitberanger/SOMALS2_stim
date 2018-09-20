function Close( self )

if self.IsOpen
    
    FT_STATUS = self.FTDI_Handle.Close; self.Update_FT_STATUS(FT_STATUS);
    fprintf('[%s:%s] : done \n', class(self), mfilename)
    self.IsOpen  = 0;
    self.IsReady = 0;
    
else
    fprintf('[%s:%s] : not opened \n', class(self), mfilename)
    FT_STATUS = self.FTDI_Handle.Close; % still try to close it
end

end % function
