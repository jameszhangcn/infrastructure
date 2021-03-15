#?/bin/bash
echo "test build"
cd /home/zhangji/ENBCU-R_6_0_8_0/rhel_7_6_x86_64/bbu

echo "git pull"
git pull

echo "start build"

export SKIP_PLATFORM=1
export SKIP_BUILD_VPP=1
export SKIP_VENDOR=1

nohup ./BUILD_CU RHEL_7_6_X86_64 FDD ENBCUCP-R_6_0_8_0 >build_cu.log 2>&1 &

count=0;
while((1))
do
    if cat 'build_cu.log' | grep "successfully generated" > /dev/null
    then 
        echo "build ENBCU package success"
        rsync -rvl build_cu.log root@10.2.55.115:/data/jianzhang/
        cd /home/zhangji/ENBCU-R_6_0_8_0/rhel_7_6_x86_64
        rsync -rvl rhel_7_6_x86_64-ENBCU-FDD-ENBCUCP-R_6_0_8_0-XRAN.tar.gz root@10.2.55.115:/data/jianzhang/vbbu6090-pi/ 
        break
    fi
    sleep 60
    ((count++))
    if [ $count -gt 60 ]; then
	echo "build timer exceed 100min"
        cat build_cu.log
        break
    fi
done

echo "build ENBCU package end"
