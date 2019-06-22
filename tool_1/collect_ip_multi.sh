#!/bin/bash
starttime=`date +'%Y-%m-%d %H:%M:%S'`
start_seconds=$(date --date="$starttime" +%s);
process=$1;
path="/mnt/hgfs/共享文件夹/";
CN_save_file=$path"CN_ip_addr.txt";
HK_MO_TW_save_file=$path"HK_MO_TW_ip_addr.txt";
oversea_save_file=$path"oversea_ip_addr.txt";

for i in $(seq 1 $process)
do
	echo "process"$i;
	./ip_multi.sh $i $process &
done

wait;
endtime=`date +'%Y-%m-%d %H:%M:%S'`
end_seconds=$(date --date="$endtime" +%s);
echo "本次运行时间： "$((end_seconds-start_seconds))"s"
echo "start sorting ip addresses"
if [ -f "$CN_save_file" ];then	
	sort -k 2 $CN_save_file -o $CN_save_file;
	echo "$CN_save_file is done";
fi

if [ -f "$HK_MO_TW_save_file" ];then	
	sort -k 2 $HK_MO_TW_save_file -o $HK_MO_TW_save_file;
	echo "$HK_MO_TW_save_file is done";
fi

if [ -f "$oversea_save_file" ];then	
	sort -k 2 $oversea_save_file -o $oversea_save_file;
	echo "$oversea_save_file is done";
fi
