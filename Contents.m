% **********************************************************************************
% TOOLBOX for OMEN in MATLAB (TOM)
% Version: 0.1 stable      - July 5th 2013
% **********************************************************************************
% 
% GENERAL
%   initTOM                - Intitialize the Toolbox
%   <a href="matlab: open TOMmanual.pdf">TOM Manual</a>             - Detailed information for user & maintainer
% 
% GRAPHICAL USER INTERFACE
%   <a href="matlab: gui_simulate">gui_simulate</a>           - Start simulation tasks
%   <a href="matlab: gui_db">gui_db</a>                 - Display all database entries
%                            Sort and filter the entries
%                            Select entries and export them as an QDOA
%                            Open entires
%                            Delete entries
%                            Plotting with default values
% 
% PLOTTING
%   compareEV              - Plot EV along axis for multiple directions
%   plotAbs                - Plot absorbtion spectrums of experimental data
%   plotBandGap            - Plot bandgaps against radius, voltage
%   plotEnergyLevels       - Plot energy levels
%   plotEV3D               - Plot wavefunctions in 3D
%   plotEV3DcrossSection   - Plot wavefunctions in 3D
%                            2 cross sections for VB and CB modes in one figure
%   plotEV3Dmax            - Plot atoms with high probabilities
%   plotEVAlongAxis        - Plot the EVs of an QDOA along specified line
%   plotEvsField           - Plot energy levels againts applied electric field
%   plotPL                 - Plot photoluminescence of experimental data
%   plotQDStructure        - Plot the structure of specific quantum dots in 3D
%   plotVoltBandGap        - Plot the bandgap against voltage for a constant radius
% 
% DATA HANDLING
%   simAll                 - Simulate a quantum dot manually
%   deleteSimData          - Delete simulation folders and their contents
%   filterQDOA             - Filter the database or an QDOA
%   getBandGap             - Get the bandgap of a QDO
%   getEDOA                - Create an array of EDO from all experimental data
%   getQDOA                - Create an array of QDO from all simulation folders
%   removeDuplicates       - Returns an QDOA of redundant simulation data
%   removeFailed           - Remove directories of failed simulations
%   updateProperty         - Update a property of simulation data
%   
% by  Dittberner, Matthias   mdittber@student.ethz.ch
%     Funck, Christian       cfunck@student.ethz.ch