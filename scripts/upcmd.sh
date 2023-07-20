#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-09-16
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 根据当前环境变量重新生成命令
# 增加容器是否存在的判断

# 更新命令
download() {
  # [ ! -z ${COMMAND_VERSION} ] && COMMAND_VERSION=${COMMAND_VERSION} || COMMAND_VERSION=${VERSION}
  wget -q https://gitee.com/yulinzhihou/gstlenv/repository/archive/master.tar.gz -O /tmp/master.tar.gz
  if [ -f /tmp/master.tar.gz ]; then
    cd /tmp &&
      # 解压目录
      tar zxf master.tar.gz && cd /tmp/gstlenv-master && \cp -rf * ${GS_PROJECT}/
    if [ $? -eq 0 ]; then
      rm -rf /tmp/master.tar.gz &&
        rm -rf /tmp/gstlenv-master
    else
      return 1
    fi
  else
    return 1
  fi
  return 0
}

# 设置最新命令
set_command() {
  for VAR in $(ls -l ${GS_PROJECT}/scripts/ | awk '{print $9}'); do
    if [ -n ${VAR} ]; then
      \cp -rf ${GS_PROJECT}/scripts/${VAR} /usr/local/bin/${VAR%%.*} && chmod +x /usr/local/bin/${VAR%%.*}
    fi
  done
}

# 复制命令到容器里面
copy_to_gssmysql() {
  # 复制配置文件
  for VAR in $(ls -l ${GS_PROJECT}/include/ | awk '{print $9}'); do
    if [ -n ${VAR} ]; then
      docker cp -q ${GS_PROJECT}/include/${VAR} gsmysql:/usr/local/bin/${VAR}
    fi
  done
}

# 复制命令到容器里面
copy_to_gsserver() {
  docker cp -q ${GS_PROJECT}/scripts/step.sh gsserver:/usr/local/bin/step &&
    docker exec -d gsserver chmod -R 777 /usr/local/bin
}

# 入口
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

  # 判断是否有下载最新命令，如果没有，则不更新
  if [ -e /usr/bin/wget ]; then
    echo -e "${CYELLOW}正在在线更新最新GS环境命令，请稍等……${CEND}"
    download
    if [ $? -eq 0 ]; then
      set_command && copy_to_gssmysql && copy_to_gsserver && docker exec -d gsmysql chmod -R 777 /usr/local/bin
      if [ $? -eq 0 ]; then
        echo -e "${CSUCCESS}命令重新生成成功，如果需要了解详情，可以运行 【gs】命令进行帮助查询！！${CEND}"
        exit 0
      else
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED}命令重新生成失败，请联系作者，或者重装安装环境 ${CEND}"
        exit 1
      fi
    fi
  else
    echo -e "${CYELLOW}当前命令已是最新版本[$UPDATE]，无需更新！！！${CEND}"
  fi
else
  echo -e "${GSISSUE}\r\n"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
