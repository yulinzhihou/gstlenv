#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-12-25
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 设置默认充值点数

docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
  if [ -f /root/.gs/.env ]; then
    . /root/.gs/.env
  fi
  # 颜色代码
  if [ -f ./color.sh ]; then
    . ${GS_PROJECT}/scripts/color.sh
  else
    . /usr/local/bin/color
  fi

  if [ $# -eq 0 ]; then
    docker exec gsmysql /bin/bash /usr/local/bin/gsset.sh 0
  else
    if [[ $1 =~ ^[0-9]+$ ]] && [ $1 -ge 0 ] && [ $1 -lt 2100000000 ]; then
      docker exec gsmysql /bin/bash /usr/local/bin/gsset.sh $1
      echo -e "${CSUCCESS}设置成功:现在开始，新注册账号上线默认送【$1】充值点，请不要设置过高，一些版本可以会显示为负数${CEND}"
      exit 0
    fi
    echo -e "${CRED}错误:输入有误,充值点数格式不正确，请输入0-21亿之间的整数!!${CEND}"
  fi
else
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装!!!${CEND}"
  exit 1
fi
