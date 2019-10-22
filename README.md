# Docker recipe for HCP pipeline 4.0.1

Docker recipe to run
* PreFreeSurfer
* FreeSurfer
* PostFreeSurfer
* fMRIVolume
* fMRISurface
* ICAFIX (`hcp_fix_multi_run`)
* TaskfMRIAnalysis
with MSMSulc.
Other pipelines were not tested yet.


## Prerequisite

### License
* FSL: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki
* Freesurfer: https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall

### Installation outside docker:
Download the following packages and unzip them. They will be mapped into the docker container.

* Freesurfer 6.0 (https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz)
    * Locate Freesurfer license file in the freesurfer directory.
* HCP pipeline 4.0.1 (https://github.com/Washington-University/HCPpipelines/archive/v4.0.1.tar.gz)
* FSL FIX (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FIX)
* Workbench (https://www.humanconnectome.org/software/connectome-workbench)
* gradient coefficient file from scanner

### modify HCP pipeline setup file (`HCPpipelines/Examples/Scripts/SetUpHCPPipeline.sh`)
Modify the following lines
```
export HCPPIPEDIR="/usr/local/HCPpipelines"
export MSMBINDIR="/usr/local/bin"
export MATLAB_COMPILER_RUNTIME="/usr/local/MATLAB/MATLAB_Runtime/v91"
export FSL_FIXDIR="/usr/local/fix"
export CARET7DIR="/usr/local/workbench/bin_rh_linux64"
```

### compile `fix_3_clean.m` file in FSL FIX
Compiled version of `fix_3_clean` in current FIX (v1.068) does not include gifti library. So, 1) compile `fix_3_clean` with MATLAB 2017b or 2) compile all FIX matlab files with your MATLAB version

* Prepare linux environment with MATLAB 2017b installed
* Remove symbolic link in HCP Pipeline (`HCPpipelines/global/matlab/@gifti`)
* Modify settings.sh in FSL FIX directory:
```
FSL_FIX_CIFTIRW=${directory_to_HCPpipelines}/global/matlab
```
* Modify Makefile in FSL FIX direcotry:
```
fix_3_clean: fix_3_clean.m
-	${FSL_FIX_MCC} $(MCCOPTS) -I ${FSL_FIX_FSLMATLAB} -I ${FSL_FIX_CIFTIRW} -I ${FSL_FIX_CIFTIRW}/gifti-1.6 -d ${FSL_FIX_MLCDIR} $<
```
* 1) Compile `fix_3_clean.m` in FSL FIX directory:
```
make fix_3_clean
```

* or 2) Compile all MATLAB files:
```
./build_MATLAB
```

* If you did option 2) and compiled them with MATLAB version other than 2017b or 2016b, modify Dockerfile to install proper MATLAB runtime library instead of 2017b (keep 2016b in Dockerfile).

## Installation
### build docker image
```
docker built -t hcp .
```

### modify `run_hcp_nb.sh` file
* Modify the following variables to map them into docker container
```
DN_DATA_SRC=${HOME}/data
DN_DATA_DOCKER=/data
DN_COEFF=${HOME}/resource

BD_PGM=${HOME}/docker/pgm
DN_FREESURFER=${BD_PGM}/freesurfer
DN_HCP=${BD_PGM}/HCPpipelines
DN_FIX=${BD_PGM}/fix
DN_WORKBENCH=${BD_PGM}/workbench
```
