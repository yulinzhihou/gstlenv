#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 分步调试命令，手动创建新窗口，step 1,step 2,step 3,step 4
# 引入全局参数 -- 暂时没有含义，因为不能用一条命令直接看到对应容器的调试信息与结果
# if [ -f /root/.gs/.env ]; then
#   . /root/.gs/.env
# else
#   . /usr/local/bin/.env
# fi
# # 颜色代码
# if [ -f ./color.sh ]; then
#   . ${GS_PROJECT}/scripts/color.sh
# else
#   . /usr/local/bin/color
# fi

# echo -e "${CRED}注意：执行此命令前，建议重启服务器，避免一些不必要的问题！${CEND}"
# echo -e "${CYYAN}使用此命令需要手动创建多窗口，点当前容器标签右键---克隆/复制容器---会基于当前容器创建一个全新的容器。每个容器输入一个命令，一共需要4个窗口${CEND}" 
# echo -e "${CYELLOW}如果有问题：可以加客服QQ1302588722，进行反馈${CEND}"

# run_step_1() {
#   docker exec -d gsserver /home/billing/billing up -d
#   if [ $? == 0 ]; then
#     echo -e "${CSUCCESS} 启动 [BILLING] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
#   else
#     echo -e "${CRED} 启动 [BILLING] 服务失败！${CEND}"
#   fi
# }

# run_step_2()) {
#   docker exec -d gsserver ./Server/shm stop && \
#   docker exec -d gsserver /home/billing/billing up -d  && \
#   docker exec -d gsserver /bin/bash Server/shm start

#   if [ $? == 0 ]; then
#     echo -e "${CSUCCESS} 启动 [ShareMemory] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
#   else
#     echo -e "${CRED} 启动 [ShareMemory] 服务失败！${CEND}"
#   fi
# }

# run_step_3() {
#   docker exec -d gsserver /bin/bash Server/Login
#   if [ $? == 0 ]; then
#     echo -e "${CSUCCESS} 启动 [Login] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
#   else
#     echo -e "${CRED} 启动 [Login] 服务失败！${CEND}"
#   fi
# }

# run_step_4() {
#   docker exec -d gsserver /bin/bash Server/World
#   if [ $? == 0 ]; then
#     echo -e "${CSUCCESS} 启动 [World] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
#   else
#     echo -e "${CRED} 启动 [World] 服务失败！${CEND}"
#   fi
# }

# run_step_5() {
#   docker exec -d gsserver /bin/bash Server/Server
#   if [ $? == 0 ]; then
#     echo -e "${CSUCCESS} 启动 [Server] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
#   else
#     echo -e "${CRED} 启动 [Server] 服务失败！${CEND}"
#   fi
# }

# if [ $# == 1 ]; then
# echo -e "
#   ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
#   0. ◎ 运行步骤1：请不要重复启动，重复启动没有任何意义，也达到启动不了的效果。
#   1. ◎ 运行步骤1：启动 [BILLING] 服务
#   2. ◎ 运行步骤2：启动 [BILLING] 服务
#   3. ◎ 运行步骤3：启动 [BILLING] 服务
#   4. ◎ 运行步骤4：启动 [BILLING] 服务
#   5. ◎ 运行步骤5：启动 [BILLING] 服务
#   7. ◎ 退出脚本 （再次打开此脚本请输入 tlbb  命令）
#   ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
#   read -p "请选择功能 输入序号并回车：" num
#   case "$num" in
#   [0]) (tlbb_5x) ;;
#   [1]) (tlbb_6x) ;;
#   [2]) (tlbb_7x) ;;
#   [3]) (tlbb_8x) ;;
#   [4]) (tlbb_sql) ;;
#   [5]) (swapMem) ;;
#   [6]) (update_sh) ;;
#   [7]) ;;
#   *) (main) ;;
#   esac



#   case $1 in
#     1) run_step_1 ;;
#     1) run_step_2 ;;
#     2) run_step_3 ;;
#     3) run_step_4 ;;
#     4) run_step_5 ;;
#     *)echo -e  "${CRED}输入参数错误，请输入1-5的数字${CEND}";;
#   esac
# fi