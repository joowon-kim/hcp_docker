#!/bin/bash

CMD_DOCKER=docker
CONTAINER=hcp_docker:4.2.2-rc.2

read -p "Type the data directory [$HOME/data]: " DN_DATA_SRC
read -p "Type the directory containing gradient coefficient files [$HOME/resource]: " DN_COEFF
read -p "Type the base directory to store external programs (e.g., $HOME/hcp_docker_pgm) [./]: " DN_PGM

if [ X"$DN_DATA_SRC" == X ]; then
    DN_DATA_SRC=$HOME/data
fi

if [ X"$DN_COEFF" == X ]; then
    DN_COEFF=$HOME/resource
fi

if [ X"$DN_PGM" == X ]; then
    DN_PGM=`pwd`
else
    if [ ! `mkdir -p $DN_PGM` ]; then
        echo "Failed to create $DN_PGM"
        exit 1
    fi
fi

sed -e "s#VAR_CONTAINER#${CONTAINER}#g" \
    -e "s#VAR_BD_PGM#${BD_PGM}#g" \
    -e "s#VAR_DN_DATA_SRC#${DN_DATA_SRC}#g" \
    -e "s#VAR_DN_COEFF#${DN_COEFF}#g" \
    run_hcp.template > run_hcp.sh

chmod +x run_hcp.sh

echo ""
echo "Starting downloading programs..."

CURR=`pwd`
cd $DN_PGM
sh ${CURR}/download_req.sh
rm -f *.tar.gz *.zip

cd $CURR

echo "Download done."
echo ""
echo "Run the following to build a HCP docker container"
echo "docker build -t $CONTAINER ."

