#?/bin/bash

ENBCU_BRANCH="release/vbbu-6.0"
ENBCU_TAG="ENBCU-R_6_0_10_0"
PLATFORM_TAG="ENBCU-R_6_0_10_0"
PLATFORM="rhel_7_6_x86_64"
BUILD_RESULT="success"
DOCKER_SERVER="10.2.55.115"
CP_DOCKER_IMAGE="10.2.55.115:5000/enbcucp:6090-$ENBCU_TAG-$JENKINS_IMG_TAG"
HELM_RELEASE_NAME="cu"

pod_status=0

function is_pod_terminated()
{
    pod_name=$1
    filter_name=$2
    echo "is_pod_terminated"
    echo $pod_name $filter_name
    pod=$(kubectl get pod -A | grep $filter_name |awk '{print $2}');
    for i in $pod;
    do
        echo $pod;
        echo "judge return 0";
        if [[ $pod==$pod_name ]] ; then
           echo "return 0"
           return 0
        fi
    done;
    echo "return 1";
    return 1
}

function wait_pod_terminated()
{
    pod_name=$1
    echo $1 $2
    while((1))
    do
        is_pod_terminated $pod_name $2
        is_pod_term=$?
        if [ $is_pod_term -eq 1 ] ; then
            echo "pod terminated"
            break
        fi
        sleep 5
        echo "wait $2 terminated"
    done
}


function is_pod_ready()
{
    pod_name=$1
    filter_name=$2
    echo "is_pod_ready"
    echo $pod_name $filter_name
    pod=$(kubectl get pod -A | grep $filter_name |awk '{print $2 $3 $4}');
    for i in $pod;
    do
        echo $pod;
        if [ $pod==$pod_name ] ; then
           pod_status=1
           return
        fi
    done;
}


function wait_pod_ready()
{
    pod_name=$1
    echo $1 $2
    while((1))
    do
        is_pod_ready $pod_name $2
        if [ $pod_status -eq 1 ] ; then
            echo "pod ready"
            break
        fi
        sleep 5
        echo "wait $2 ready"
    done
}


#main

helm list

helm delete --purge cu




echo " waiting sm terminated ";
wait_pod_terminated "v4-virtio-sm-jian-0" "sm"
echo "waiting cuvnf terminated";
wait_pod_terminated "v4-virtio-cuvnf-jian-0" "cuvnf"
echo "all pods are terminated"

sleep 10
cd /data/jianzhang/cu-helm-20210303

helm install ./ --name $HELM_RELEASE_NAME --debug --set pods.cuvnf.image=$CP_DOCKER_IMAGE

kubectl get pods -A
sleep 30
kubectl get pods -A

pod_status=0

echo "start waiting sm";
wait_pod_ready "v4-virtio-sm-jian-01/1Running" "sm"
pod_status=0
echo "start waiting cuvnf";
wait_pod_ready "v4-virtio-cuvnf-jian-02/2Running" "cuvnf"
echo "all pods are ready"

sleep 30
ls -lrt
fi

sm_status=$(kubectl exec v4-virtio-sm-jian-0 -n enodeb-jian readShm)
echo $sm_status
cucp_status=$(kubectl exec v4-virtio-cuvnf-jian-0 -c cuvnf-container -n enodeb-jian readShm)
echo $cucp_status




