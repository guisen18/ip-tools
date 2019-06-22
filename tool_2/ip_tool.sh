#!/bin/bash
#$1:log file,$2:the file where target ip saved,$3:the time when to select ip 
source_file="LogTank_a3aeaabd09df4f7ea78e33ced073231c_2019-05-09T07-23-55Z_1dfff255e2d1d279"
destined_ip="destined_ip.txt"
date_time="2019-05-09 15:23:00"

if [ "$#" == "3" ];then
	source_file=$1
	destined_ip=$2
	date_time=$3
fi

if [ ! -f "$source_file" ] || [ ! -f "$destined_ip" ];then
	echo "log file(target ip file) dont exist"
	exit 1;
fi

ans="./output.txt"
echo "the result is saved in"$ans;

temp="./temp"

rm -f $ans

#result format: 2019-05-09 15:23:36 222.186.171.188
cat $source_file | awk -F "[ T\[\]+]+" '{print $3,$4,$7}' |sed 's/:[0-9]*$//g' \
|sed '/^\s$/d'|sort -g -k 3 -k 2 -k 1 -r |uniq -f 2  > $temp

sort -k 1 -k 2 -r $temp -o $temp

#select the ip records of the log file which created after the $date_time
lines=$(wc -l $temp|awk '{print $1}')
for line in $(seq 1 $lines)
do
	date_time_now=$(sed -n "${line}p" $temp|awk '{print $1,$2}')
	t1=`date -d "$date_time" +%s`
	t2=`date -d "$date_time_now" +%s`
	if [ $t2 -lt $t1 ];then
		sed -i "${line},$ d" $temp
		break
	fi
done

#result format: 221_211.149.224.62 
des_ip=$(cat -n $destined_ip|sed 's/\t/_/g'|grep '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$') 

#compare the ip records of the $source_file and $destined_ip,
for ip in $des_ip
do
	line=$(echo $ip|awk -F "_" '{print $1}')
	ip=$(echo $ip|awk -F "_" '{print $2}')
	ip_time=$(grep "$ip" $temp|awk '{print $1,$2}')

	if [ "$ip_time" != "" ];then
		line=$((line+1))
		echo -e $ip_time"\t\t"$ip"\t"`sed -n "${line}p" $destined_ip` >> $ans
		#sed -i "s/^*${ip}\$//g" $temp
	fi
done
rm -f $temp
