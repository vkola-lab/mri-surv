% List of open inputs
% File Selector (Batch Mode): Directory - cfg_files
% File Selector (Batch Mode): Filter - cfg_entry
% File Selector (Batch Mode): Descend into subdirectories - cfg_menu
nrun = X; % enter the number of runs here
jobfile = {'/home/mfromano/Research/mri-pet/end_to_end_process_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(3, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % File Selector (Batch Mode): Directory - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % File Selector (Batch Mode): Filter - cfg_entry
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % File Selector (Batch Mode): Descend into subdirectories - cfg_menu
end
spm('defaults', 'PET');
spm_jobman('run', jobs, inputs{:});
