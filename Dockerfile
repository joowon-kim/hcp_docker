#
# The followings should be mounted:
# /usr/local/freesurfer
# /usr/local/HCPpipelines
# /usr/local/workbench
# /resource : where gradient coefficient files are

# HCP fix:
# compile fix_3_clean and copy it to compiled/Linux/x86_64/


#FROM centos:centos6.8
FROM nvidia/cuda:7.5-devel-centos6

RUN yum update -y

# for fsl, hcp, freesurfer
RUN yum install -y wget tcsh bc
RUN yum install -y zlib-devel bzip2-devel xz-libs unzip
RUN yum groupinstall -y development && \
    yum install -y openssl-devel sqlite-devel openssl

# for R
RUN yum install -y epel-release
RUN yum install -y "@Development Tools" R R-devel
RUN yum install -y libxml2-devel libcurl-devel

# for workbench
RUN yum install -y mesa-libGL mesa-libGLU

#
RUN yum install -y vim

RUN yum clean all

RUN mkdir -p /src
WORKDIR /src

ENV PATH=/usr/local/bin:$PATH

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
    rm /src/* -rf

RUN pip install -U pip && \
    pip install -U setuptools && \
    pip install numpy && \
    pip install scipy && \
    pip install nibabel

# FSL
RUN wget -q http://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py
# specify version if necessary
RUN python fslinstaller.py -d /usr/local/fsl -q

# legacy FSL
RUN mkdir -p /opt/fmrib/ && \
    cd /opt/fmrib/ && \
    ln -s /usr/local/fsl ./

# gradient unwarp
RUN wget -q https://github.com/Washington-University/gradunwarp/archive/v1.1.0.tar.gz
RUN tar -zxf v1.1.0.tar.gz && \
    cd gradunwarp-1.1.0/ && \
    python setup.py install && \
    rm /src/* -rf

# R
RUN mkdir -p /usr/share/doc/R-3.5.2/html/
RUN mkdir -p /usr/lib64/R/library/class/html/

RUN echo 'install.packages("devtools", repos="http://cran.us.r-project.org")' | R --no-save
RUN echo 'require(devtools); install_version("kernlab", version="0.9-24", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE)' | R --no-save
RUN echo 'require(devtools); install_version("ROCR", version="1.0-7", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE)' | R --no-save
RUN echo 'require(devtools); install_version("class", version="7.3-14", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE)' | R --no-save
RUN echo 'require(devtools); install_version("mvtnorm", version="1.0-8", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE)' | R --no-save
RUN echo 'require(devtools); install_version("multcomp", version="1.4-8", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE)' | R --no-save
RUN echo 'require(devtools); install_version("coin", version="1.2-2", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE)' | R --no-save
RUN echo 'require(devtools); install_version("strucchange", version="1.5-1", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE)' | R --no-save
RUN echo 'require(devtools); install_version("libcoin", version="1.0-5", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE)' | R --no-save
RUN echo 'require(devtools); install_version("matrixStats", repos="https://cran.us.r-project.org")' | R --no-save
RUN echo 'require(devtools); install_version("party", version="1.0-25", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE, dependencies=FALSE)' | R --no-save
RUN echo 'require(devtools); install_version("e1071", version="1.6-7", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE)' | R --no-save
RUN echo 'require(devtools); install_version("randomForest", version="4.6-12", repos="https://cran.us.r-project.org", upgrade_dependencies=FALSE)' | R --no-save

ENV FSL_FIX_R_CMD=/usr/bin/R

# Matlab runtime library
RUN wget -q https://ssd.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/glnxa64/MCR_R2016b_glnxa64_installer.zip
RUN wget -q https://ssd.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/glnxa64/MCR_R2016b_Update_6_glnxa64.sh
RUN mkdir r2016b && cd r2016b && \
    unzip ../MCR_R2016b_glnxa64_installer.zip && \
    ./install -mode silent -agreeToLicense yes && \
    cd .. && \
    sh ./MCR_R2016b_Update_6_glnxa64.sh -s

RUN wget -q https://ssd.mathworks.com/supportfiles/downloads/R2017b/deployment_files/R2017b/installers/glnxa64/MCR_R2017b_glnxa64_installer.zip
RUN mkdir r2017b && cd r2017b && \
    unzip ../MCR_R2017b_glnxa64_installer.zip && \
    ./install -mode silent -agreeToLicense yes && \
    cd ..

RUN rm /src/* -rf
RUN rm /tmp/* -rf

# MSM
RUN wget -q https://github.com/ecr05/MSM_HOCR/releases/download/1.0/msm_centos
RUN mv msm_centos /usr/local/bin/msm
RUN chmod ugo+x /usr/local/bin/msm

# setup files
ENV FSL_FIX_MCRROOT=/usr/local/MATLAB/MATLAB_Runtime
RUN echo "export FREESURFER_HOME=/usr/local/freesurfer" >> $HOME/.bashrc
RUN echo 'source $FREESURFER_HOME/SetUpFreeSurfer.sh' >> $HOME/.bashrc
RUN echo "source /usr/local/HCPpipelines/Examples/Scripts/SetUpHCPPipeline.sh" >> $HOME/.bashrc

VOLUME ["/data"]
WORKDIR /data
CMD bash

