#?/bin/bash
ENBCU_BRANCH="release/vbbu-6.0"
ENBCU_TAG="ENBCU-R_6_0_10_0"
PLATFORM_TAG="ENBCU-R_6_0_10_0"
JENKINS_PATH="/home/zhangji/jenkins"
PLATFORM="rhel_7_6_x86_64"
BUILD_RESULT="success"
DOCKER_SERVER="10.2.55.115"

function prepare_mmx()
{
        echo -e "1\n" | mav-cvsco.pl ln -t $PLATFORM_TAG
	cd $PLATFORM_TAG/rhel_7_6_x86_64/mmx
	mav-cvsco.pl dl oam common inc
	cd ..
	rm -rf bbu
	git clone ssh://git@at.mavenir.com:7999/cran/bbu.git
	cd bbu
        if [ $ENBCU_TAG=="" ]; then
            git checkout $ENBCU_BRANCH
        else
	    git checkout $ENBCU_TAG
        fi
}

function build_image()
{
    cd $JENKINS_PATH
    cd $ENBCU_TAG
    cd $PLATFORM
    rm -rf *.tar.gz
    cd bbu
    git pull
    TIME_STAMP=$(date +%Y%m%d-%H%M%S)
    IMAGE_TAG=$(git rev-parse --short HEAD)
    JENKINS_IMAGE_TAG=$TIME_STAMP"-"$IMAGE_TAG
    echo "JENKINS_IMAGE_TAG: $JENKINS_IMAGE_TAG"

    export SKIP_PLATFORM=1
    export SKIP_BUILD_VPP=1
    export SKIP_VENDOR=1
    export PATH=$PATH:./
    nohup ./BUILD_CU RHEL_7_6_X86_64 FDD ENBCUCP-${PLATFORM_TAG#*-}-$JENKINS_IMAGE_TAG >build_cu.log 2>&1 &
}

function wait_build_ready()
{
count=0;
while((1))
do
    if cat 'build_cu.log' | grep "successfully generated" > /dev/null
    then
        echo "build ENBCU package success"
        break
    fi
    sleep 60
    echo "building $count min ..."
    ((count++))
    if [ $count -gt 60 ]; then
        echo "build timer exceed 100min"
        cat build_cu.log
        BUILD_RESULT="failed"
        break
    fi
done
}

function copy_image()
{
    cd $JENKINS_PATH
    cd $ENBCU_TAG
    cd $PLATFORM
    rsync -rvl rhel_7_6_x86_64-ENBCU-FDD-ENBCUCP-${PLATFORM_TAG#*-}-XRAN.tar.gz root@$DOCKER_SERVER:/data/jenkins/$ENBCU_TAG/$BUILD_TAG/
}

#main
echo $PATH
cd $JENKINS_PATH
if [ ! -d $PLATFORM_TAG ];then
	echo "directory not exsit"
	#mkdir $ENBCU_TAG
	#cd $ENBCU_TAG
	#prepare the platform
	prepare_mmx
	else
	echo "$PLATFORM_TAG already exist"
fi

build_image
wait_build_ready

if [ $BUILD_RESULT=="success" ]; then
	echo "build success"
        copy_image
    else
        echo "build failed"
fi

echo "build ENBCU package end"     
