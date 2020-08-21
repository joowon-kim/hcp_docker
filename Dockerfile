#
# The followings should be mounted:
# /usr/local/freesurfer
# /usr/local/HCPpipelines
# /usr/local/workbench
# /usr/local/fix
# /resource : where gradient coefficient files are

#FROM centos:centos6.8
FROM nvidia/cuda:10.2-devel-centos7
#FROM nvidia/cuda:10.2-devel-centos6

RUN yum update -y && \
    yum install -y wget tcsh bc vim && \
    yum groupinstall -y development && \
    yum install -y zlib-devel bzip2-devel xz-libs unzip && \
    yum install -y openssl-devel sqlite-devel openssl && \
    yum install -y epel-release && \
    yum install -y "@Development Tools" R R-devel && \
    yum install -y libxml2-devel libcurl-devel && \
    yum install -y mesa-libGL mesa-libGLU && \
    yum install -y openblas-devel.x86_64 && \
    yum clean all

RUN mkdir -p /src
WORKDIR /src

# R
#RUN yum install centos-release-scl -y && \
#    yum upgrade -y && \
#    yum install -y devtoolset-6 

ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS=true
ADD install_r_packages.sh /src/

RUN chmod +x /src/install_r_packages.sh && \
    /src/install_r_packages.sh
#    echo "CXX11 = g++ -m64" >> /usr/lib64/R/etc/Makeconf && \
#    echo "CXX11FLAGS = -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic" >> /usr/lib64/R/etc/Makeconf && \
#    scl enable devtoolset-6 /src/install_r_packages.sh

# Python
RUN wget -q https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz && \
    tar -zxf Python-2.7.13.tgz && \
    cd Python-2.7.13 && \
    ./configure --prefix=/usr/local && \
    make && make altinstall && \
    cd /usr/local/bin && \
    ln -s python2.7 python && \
    rm /src/* -rf

# python pip
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python2.7 get-pip.py && \
    rm /src/* -rf && \
    pip install -U pip && \
    pip install -U setuptools && \
    pip install numpy && \
    pip install scipy && \
    pip install nibabel

# gradient unwarp
RUN wget -q https://github.com/Washington-University/gradunwarp/archive/v1.1.0.tar.gz && \
    tar -zxf v1.1.0.tar.gz && \
    cd gradunwarp-1.1.0/ && \
    python setup.py install && \
    rm /src/* -rf


# Matlab runtime library
RUN wget -q https://ssd.mathworks.com/supportfiles/downloads/R2017b/deployment_files/R2017b/installers/glnxa64/MCR_R2017b_glnxa64_installer.zip && \
    mkdir r2017b && cd r2017b && \
    unzip ../MCR_R2017b_glnxa64_installer.zip && \
    ./install -mode silent -agreeToLicense yes && \
    cd .. && \
    rm -rf r2017b MCR_R2017b_glnxa64_installer.zip

# MSM
RUN wget -q -O /usr/local/bin/msm https://github.com/ecr05/MSM_HOCR/releases/download/v3.0FSL/msm_centos_v3 && \
    chmod ugo+x /usr/local/bin/msm

RUN rm /src/*  /tmp/* -rf

# FSL
RUN wget -q http://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py && \
    python fslinstaller.py -d /usr/local/fsl -q

RUN mkdir -p /home/user && \
    chmod ugo+rwX /home/user

RUN rm /src/*  /tmp/* -rf

# setup env

ENV HOME /home/user
ENV PATH=/usr/local/bin:$PATH:/usr/local/hcp_script
ENV FSL_FIX_R_CMD=/usr/bin/R

ENV FSLDIR="/usr/local/fsl"
ENV FSL_FIXDIR="/usr/local/fix"
ENV FSL_FIX_MATLAB_MODE="0"
ENV FSL_FIX_MCRROOT="/usr/local/MATLAB/MATLAB_Runtime"

ENV MSMBINDIR="/usr/local/bin"
ENV MATLAB_COMPILER_RUNTIME="/usr/local/MATLAB/MATLAB_Runtime/v93"
ENV HCPPIPEDIR="/usr/local/HCPpipelines"
ENV CARET7DIR="/usr/local/workbench/bin_rh_linux64"
ENV FREESURFER_HOME="/usr/local/freesurfer"

RUN echo 'source $FREESURFER_HOME/SetUpFreeSurfer.sh' >> $HOME/.bashrc && \
    echo 'source $HCPPIPEDIR/Examples/Scripts/SetUpHCPPipeline.sh' >> $HOME/.bashrc

VOLUME ["/data"]
WORKDIR /data
CMD bash

