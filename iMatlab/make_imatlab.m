%this is a simple build script for iMatlab
%

MOOS_SRC_ROOT = '/Users/pnewman/code/CompactMOOSProjects/CoreMOOS/Core/libMOOS';
MOOS_LIB_DIR = '/Users/pnewman/code/CompactMOOSProjects/CMB/bin';


components = {'include','Comms/include','Utils/include'};

inc = [];
for i = 1:length(components)
    inc = [inc, ' -I', MOOS_SRC_ROOT, '/', components{i}] ;
end;
cmd = ['mex ', inc,  '-L', MOOS_LIB_DIR, ' -lMOOS',' iMatlab.cpp mexHelpers.cpp']
eval(cmd)