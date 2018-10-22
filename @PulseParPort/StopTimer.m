function StopTimer ( self ) 

self.AssertIsOpened();

assert( ~isempty(self.timer), '[%s:%s] : timer not defined \n', class(self), mfilename)

stop(self.timer);

fprintf('[%s:%s] : done \n', class(self), mfilename)

end 
