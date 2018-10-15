function GenRect( self )

txtbounds = Screen('TextBounds',self.wPtr,self.content);

[xoffset, yoffset] = RectCenter(txtbounds);

self.Xptb = self.X - xoffset;
self.Yptb = self.Y - yoffset;

end % function