function Write ( self, msg )

self.AssertIsOpened();

WriteParPort( msg );

self.last_msg = msg;

end % function
