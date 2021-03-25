
PACKAGE_PATH=/data/jenkins
DOCKER_SERVER=10.2.55.115
ENBCU_TAG="ENBCU-R_6_0_10_0"

cd $PACKAGE_PATH

ls -lrt

cd $ENBCU_TAG

ls -lrt

docker images|grep none|awk '{print $3}'|xargs docker rmi
docker rmi  $(docker images | grep $ENBCU_TAG | awk '{print $3}')

cd /var/tmp/
rm -rf docker*

ls -lrt


