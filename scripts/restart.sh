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
# comment: 一键命令重启命令所有
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

  while :; do
    echo
    for ((time = 5; time >= 0; time--)); do
      echo -ne "\r在准备正行重启操作！！，剩余 ${CRED}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！\r"
      sleep 1
    done
    echo -ne "\n\r"
    echo -ne "${CYELLOW}正在重启…………\n\r${CEND}"

    if [ $# -eq 0 ]; then
      while :; do
        echo
        echo -e "${CYELLOW}重启数据库有可能导致存档丢失，请注意谨慎操作！${CEND}"
        read -e -p "${CYELLOW}请输入数字1，表示所有服务全部重启(默认: 0表示不重启数据库):${CEND} " IS_MODIFY
        IS_MODIFY=${IS_MODIFY:-'0'}
        case ${IS_MODIFY} in
        1)
          cd ${ROOT_PATH}/${GSDIR} && docker-compose restart gsnginx && docker-compose restart gsserver && docker-compose restart gsmysql
          break
          ;;
        *)
          cd ${ROOT_PATH}/${GSDIR} && docker-compose restart gsnginx && docker-compose restart gsserver
          break
          ;;
        esac
      done
    else
      cd ${ROOT_PATH}/${GSDIR} && docker-compose restart gsnginx && docker-compose restart gsserver
    fi

    # cd ${ROOT_PATH}/${GSDIR} && docker-compose restart && docker exec -it gsmysql /bin/bash /usr/local/bin/init_db.sh
    # 暂时不重启数据库，只重启nginx gsserver 如果需要重启数据库，则加参数1
    if [ $? -eq 0 ]; then
      # 删除因为改版本导致引擎启动失败的dump文件
      cd ${ROOT_PATH}/${GSDIR} && rm -rf core.*
      echo -e "${CSUCCESS} 服务端已经重启成功，如果需要重新开服，请运行【runtlbb】命令，如果需要配置在线GM，请运行【upgm】命令，再运行【runtlbb】命令 ${CEND}"
      exit 0
    else
      echo -e "${GSISSUE}\r\n"
      echo -e "${CRED} 服务端已经重启失败！可能需要重装系统或者环境了！${CEND}"
      exit 1
    fi
  done
else
  echo -e "${GSISSUE}\r\n"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
