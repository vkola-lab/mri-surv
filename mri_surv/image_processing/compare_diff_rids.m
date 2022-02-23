function fnames = compare_diff_rids(raw_nifti_folder, folder_name, rid_list)
if ~exist(folder_name,'dir')
    mkdir(folder_name);
end

listing = dir(raw_nifti_folder);
fnames = {};
for i=1:length(listing)
   if ~listing(i).isdir && strcmp(listing(i).name(end-3:end), '.nii')
        rid = regexp(listing(i).name,'^([0-9]{4}).*\.nii$','tokens');
        if ismember(rid{1},rid_list)
            rid = regexp(listing(i).name,'^([0-9]{4}).*\.nii$','tokens');
            prev = spm_vol(['/data2/MRI_PET_DATA/processed_images_spm/ADNI_MRI_nii_recenter_original/' rid{1}{1} '_mri.nii']);
            data2 = spm_read_vols(prev);
            if ~isequaln(data,data2)
                disp([rid{1}{1} ' not equal']);
            end
        else
            disp(['file ' listing(i).name ' not in list of RIDs'])
        end
end

end