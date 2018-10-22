function StartTimer ( self ) 

self.AssertIsOpened();

assert( ~isempty(self.timer), '[%s:%s] : timer not defined \n', class(self), mfilename)

start(self.timer);

fprintf('[%s:%s] : done \n', class(self), mfilename)

end 
