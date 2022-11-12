#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 分步调试命令，手动创建新窗口，step 1,step 2,step 3,step 4
# 引入全局参数 -- 暂时没有含义，因为不能用一条命令直接看到对应容器的调试信息与结果
echo=echo
for cmd in echo /bin/echo; do
    $cmd >/dev/null 2>&1 || continue
    if ! $cmd -e "" | grep -qE '^-e'; then
        echo=$cmd
        break
    fi
done
CSI=$($echo -e "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CSUCCESS="$CDGREEN"
CFAILURE="$CRED"
CQUESTION="$CMAGENTA"
CWARNING="$CYELLOW"
CMSG="$CCYAN"

run_step_1() {
    cd /home/billing
    ./billing stop
    ./billing up -d
    if [ $? -eq 0 ]; then
        echo -e "${CSUCCESS} 启动 [BILLING] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
    else
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED} 启动 [BILLING] 服务失败！${CEND}"
    fi
}

run_step_2() {
    cd /home/tlbb/Server && ./shm stop && ./shm start
    if [ $? -eq 0 ]; then
        echo -e "${CSUCCESS} 启动 [ShareMemory] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
    else
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED} 启动 [ShareMemory] 服务失败！${CEND}"
    fi
}

run_step_3() {
    GS_LOGIN=$(ls -l /home/tlbb/Server | grep -v "^d" | grep "Login" | head -n1 | awk '{print $9}')
    cd /home/tlbb/Server && ./${GS_LOGIN}
    if [ $? -eq 0 ]; then
        echo -e "${CSUCCESS} 启动 [Login] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
    else
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED} 启动 [Login] 服务失败！${CEND}"
    fi
}

run_step_4() {
    GS_WORLD=$(ls -l /home/tlbb/Server | grep -v "^d" | grep "World" | head -n1 | awk '{print $9}')
    cd /home/tlbb/Server && ./${GS_WORLD}
    if [ $? -eq 0 ]; then
        echo -e "${CSUCCESS} 启动 [World] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
    else
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED} 启动 [World] 服务失败！${CEND}"
    fi
}

run_step_5() {
    GS_SERVER=$(ls -l /home/tlbb/Server | grep -v "^d" | grep "Server" | head -n1 | awk '{print $9`}')
    cd /home/tlbb/Server && ./${GS_SERVER}
    if [ $? -eq 0 ]; then
        echo -e "${CSUCCESS} 启动 [Server] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
    else
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED} 启动 [Server] 服务失败！${CEND}"
    fi
}

if [ -d "/home/tlbb" ] && [ -d "/home/billing" ]; then

    if [ $# -eq 1 ]; then
        case $1 in
        1 | "b" | 'billing' | 'B' | 'BILLING')
            run_step_1
            ;;
        2 | 'sharememory' | "s" | 'SHAREMEMORY')
            run_step_2
            ;;
        3 | 'login' | 'l' | 'LOGIN' | 'L')
            run_step_3
            ;;
        4 | 'world' | 'w' | 'WORLD' | 'W')
            run_step_4
            ;;
        5 | 'Server' | 'server' | 'SERVER')
            run_step_5
            ;;
        *) echo "输入错误！！" ;;
        esac
    else

        echo -e "${CRED}注意：执行此命令前，建议重启服务器，避免一些不必要的问题！${CEND}"
        echo -e "${CYYAN}使用此命令需要手动创建多窗口，点当前容器标签右键---克隆/复制容器---会基于当前容器创建一个全新的容器。每个容器输入一个命令，一共需要4个窗口${CEND}"
        echo -e "${GSISSUE}\r\n"
        while :; do
            echo
            echo -e "
※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
◎ 请在容器外使用runtop命令查看开启了哪些进程
◎ 请不要重复启动，重复启动没有任何意义，也达到启动不了的效果。
◎ 使用 exit 退出容器操作命令行，使用 link 进入容器操作命令行
◎ 步骤[1|b|billing|B|BILLING]：启动 [BILLING] 服务
◎ 步骤[2|sharememory|s|SHAREMEMORY]：启动 [ShareMemory] 服务
◎ 步骤[3|login|l|LOGIN|L]：启动 [Login] 服务
◎ 步骤[4|world|w|WORLD|W]：启动 [World] 服务
◎ 步骤[5|Server|server|SERVER]：启动 [Server] 服务
※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
            read -e -p "请选择功能 输入序号并回车：" num
            case "$num" in
            1 | "b" | 'billing' | 'B' | 'BILLING')
                run_step_1
                break
                ;;
            2 | 'sharememory' | "s" | 'SHAREMEMORY')
                run_step_2
                break
                ;;
            3 | 'login' | 'l' | 'LOGIN' | 'L')
                run_step_3
                break
                ;;
            4 | 'world' | 'w' | 'WORLD' | 'W')
                run_step_4
                break
                ;;
            5 | 'Server' | 'server' | 'SERVER')
                run_step_5
                break
                ;;
            *) echo "输入错误！！" ;;
            esac
        done
    fi
else
    echo -e "${CRED}请进入容器里面使用此命令，link 命令可以进入！${CEND}"
    echo -e "${CRED}使用此命令需要手动创建多窗口，点当前窗口标签右键---克隆/复制窗口---会基于当前窗口创建一个全新的窗口。每个窗口输入一个命令，一共需要4个窗口${CEND}"
    echo -e "${GSISSUE}\r\n"
    exit 1
fi
