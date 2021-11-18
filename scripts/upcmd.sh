#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-09-16
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 根据当前环境变量重新生成命令
# 增加容器是否存在的判断
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
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

  # 更新命令
  download() {
    wget -q https://gitee.com/yulinzhihou/gstlenv/repository/archive/${VERSION}.tar.gz -O ${TMP_PATH}/${VERSION}.tar.gz
    # gs env 服务器环境 ，组件
    # wget -q https://gsgameshare.com/${WHOLE_NAME} -O ${TMP_PATH}/${WHOLE_NAME}
    if [ ! -d ${TMP_PATH}/${VERSION} ]; then
      mkdir -p ${TMP_PATH}/${VERSION}
    fi
    cd ${TMP_PATH} &&
      # 解压目录
      tar zxf ${VERSION}.tar.gz -C $VERSION && cd ${VERSION} && mv * ${VERSION} && \cp -rf ${VERSION}/* $GS_PROJECT/
    if [ $? -eq 0 ]; then
      rm -rf ${TMP_PATH}/${VERSION}.tar.gz &&
        rm -rf ${TMP_PATH}/${VERSION}
    fi
  }

  set_command() {
    ls -l ${GS_PROJECT}/scripts/ | awk '{print $9}' >/tmp/command.txt
    for VAR in $(cat /tmp/command.txt); do
      if [ -n ${VAR} ]; then
        \cp -rf ${GS_PROJECT}/scripts/${VAR} /usr/local/bin/${VAR%%.*} && chmod +x /usr/local/bin/${VAR%%.*}
      fi
    done
    rm -rf /tmp/command.txt
  }

  download
  if [ $? -eq 0 ]; then
    set_command
    if [ $? -eq 0 ]; then
      echo -e "${CSUCCESS} 命令重新生成成功，如果需要了解详情，可以运行 【gs】命令进行帮助查询！！${CEND}"
      exit 0
    else
      echo -e "${CRED} 命令重新生成失败，请联系作者，或者重装安装环境 ${CEND}"
      exit 1
    fi
  fi
else
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
