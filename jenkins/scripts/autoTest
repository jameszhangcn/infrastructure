#!/bin/bash

MME_PATH="/home/jenkins/mme/"
DU_1_UE_PATH="/home/jenkins/du-1ue/"
DU_PATH="/home/jenkins/du/"
echo "start testing"

function kill_scripts()
{
    procName=$1
    
    for process in "`ps -ef | grep $procName | awk '{print $2}'| sed -n '1'p`"
        do 
        kill -9 $process;
        echo "$process simu shutdown ok"
    done
}

function prepare_test()
{

    kill_scripts "duSim"
    kill_scripts "Mme"
}

#test case 1
function is_s1_ok()
{
    count=0
    while((1))
    do
        if cat 'test.log' | grep "Received S1SetupRequest" > /dev/null
        then
            echo "S1 setup OK"
            break
        fi
        sleep 10
        echo "wait s1 setup $count ..."
        ((count++))
        if [ $count -gt 200 ]; then
            echo "S1 setup failed ..."
            cat test.log
            exit 1
            break
        fi
    done
}

function test_s1()
{
    echo "test s1 setup"
    cd $MME_PATH
    nohup ./MmeSim > test.log 2>&1 &
    is_s1_ok
    kill_scripts "Mme"
}

#test case 1
function is_ue_attach_ok()
{
    count=0
    while((1))
    do
        if cat 'test.log' | grep "rrcConnectionReconfigurationComplete:  4" > /dev/null
        then
            echo "UE attach OK"
            break
        fi
        sleep 10
        echo "wait ue attach $count ..."
        ((count++))
        if [ $count -gt 200 ]; then
            echo "ue attach failed ..."
            cat test.log
            exit 1
            break
        fi
    done
}

function test_ue_attach()
{
    kill_scripts "Mme"
    echo "test ue attach"
    cd $MME_PATH
    nohup ./MmeSim > test.log 2>&1 &
    is_s1_ok
    cd $DU_1_UE_PATH
    nohup ./duSim_upd_6060 > test.log 2>&1 &
    sleep 10
    is_ue_attach_ok
    kill_scripts "Mme"
    kill_scripts "duSim"
}

echo "start testing"
prepare_test
test_s1
test_ue_attach
echo "testing finished"
