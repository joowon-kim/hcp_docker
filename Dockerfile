#
# The followings should be mounted:
# /usr/local/freesurfer
# /usr/local/HCPpipelines
# /usr/local/workbench
# /resource : where gradient coefficient files are

# HCP fix:
# compile fix_3_clean and copy it to compiled/Linux/x86_64/


#FROM centos:centos6.8
#FROM nvidia/cuda:10.2-devel-centos7
FROM nvidia/cuda:10.2-devel-centos6

RUN yum update -y && \
    yum install -y wget tcsh bc vim && \
    yum groupinstall -y development && \
    yum install -y zlib-devel bzip2-devel xz-libs unzip && \
    yum install -y openssl-devel sqlite-devel openssl && \
    yum install -y epel-release && \
    yum install -y "@Development Tools" R R-devel && \
    yum install -y libxml2-devel libcurl-devel && \
    yum install -y mesa-libGL mesa-libGLU && \
    yum clean all

RUN mkdir -p /src
WORKDIR /src

# R
RUN yum install centos-release-scl -y && \
    yum upgrade -y && \
    yum install -y devtoolset-6 

ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS=true
ADD install_r_packages.sh /src/

RUN chmod +x /src/install_r_packages.sh && \
    echo "CXX11 = g++ -m64" >> /usr/lib64/R/etc/Makeconf && \
    echo "CXX11FLAGS = -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic" >> /usr/lib64/R/etc/Makeconf && \
    scl enable devtoolset-6 /src/install_r_packages.sh

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
#RUN wget -q https://ssd.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/glnxa64/MCR_R2016b_glnxa64_installer.zip && \
#    wget -q https://ssd.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/glnxa64/MCR_R2016b_Update_6_glnxa64.sh && \
#    mkdir r2016b && cd r2016b && \
#    unzip ../MCR_R2016b_glnxa64_installer.zip && \
#    ./install -mode silent -agreeToLicense yes && \
#    cd .. && \
#    sh ./MCR_R2016b_Update_6_glnxa64.sh -s

#RUN wget -q https://ssd.mathworks.com/supportfiles/downloads/R2017b/deployment_files/R2017b/installers/glnxa64/MCR_R2017b_glnxa64_installer.zip && \
#    mkdir r2017b && cd r2017b && \
#    unzip ../MCR_R2017b_glnxa64_installer.zip && \
#    ./install -mode silent -agreeToLicense yes && \
#    cd ..

# MSM
RUN wget -q https://github.com/ecr05/MSM_HOCR/releases/download/1.0/msm_centos && \
    mv msm_centos /usr/local/bin/msm && \
    chmod ugo+x /usr/local/bin/msm

RUN rm /src/*  /tmp/* -rf

# FSL
#RUN wget -q http://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py && \
#    python fslinstaller.py -d /usr/local/fsl -q && \
RUN mkdir -p /opt/fmrib/ && \
    cd /opt/fmrib/ && \
    ln -s /usr/local/fsl ./ && \
    cd /usr/local && \
    ln -s /mnt/local/usr/fsl-6.0.3_centos6 fsl

RUN mkdir -p /home/user && \
    chmod ugo+rwX /home/user

ENV HOME /home/user
ENV PATH=/usr/local/bin:$PATH
ENV FSL_FIX_R_CMD=/usr/bin/R

# setup files
ENV FSL_FIX_MCRROOT=/usr/local/MATLAB/MATLAB_Runtime
RUN echo "export FREESURFER_HOME=/usr/local/freesurfer" >> $HOME/.bashrc && \
    echo 'source $FREESURFER_HOME/SetUpFreeSurfer.sh' >> $HOME/.bashrc && \
    echo "source /usr/local/HCPpipelines/Examples/Scripts/SetUpHCPPipeline.sh" >> $HOME/.bashrc

VOLUME ["/data"]
WORKDIR /data
CMD bash

