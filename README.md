# Docker recipe for HCP pipeline 4.2.2-rc2

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

## Installation
### pull docker image
```
docker pull joowon/hcp_docker:4.2.2-rc.2
```

### or, build docker image
```
docker build -t hcp_docker:4.2.2-rc2 .
```

## Installation outside docker:
Run `create_hcp_docker.sh` to download programs that will be stored outside a container.

* Freesurfer 6.0.1 (https://surfer.nmr.mgh.harvard.edu)
    * Locate Freesurfer license file in the freesurfer directory.
* HCP pipeline 4.2.2-rc2 (https://github.com/Washington-University/HCPpipelines)
* FSL FIX (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FIX)
* Workbench (https://www.humanconnectome.org/software/connectome-workbench)
* gradient coefficient file from scanner

## check `run_hcp.sh` file created by `create_hcp_docker.sh`

