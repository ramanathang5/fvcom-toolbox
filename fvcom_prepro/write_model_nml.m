function res = write_model_nml(conf, nml, fmt)
% Script to create the model run namelist.
%
% res = write_model_nml(conf, nml, fmt)
%
% INPUT
%    conf - struct with the following fields:
%        fvcom_model: directory into which the namelist should be written.
%        casename: casename to use in the file name.
%    nml - namelist inputs struct generated by make_default_nml.
%    fmt - number format struct generated by make_default_nml.
% OUTPUT
%    Model run namelist file.
%
% Author(s)
%    Ricardo Torres (Plymouth Marine Laboratory)
%    Pierre Cazenave (Plymouth Marine Laboratory)
%
% Revision history
%    2017-01-12 First version.
%    2017-02-03 Fix output directory variable use.

if exist(conf.fvcom_model, 'dir') ~= 2
    mkdir(conf.fvcom_model);
end
fname = fullfile(conf.fvcom_model, [conf.casename, '.nml']);
fnml = fopen(fname, 'wt');

nml_blocks = fieldnames(nml);
for nn = 1:length(nml_blocks)
    line = [' &', nml_blocks{nn}];
    fprintf(fnml, '%s\n', line);
    clear line
    nml_vars = fieldnames(nml.(nml_blocks{nn}));
    for vv = 1:length(nml_vars)
        var_value = nml.(nml_blocks{nn}).(nml_vars{vv});
        if ischar(var_value)
            if any(strcmp(var_value, {'T','F'}))
                formatstr = ' %s\t = %s';
                
            else
                formatstr=[' %s\t = ', '''', '%s', ''''];
            end
        else
            formatstr= [' %s\t = ', repmat([fmt.(nml_blocks{nn}).(nml_vars{vv}).format, ','], 1, length(var_value))];
        end
        line = sprintf(formatstr, nml_vars{vv}, var_value);
        fprintf(fnml, '%s\n', line);
        clear line
    end
    fprintf(fnml, ' /\n');
    fprintf(fnml, '\n');
end
res = fclose(fnml);
return