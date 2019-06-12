#!/bin/bash
check_pid(){
	PID=`ps -ef |grep -v grep | grep server.py |awk '{print $2}'`
}
crontab_monitor_ssr(){
	check_pid
	if [[ -z ${PID} ]]; then
		ps -ef |grep -v grep | grep server.py |awk '{print $2}'
		echo -e "${Error} [$(date "+%Y-%m-%d %H:%M:%S %u %Z")] 检测到 ShadowsocksR服务端 未运行 , 开始启动..." | tee -a ssserver.log
		nohup ${python_ver} server.py m>> /dev/null 2>&1 &
		sleep 1s
		check_pid
		if [[ -z ${PID} ]]; then
			echo -e "${Error} [$(date "+%Y-%m-%d %H:%M:%S %u %Z")] ShadowsocksR服务端 启动失败..." | tee -a ssserver.log && exit 1
		else
			echo -e "${Info} [$(date "+%Y-%m-%d %H:%M:%S %u %Z")] ShadowsocksR服务端 启动成功..." | tee -a ssserver.log && exit 1
		fi
	else
		echo -e "${Info} [$(date "+%Y-%m-%d %H:%M:%S %u %Z")] ShadowsocksR服务端 进程运行正常..." && exit 0
	fi
}
cd `dirname $0`
python_ver=$(ls /usr/bin|grep -e "^python[23]\.[1-9]\+$"|tail -1)
#eval $(ps -ef | grep "[0-9] ${python_ver} server\\.py m" | awk '{print "kill "$2}')
ulimit -n 512000
crontab_monitor_ssr