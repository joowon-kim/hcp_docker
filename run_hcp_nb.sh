#!/bin/sh

#CMD_DOCKER=nvidia-docker
CMD_DOCKER=docker
CONTAINER=hcp

if [ $# -eq 0 ]; then
    CMD="$CONTAINER bash"
else
    CMD=$@
fi

DN_DATA_SRC=${HOME}/data
DN_DATA_DOCKER=/data
DN_COEFF=${HOME}/resource

BD_PGM=/Users/joowon/docker/pgm
DN_FREESURFER=${BD_PGM}/freesurfer
DN_HCP=${BD_PGM}/HCPpipelines
DN_FIX=${BD_PGM}/fix
DN_WORKBENCH=${BD_PGM}/workbench

$CMD_DOCKER run -ti --rm \
    --user $(id -u):$(id -g) \
    -v ${DN_FREESURFER}:/usr/local/freesurfer:ro \
    -v ${DN_HCP}:/usr/local/HCPpipelines:ro \
    -v ${DN_FIX}:/usr/local/fix:ro \
    -v ${DN_WORKBENCH}:/usr/local/workbench:ro \
    -v ${DN_COEFF}:/resource:ro \
    -v ${DN_DATA_SRC}:${DN_DATA_DOCKER} \
    $CMD

