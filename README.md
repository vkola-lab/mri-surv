# Deep learning-driven risk-based stratification of cognitively impaired individuals

We present here code for the above paper. This code is straightforward to run, and has principally been organized in the **main.py** file under mri_surv/

## Initial metadata generation and image processing

Before running this code, please note that the following environments were used to run our code:
- env.yml: this is for the CNN and ViT models
- requirements.yml: this is for the code contained within main.py
- requirements_torch.yml: this is for the code corresponding to the MLP model (contained within the folder mri_surv/simple_mlp/

Please install these environments using conda

next, run from the commandline:
```
git clone https://github.com/vkola-lab/mri-surv
cd mri-surv/mri_surv
conda activate $ENVIRONMENT_NAME
```

## Please note, metadata generation instructions as below will only run if you have the raw data from NACC and ADNI in the correct folders. To obtain this data, please contact ADNI/NACC administrators and apply for data
We utilized the following data time stamps:
- For NACC: A 12042020 timestamp
- For ADNI:
  - We used a registry with a most recently updated time stamp of 2020-04-09
  - The most recent MRI3 datasheet update is 2020-04-04
  - The most recent Demographics datasheet update is 2020-09-09
  - The most recent DX summary sheet update is 2020-04-08
  - The most recent MMSE sheet update is 2020-04-01
  - CSF datasheets used were: UPENNBIOMK10_07_29_19.csv, UPENNBIOMK9_04_19_17.csv

With these files in metadata/data_raw/ADNI/, in order to generate the initial metadata sheet, please run:
`python main.py --makecsv 1`

The flag to run this on NACC is `--test 1`, so: `python main.py --makecsv 1 --test 1`. Note: NACC metadata files must be in the respective NACC folder.

In order to consolidate images and prune your data based on available ADNI images, (images are presumed to be located in a base directory at /data2/MRI_PET_DATA/raw_images/ having been unzipped), please run `python main.py --extractimg`, with or without `--moveraw 1` (this will relocate the raw images to a different directory under /data2/MRI_PET_DATA/).

Adding the flag `--process_image 1` will process the images in Matlab (we used version 2020, as noted in our paper, after downloading SPM12 and CAT12).

In order to generate the data used for pre-training, please run, from the mri_surv directory:
```
>>> from main import create_csv_time_unused, consolidate_dummy_data, ProcessImagesMRIDummy
>>> create_csv_time_unused()
>>> consolidate_dummy_data()
>>> pimd = ProcessImagesMRIDummy()
>>> pimd()
```

In order to generate the data used for AD, please run:
```
from main import consolidate_images_ad, create_csv_time,  ProcessImagesMRIAD
create_csv_time()
consolidate_images_ad()
pimd =  ProcessImagesMRIAD()
pimd()
```

## Next, run code for the MLP
For the MLP, please run the following code after activating the environment environment_torch.yml.
```
>>> main()
>>> from main import create_csv_time_unused, consolidate_dummy_data, ProcessImagesMRIDummy
>>> create_csv_time_unused()
>>> consolidate_dummy_data()
>>> pimd = ProcessImagesMRIDummy()
>>> pimd()
```

In order to generate the data used for AD, please run in the python console:
```
>>> from main import consolidate_images_ad, create_csv_time,  ProcessImagesMRIAD
>>> create_csv_time()
>>> consolidate_images_ad()
>>> pimd =  ProcessImagesMRIAD()
>>> pimd()
```
## Next, run code for the MLP
For the MLP, please run the following code after activating the environment environment_torch.yml, inside the python console:
```
>>> from simple_mlps.mlp_wrappers import main
>>> main()
```

## Run the final code for the CNN and ViT
For CNN, please CD into the ./mri-pet/mri_surv/cgan_m/cnn/ path, then you can
* Pre-train a CNN for transfer learning
```
CUBLAS_WORKSPACE_CONFIG=:4096:8 python pretrain_main.py
```
(The 'CUBLAS_WORKSPACE_CONFIG=:4096:8' is for reproducible results, which is optional)
* Train a CNN for survival prediction
```
CUBLAS_WORKSPACE_CONFIG=:4096:8 python transfer_main.py
```
(You may edit this file by commenting out the loading part if you do not want transfer learning)
* (Optional) Train a Resnet-based CNN for survival prediction
```
CUBLAS_WORKSPACE_CONFIG=:4096:8 python Res_main.py
```

For ViT, please CD into the ./mri-pet/mri_surv/vit/ path, then you can
* Pre-train a ViT for transfer learning
```
CUBLAS_WORKSPACE_CONFIG=:4096:8 python pre_main.py
```
* Train a ViT for survival prediction
```
CUBLAS_WORKSPACE_CONFIG=:4096:8 python vit_main.py
```
(You may edit this file by uncommenting the loading part if you want transfer learning)

For both CNN & ViT, uncommenting the \_dfs functions in the \_main.py files to generate data files for plotting survival curves

Then, in the main folder, open python and use following statements:
```
>>> from statistics.survival_plot_xz import main
>>> main()
```
The figures will be saved in ./mri-pet/mri_surv/figures/supplement_survival/

(Make sure you have all data needed before you generating the plots!)

## Statistics and plots
Finally, to compute statistics based on these results in addition to the MLP results, you may run `python main.py --stats 1`. Of note, you must run the MLP model script before running this code, or you will generate an error.

In addition, R files may be run using R studio or your R interpreter of choice. Please make sure to install the packages listed in our manuscript.
