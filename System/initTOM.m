%% Initializing Process
%  Update directories, set root directory

global config;

config.root 	= 'ENTER PATH HERE';
config.user     = getenv('USER');
config.machine  = getenv('HOSTNAME');

config.OMEN         = [config.root, 'ENTER PATH HERE']; %path of the OMEN executable
config.experimentalData = [config.root, 'ENTER PATH HERE']; % path of the folder containing exp data
config.simulations  = [config.root, 'ENTER PATH HERE']; %path of the simulations folder
config.vOMEN        = ''; %OMEN version

if exist(config.simulations) == 0
    mkdir(config.simulations)
end

addpath(genpath(config.root))
cd(config.root)