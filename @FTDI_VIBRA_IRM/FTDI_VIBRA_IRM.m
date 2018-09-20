classdef FTDI_VIBRA_IRM < handle
    %FTDI_VIBRA_IRM to command Technoconcept VIBRA IRM
    
    
    %% Properties
    
    properties
        
        FTD2XX_NET_dll_path = 'C:\FTD2XX_NET.dll'
        FTDI_Handle
        FT_STATUS
        IsOpen              = 0
        IsReady             = 0
        Value               = 55; % [0-100] : percentage(%) of valve opened
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        
        function self = FTDI_VIBRA_IRM( DLL_path )
            
            if nargin
                assert( exist( DLL_path , 'file') == 2 , 'Not a valide file : %s', DLL_path)
                self.FTD2XX_NET_dll_path = DLL_path;
            end
            
            % Place dll in directory of your choice.
            NET.addAssembly(self.FTD2XX_NET_dll_path);
            
        end % function : ctor
        
    end % methods
    
end % classdef
