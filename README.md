## tool_1 查找ip归宿地

##### 初始单进程脚本
collect_ip.sh


##### 多进程脚本
主脚本通过调用副脚本实现多进程运行  
collect_ip_multi.sh(主脚本)  
ip_multi.sh(副脚本)  


##### 实验阶段代码
collect.txt  
collect_ip_multi_func.txt  



## tool_2 筛选目标ip

##### 可用命令行传参方式执行
$1：日志文件路径  
$2：目标ip文件路径  
$3：筛选起始时间  

##### 执行
脚本：ip_tool.sh  
实验日志：LogTank_*  
目标ip：destined_ip.txt  

