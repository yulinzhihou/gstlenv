#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-12-25
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 封号，解封号

docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
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

  if [ -z $1 ]; then
    # 判断第一个参数是否为空
    echo -e "${CRED}请输入需要解封或者封号的账号！${CEND}"
    exit 1
  else
    # 判断是否有第二个参数输入
    if [ -z $2 ]; then
      # 表示是解封
      docker exec -it gsmysql /bin/bash /usr/local/bin/gssetvalid.sh $1
      echo -e "${CSUCCESS}解封[$1]账号成功：登录游戏查看，如果未实现请退出游戏再执行一次${CEND}"
      exit 0
    else
      # 判断是否输入的是1，如果是1表示为封号
      if [[ $2 -eq 1 ]]; then
        docker exec -it gsmysql /bin/bash /usr/local/bin/gssetvalid.sh $1 1
        echo -e "${CSUCCESS}封[$1]账号成功：登录游戏查看，如果未实现请退出游戏再执行一次${CEND}"
        exit 0
      else
        echo -e "${CRED}输入错误：如果需要封号，请在账号后面使用数字1即可封号！${CEND}"
        exit 1
      fi
    fi

  fi
else
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装!!!${CEND}"
  exit 1
fi
