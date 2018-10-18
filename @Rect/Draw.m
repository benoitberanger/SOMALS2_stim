function Draw( self )

self.AssertReady

Screen('FillRect' , self.wPtr, self.currentFillColor , self.currentRect);
Screen('FrameRect', self.wPtr, self.currentFrameColor, self.currentRect, self.thickness);

end % function
