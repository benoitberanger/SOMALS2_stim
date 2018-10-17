classdef Rect < baseObject
    %RECT Class to prepare and draw a Rect in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        baseRect    = zeros(0,4) % [R G B a] from 0 to 255
        currentRect = zeros(0,4) % [R G B a] from 0 to 255
        
        baseFrameColor    = zeros(0,4) % [R G B a] from 0 to 255
        currentFrameColor = zeros(0,4) % [R G B a] from 0 to 255
        
        baseFillColor     = zeros(0,4) % [R G B a] from 0 to 255
        currentFillColor  = zeros(0,4) % [R G B a] from 0 to 255
        
        % Internal variables
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        function self = Rect( rect, framecolor, fillcolor )
            
            % ================ Check input argument =======================
            
            % Arguments ?
            if nargin > 0
                

                % --- rect ----
                assert( isvector(rect) && isnumeric(rect) , ...
                    'rect = [x1 y1 x2 y2] ' )
                
                % --- framecolor ----
                assert( isvector(framecolor) && isnumeric(framecolor) && all( uint8(framecolor)==framecolor ) , ...
                    'color = [R G B a] from 0 to 255' )
                
                % --- fillcolor ----
                assert( isvector(fillcolor) && isnumeric(fillcolor) && all( uint8(fillcolor)==fillcolor ) , ...
                    'color = [R G B a] from 0 to 255' )
                
                self.baseRect          = rect      ;
                self.currentRect       = rect      ;
                self.baseFrameColor    = framecolor;
                self.currentFrameColor = framecolor;
                self.baseFillColor     = fillcolor ;
                self.currentFillColor  = fillcolor ;
                
                % ================== Callback =============================
                                
            else
                % Create empty instance
            end
            
        end
        
        
    end % methods
    
    
end % class
