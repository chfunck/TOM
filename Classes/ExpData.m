classdef ExpData	
    
	properties 
        %Parameters of experimental data
        
        % Material name e.g. PbS
        mat_name
        
        % Numeric code of material e.g. 220
        type
        
        % A vector of measuered NC sizes in pixel from the TEM
        pxsizes
        
        % Averaged size of pxsizes
        apxsize
        
        % Averaged diameter of the NCs in nm
        size
        
        % Scale in pixels measuered from the TEM
        pxscale
        
        % Labeled scale of TEM in nm
        scale
        
        % Absorption measurements 
        %   1.column: Wavelengths,
        %   2.column: Absorption values
        abs
        
        % Photoluminescence measurements 
        %   1.column: Wavelengths,
        %   2.column: Photoluminescence values
        PL
        
        directory
    end
end