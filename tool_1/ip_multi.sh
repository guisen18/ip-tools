#!/bin/bash

batch=$1;
process=$2;

path="/mnt/hgfs/共享文件夹/";
source_file=$path"ans.txt";
CN_save_file=$path"CN_ip_addr.txt";
HK_MO_TW_save_file=$path"HK_MO_TW_ip_addr.txt";
oversea_save_file=$path"oversea_ip_addr.txt";

CNlock="/tmp/cn.lock";
HMTlock="/tmp/hmt.lock";
oslock="/tmp/os.lock";

line=$(wc -l $source_file|awk '{print $1}');

startline=$((1+(batch-1)*line/process));
if [ "$batch" == "$process" ];then
	endline=$line;
else
	endline=$((batch*line/process));
fi

ip_total=$(sed -n ${startline},${endline}p $source_file);

for ip in $ip_total
do
	temp=$(curl --max-time 5 cip.cc/$ip|grep '地址'|awk '{print $3,$4}');
        while [ "$temp" == "" ]
        do
                temp=$(curl --max-time 15 cip.cc/$ip|grep '地址'|awk '{print $3,$4}');
        done
	country=$(echo $temp|awk '{print $1}');
        province=$(echo $temp|awk '{print $2}');
	if [ "$country" == "中国" ];then
                case $province in
                        "香港")
				(
				flock -w 10 101
                                echo $ip $province >> $HK_MO_TW_save_file
				)101<>/tmp/hmt.lock
                                ;;
                        "台湾")
				(
				flock -w 10 101
                                echo $ip $province >> $HK_MO_TW_save_file
				)101<>/tmp/hmt.lock
                                ;;
                        "澳门")
				(
				flock -w 10 101 
                                echo $ip $province >> $HK_MO_TW_save_file
				)101<>/tmp/hmt.lock
                                ;;
                        *)
				(
				flock -w 10 100
                                echo $ip $province >> $CN_save_file
				)100<>/tmp/cn.lock
                                ;;
                esac
	else
		(
		flock -w 10 102
                echo $ip $country >> $oversea_save_file
		)102<>/tmp/os.lock
        fi

done

