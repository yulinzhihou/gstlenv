#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 换版本
# 引入全局参数
if [ -f /root/.gs/.env ]; then
  . /root/.gs/.env
else
  . /usr/local/bin/.env
fi
# 颜色代码
if [ -f ./color.sh ]; then
  . ${GS_PROJECT}/scripts/color.sh
else
  . /usr/local/bin/color
fi


function main(){
  docker stop $(docker ps -a -q) && \
  docker rm $(docker ps -a -q) && \
  rm -rf /tlgame/tlbb/* && \
  untar && \
  cd ${ROOT_PATH}/${GSDIR} && \
  setini && \
  docker-compose up -d && \
  runtlbb
  if [ $? == 0 ]; then
    echo -e "${CSUCCESS} 换端成功，请耐心等待几分钟后，建议使用：【runtop】查看开服的情况！${CEND}"
    exit 0;
  else
    echo -e "${CRED} 换端失败！请检查配置！${CEND}"
    exit 1;
  fi
}


while :; do echo
    for ((time = 10; time >= 0; time--)); do
      echo -ne "\r正准备换端操作，会清除所有数据，建议在执行前先进行【backup】命令进行备份，剩余 ${CRED}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！\r"
      sleep 1
    done
    echo -ne "\n\r"
    echo -ne "${CYELLOW}正在重构环境，换版本…………${CEND}"
    main
done

