#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
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
  cd /home/billing && ./billing up -d
  if [ $? == 0 ]; then
    echo -e "${CSUCCESS} 启动 [BILLING] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
  else
    echo -e "${CRED} 启动 [BILLING] 服务失败！${CEND}"
  fi
}

run_step_2() {
  cd /home/tlbb/Server && ./shm stop && ./shm start
  if [ $? == 0 ]; then
    echo -e "${CSUCCESS} 启动 [ShareMemory] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
  else
    echo -e "${CRED} 启动 [ShareMemory] 服务失败！${CEND}"
  fi
}

run_step_3() {
  arr=('Login' 'Login8' 'Login_fix')
  for i in $(seq 0 1 ${#arr[*]})
  do
    index=$i
    if [ -f "/home/tlbb/Server/${arr[index]}" ]; then
        cd /home/tlbb/Server && ./${arr[index]}
        break;
    fi
  done
#   cd /home/tlbb/Server && ./Login
  if [ $? == 0 ]; then
    echo -e "${CSUCCESS} 启动 [Login] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
  else
    echo -e "${CRED} 启动 [Login] 服务失败！${CEND}"
  fi
}

run_step_4() {
  arr=('World' 'World8' 'World_fix')
  for i in $(seq 0 1 ${#arr[*]})
  do
    index=$i
    if [ -f "/home/tlbb/Server/${arr[index]}" ]; then
        cd /home/tlbb/Server && ./${arr[index]}
        break;
    fi
  done
#   cd /home/tlbb/Server && ./World
  if [ $? == 0 ]; then
    echo -e "${CSUCCESS} 启动 [World] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
  else
    echo -e "${CRED} 启动 [World] 服务失败！${CEND}"
  fi
}

run_step_5() {
  arr=('Server' 'Server8' 'Server_fix' 'ServerTest')
  for i in $(seq 0 1 ${#arr[*]})
  do
    index=$i
    if [ -f "/home/tlbb/Server/${arr[index]}" ]; then
        cd /home/tlbb/Server && ./${arr[index]}
        break;
    fi
  done
  if [ $? == 0 ]; then
    echo -e "${CSUCCESS} 启动 [Server] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
  else
    echo -e "${CRED} 启动 [Server] 服务失败！${CEND}"
  fi
}

echo -e "${CRED}注意：执行此命令前，建议重启服务器，避免一些不必要的问题！${CEND}"
echo -e "${CYYAN}使用此命令需要手动创建多窗口，点当前容器标签右键---克隆/复制容器---会基于当前容器创建一个全新的容器。每个容器输入一个命令，一共需要4个窗口${CEND}" 
echo -e "${CYELLOW}如果有问题：可以加客服QQ1302588722，进行反馈${CEND}"
while :; do echo
  echo -e "
    ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
    ◎ 请不要重复启动，重复启动没有任何意义，也达到启动不了的效果。
    ◎ 步骤[1]：启动 [BILLING] 服务
    ◎ 步骤[2]：启动 [ShareMemory] 服务
    ◎ 步骤[3]：启动 [Login] 服务
    ◎ 步骤[4]：启动 [World] 服务
    ◎ 步骤[5]：启动 [Server] 服务
    ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※\r\n"
    echo -e "\r\n"
    echo -e "\r\n"
    read -p "请选择功能 输入序号并回车：" num
    case "$num" in
    [1]) run_step_1;break ;;
    [2]) run_step_2;break ;;
    [3]) run_step_3;break ;;
    [4]) run_step_4;break ;;
    [5]) run_step_5;break ;;
    *) echo -e "输入错误！！" ;;
    esac
done