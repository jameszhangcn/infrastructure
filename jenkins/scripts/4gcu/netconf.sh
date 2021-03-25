#?/bin/bash

MME_PATH="/home/jenkins/"
ENBCU_TAG="ENBCU-R_6_0_10_0"

cd $MME_PATH
cd $ENBCU_TAG/sm_netconf/
./netconf-data-config-sm.sh
sleep 1
./netconf-endindicator-sm.sh
cd $MME_PATH
cd $ENBCU_TAG/cu_netconf
sleep 3
./netconf-data-config-cu.sh
sleep 1
./netconf-endindicator-cu.sh
sleep 1
pwd
ls -lrt

