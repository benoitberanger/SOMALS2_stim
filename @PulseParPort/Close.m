function Close ( self )

if self.IsOpened
   CloseParPort();
   self.status = false;
   fprintf('[%s:%s] : done \n', class(self), mfilename)
else
    warning('[%s:%s] : not opened \n', class(self), mfilename)
end

end % function
