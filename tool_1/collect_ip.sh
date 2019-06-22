#!/bin/bash
starttime=`date +'%Y-%m-%d %H:%M:%S'`
start_seconds=$(date --date="$starttime" +%s);

path="/mnt/hgfs/共享文件夹/";
source_file=$path"ans_left.txt";
CN_save_file=$path"CN_ip_addr.txt";
HK_MO_TW_save_file=$path"HK_MO_TW_ip_addr.txt";
oversea_save_file=$path"oversea_ip_addr.txt";

if [ ! -f "$source_file" ];then
	echo "file don't exist";
	exit 2;
fi

ip_total=$(cat $source_file);
for ip in $ip_total
do
	temp=$(curl --max-time 5  cip.cc/$ip|grep '地址'|awk '{print $3,$4}');
	while [ "$temp" == "" ]
	do
		temp=$(curl --max-time 15 cip.cc/$ip|grep '地址'|awk '{print $3,$4}');
	done
	country=$(echo $temp|awk '{print $1}');
	province=$(echo $temp|awk '{print $2}');
	if [ "$country" == "中国" ];then
		case $province in
			"香港")
				echo $ip $province >> $HK_MO_TW_save_file
				;;
			"台湾")
				echo $ip $province >> $HK_MO_TW_save_file
				;;
			"澳门")
				echo $ip $province >> $HK_MO_TW_save_file
				;;
			*)
				echo $ip $province >> $CN_save_file
				;;
		esac	
	else
		echo $ip $country >> $oversea_save_file;
	fi
done

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

endtime=`date +'%Y-%m-%d %H:%M:%S'`
end_seconds=$(date --date="$endtime" +%s);
echo "本次运行时间： "$((end_seconds-start_seconds))"s"

