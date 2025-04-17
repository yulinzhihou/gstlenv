#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2024-07-24
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 监听服务是否正常，掉线自动启动

AddCrontab() {
    # 查询是否已经写入过计划任务
    crontabCount=$(crontab -l | grep listen.sh | grep -v grep | wc -l)
    if [ $crontabCount = 0 ]; then
        (
            echo "* * * * * sleep 5;sh /home/tlbb/listen.sh > /dev/null 2>&1 &"
            crontab -l
        ) | crontab
    fi
}
AddCrontab

# 记录日志时间
echo $(date +"%Y-%m-%d %H:%M:%S") >>/home/tlbb/listen.log

# 查询Login与World是否正常
LoginCount=$(ps -fe | grep Login | grep -v grep | wc -l)
WorldCount=$(ps -fe | grep World | grep -v grep | wc -l)

# 查询Server是否正常
ServerCount=$(ps -fe | grep ServerTest | grep -v grep | wc -l)

# 查询Login和World是否存在，如果存在说明天龙服务正在
# 运行,并往下继续执行.否则的话直接退出脚本等待下次监听
if [ "$LoginCount" = 0 ] || [ "$WorldCount" = 0 ]; then
    echo "TLBB Service is not running...." >>/home/tlbb/listen.log
    exit
fi

# 如果 Server 不存在，就重启Server
if [ $ServerCount = 0 ]; then
    #写入日志
    echo "restart TLBB Server....." >>/home/tlbb/listen.log
    cd /home/tlbb && ./stop.sh && ./run.sh
    # cd /home/tlbb/Server/
    # ./ServerTest >/dev/null 2>&1 &
    sleep 60
    echo "Server started completely !!!!!!" >>/home/tlbb/listen.log
else
    #写入日志
    echo "TLBB Server is runing....." >>/home/tlbb/listen.log
fi
