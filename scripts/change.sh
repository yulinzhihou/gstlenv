#!/usr/bin/env bash
# 设置字符编码，确保中文正常显示
# 尝试设置 locale，如果失败则静默处理（不显示警告）
# 使用命令块包裹并重定向所有错误输出，彻底屏蔽警告信息
{
    export LANG=C.UTF-8 2>/dev/null || export LANG=en_US.UTF-8 2>/dev/null || export LANG=POSIX 2>/dev/null || true
    export LC_ALL=C.UTF-8 2>/dev/null || export LC_ALL=en_US.UTF-8 2>/dev/null || export LC_ALL=POSIX 2>/dev/null || true
} 2>/dev/null
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 换版本
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
  # 引入全局参数
  if [ -f /root/.gs/.env ]; then
    . /root/.gs/.env
  fi
  # 颜色代码
  if [ -f ./color.sh ]; then
    . ${GS_PROJECT}/scripts/color.sh
  else
    . /usr/local/bin/color
  fi
  # 换端前，先备份版本与数据库
  function backup_tlbb() {
    backup all
  }
  # mysql 初始化
  init_mysql() {
    docker exec -it gsmysql /bin/bash /usr/local/bin/init_db.sh
  }

  function main() {
    cd ${ROOT_PATH}/${GSDIR} &&
      docker-compose down &&
      sleep 10 &&
      rm -rf /tlgame/gsmysql/* &&
      rm -rf /tlgame/tlbb/* &&
      docker-compose up -d &&
      sleep 10 &&
      untar &&
      init_mysql &&
      setini &&
      runtlbb
    if [ $? -eq 0 ]; then
      echo -e "${CSUCCESS}换端成功，请耐心等待几分钟后，建议使用：【runtop】查看开服的情况！${CEND}"
      exit 0
    else
      echo -e "${CRED}换端失败！请检查配置！${CEND}"
      exit 1
    fi
  }

  if [ ! -f /root/tlbb.tar.gz ] && [ ! -f /root/tlbb.zip ]; then
    echo -e "${GSISSUE}\r\n"
    echo "${CRED}新服务端版本文件不存在，请先上传服务端 tlbb.tar.gz 或者 tlbb.zip 到 /root 目录下再执行换端操作！${CEND}"
    exit 1
  fi

  while :; do
    echo
    for ((time = 5; time >= 0; time--)); do
      echo -ne "\r正准备换端操作，会清除所有数据，会自动备份数据库和服务端版本到 /tlgame/backup 目录，剩余 ${CRED}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！\r"
      sleep 1
    done
    echo -ne "\r\n"
    echo -ne "${CYELLOW}正在重构环境，换版本…………${CEND}\r\n"
    backup_tlbb 
    main
  done
else
  echo -e "${GSISSUE}\r\n"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
