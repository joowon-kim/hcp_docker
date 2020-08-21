#!/bin/sh

wget -q -O freesurfer.tar.gz https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.1/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.1.tar.gz
tar -zxf freesurfer.tar.gz
touch freesurfer/freesurfer-6.0.1

wget -q -O workbench.zip https://www.humanconnectome.org/storage/app/media/workbench/workbench-rh_linux64-v1.4.2.zip
unzip workbench.zip
touch workbench/workbench-rh_linux64-v1.4.2

wget -q -O fix.tar.gz http://www.fmrib.ox.ac.uk/~steve/ftp/fix.tar.gz
tar -zxf fix.tar.gz

wget -q -O hcp_pipeline.tar.gz https://github.com/Washington-University/HCPpipelines/archive/v4.2.2-rc.2.tar.gz
tar -zxf hcp_pipeline.tar.gz
touch HCPpipelines-4.2.2-rc.2/HCPpipelines-4.2.2-rc.2
mv HCPpipelines-4.2.2-rc.2 HCPpipelines

sed -i  \
    -e 's/\<export MSMBINDIR/#export MSMBINDIR/g'   \
    -e 's/\<export MATLAB_COMPILER_RUNTIME/#export MATLAB_COMPILER_RUNTIME/g' \
    -e 's/\<export FSL_FIXDIR/#export FSL_FIXDIR/g' \
    -e 's/\<export CARET7DIR/#export CARET7DIR/g' \
    HCPpipelines/Examples/Scripts/SetUpHCPPipeline.sh

