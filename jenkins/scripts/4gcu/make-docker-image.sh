#?/bin/bash
PACKAGE_PATH=/data/jenkins
DOCKER_SERVER=10.2.55.115
ENBCU_TAG="ENBCU-R_6_0_10_0"

cd $PACKAGE_PATH

cd $ENBCU_TAG

cp ../build_docker_image.sh ./

PACKAGE_NAME=$(ls -lt ./ | grep ENBCUCP | head -n 1 |awk '{print $9}')

./build_docker_image.sh $PACKAGE_NAME mone-rhel7.6:v8
sleep 1

FOLDER_NAME=$(ls -lt ./ | grep ENBCUCP | head -n 1 |awk '{print $9}')

cd $FOLDER_NAME

DOCKER_IMAGE=$(ls -lrt | grep docker |awk '{print $9}');

docker load -i $DOCKER_IMAGE

REPOSITORY=${$DOCKER_IMAGE%"-FDD"*}
TAG=${$DOCKER_IMAGE#*"ENBCU-"}
TAG=${$TAG%"-docker"*}

REPOSITORY="$(echo $REPOSITORY | tr '[:upper:]' '[:lower:]')"

TAG="$(echo $TAG | tr '[:upper:]' '[:lower:]')"

echo $REPOSITORY:$TAG



docker tag localhost/$REPOSITORY:$TAG $DOCKER_SERVER:5000/enbcucp:$ENBCU_TAG-$BUILD_TAG-$JENKINS_IMG_TAG

docker push $DOCKER_SERVER:5000/enbcucp:$ENBCU-$BUILD_TAG-$JENKINS_IMG_TAG
docker images

sleep 5
