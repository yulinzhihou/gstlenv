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
# comment: 一键命令关闭所有
# 增加容器是否存在的判断
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
  # 颜色代码
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

  if [ -d ${ROOT_PATH}/${GSDIR} ]; then
    cd ${ROOT_PATH}/${GSDIR} &&
      docker exec -d gsserver /bin/bash /home/tlbb/Server/shm stop &&
      docker exec -d gsserver /bin/bash /home/tlbb/stop.sh &&
      docker exec -d gsserver /home/billing/billing stop
    # restart
    if [ $? -eq 0 ]; then
      # 删除因为改版本导致引擎启动失败的dump文件
      cd ${ROOT_PATH}/${GSDIR} && rm -rf core.*
      echo -e "${CYELLOW}服务端正在关闭……，\r\n请稍候……，\r\n请使用【runtop】查看对应进程是否完全退出\r\n等进程序全部退出后如果需要重新开启，请运行【runtlbb】命令${CEND}"
      exit 0
    else
      echo -e "${GSISSUE}\r\n"
      echo -e "${CRED} 服务端关闭失败！请稍后再试！${CEND}"
      exit 1
    fi
  fi
else
  echo -e "${GSISSUE}\r\n"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
