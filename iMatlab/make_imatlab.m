%this is a simple build script for iMatlab
%

MOOS_SRC_ROOT = '/Users/pnewman/code/CompactMOOSProjects/CoreMOOS/Core/libMOOS';
MOOS_LIB_DIR = '/Users/pnewman/code/CompactMOOSProjects/CMB/bin';

include_dirs = [];
if(ismac || isunix)
    [status,stdio] = system('cmake ./build_help');
    if(status~=0)
        disp(stdio);
        error('CMake invocation failed')
    end;
    stdio = regexp(stdio, '[\f\n\r]', 'split');
    for i = 1:length(stdio)
        if(length(stdio{i})~=0)            
            %is this an include path
            t = textscan(stdio{i}, 'INCLUDE:%s'); 
            theline = char(t{1});
            if(~isempty(theline))
                tok = 'libMOOS/include';
                j = strfind(theline,tok);
                if(~isempty(j))                   
                    [include_root, last_part, ext] = fileparts(theline);
                end
            end;

            %is is library path
            t = textscan(stdio{i}, 'LIB:%s');                        
            theline = char(t{1});
            if(~isempty(theline))
                [library_path, library_name, ext] = fileparts(theline) ;
            end;
        end;
    end;
    
    
end;

fprintf('   found includes at %s\n',include_root)
fprintf('   found library  at %s\n',library_path)
fprintf('   library name is   %s(%s)\n',library_name,ext)

reply = input('\ndo these look right? [Y/n]\n', 's');
if(isempty(reply))
    reply = 'y';
end
if(lower(reply)~='y')
    return 
end




components = {'App','Comms', 'Utils'};
include_directive = [' -I',include_root,'/include'];
for(i = 1:length(components))
    new_path = [' -I',include_root,'/',components{i},'/include'];
    include_directive= [include_directive, new_path];
    fprintf(' adding directive %s\n',new_path)
end;


cmd = ['mex ', include_directive,  ' -L', library_path, ' -lMOOS',' iMatlab.cpp mexHelpers.cpp'];

fprintf('\nAbout to invoke mex compiler does this directive\n  %s \n\n',cmd);
reply = input('Does this look right? [Y/n]\n\n', 's');
if(isempty(reply))
    reply = 'y';
end
if(lower(reply)~='y')
    return 
end


fprintf('compiling.....')
eval(cmd)
