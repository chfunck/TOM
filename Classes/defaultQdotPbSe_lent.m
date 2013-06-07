% default parameters for a qdot

default = Qdot;

default.mat_name                = 'PbSe_lent';       %material_model

default.lattice_type            = 'rocksalt';

default.a0                      = 0.6121;            %lattice constant
default.first_atom              = 'cation';         %atom situated at [0 0 0]

default.open_system             = 0;

default.tb                      = 20;              	%tight-binding order
default.dsp3                    = 30;             	%passivation energy [eV]

default.n_of_modes              = 4;               %number of modes for bandstructure calculation

default.max_bond_def            = 0.1;              %maximum relative bond deformation (should only be changed if very large strain)

default.x                       = [1 0 0];          %transport direction
default.y                       = [0 1 0];          %direction of confinement
default.z                       = [0 0 1];          %direction of confinement

default.CPU_per_vd_point        = 1;

default.NVD                     = 1;				%number of drain voltages Vd=Vdmin:(Vdmax-Vdmin)/(NVD-1):Vdmax
default.Vdmin                   = 0.0;				%absolute minimum drain potential
default.Vdmax                   = 0.0;				%absolute maximum drain pote
default.directory               = [];

%GEOMETRY

default.no_mat                  = 1;				%number of pieces that form the nanowire (channel + oxide)
default.no_channel_mat          = 1;               	%number of pieces that form the nanowire channel
default.no_oxide_mat            = 0;                %number of pieces that form the oxide around the wire  


geo(1) = Geometry();

geo(1).type                 = 'sphere';			%type of material: square or circle
geo(1).cs                   = 'yes';            %does the material determine the nanowire cross section 
geo(1).id                   = 1;
geo(1).radius               = 1.0;              %radius of circle
geo(1).coord                = [0.0 0.0 0.0];	%[xcenter ycenter zcenter]

default.geometry = geo;

