addpath('/users/modellers/pica/Code/MATLAB/toolboxes/m2html')

m2html('mfiles',{'fvcom_postproc','fvcom_prepro','utilities','swan_scripts','tests/utilities','tests/fvcom_prepro'},'htmldir','doc','graph', 'on');
