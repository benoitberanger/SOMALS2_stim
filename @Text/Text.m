classdef Text < baseObject
    %TEXT Class to print text in PTB
    
    %% Properties
    
    properties
        
        % Parameters
        
        color
        content
        X
        Y
        
        % Internal variables
        
        Xptb
        Yptb
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        function self = Text( color, content, X, Y )
            % obj = Text( color, content, X, Y )
            
            % ================ Check input argument =======================
            
            % Arguments ?
            if nargin > 0
                
                self.color   = color;
                self.content = content;
                self.X       = X;
                self.Y       = Y;
                
                % ================== Callback =============================
                                
            else
                % Create empty instance
            end
            
        end
        
        
    end % methods
    
    
end % class
