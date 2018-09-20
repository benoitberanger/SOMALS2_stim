function Start( self , channel )

self.AssertIsOpen
self.AssertIsReady

msg = {'C0' , '00' , '02' , num2str(channel) , dec2hex(self.Value,2) , 'C1'};

[ FT_STATUS , numBytesWritten ] = self.FTDI_Handle.Write(  uint8(hex2dec(msg)) , uint32(length(msg)), uint32(0)); self.Update_FT_STATUS(FT_STATUS);

end % function
