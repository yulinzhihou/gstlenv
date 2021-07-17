#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
clear
# 检测是不是root用户。不是则退出
[ $(id -u) != "0" ] && { echo "${CFAILURE}错误: 你必须使用ROOT用户${CEND}"; exit 1; }
# 容器存放的父级目录
ROOT_PATH='/root'
# 容器配置文件名称
CONFIG_FILE='.env'
# 容器下载临时路径
TMP_PATH='/opt'
# 容器打包文件后缀
SUFFIX='.tar.gz'
#环境下载保存的文件名称
FILENAME='gstlenv'
# 容器完整包名称
WHOLE_NAME=${FILENAME}${SUFFIX}
#解压后重全名文件夹名称
ENVDIR='.tlgame'
#环境版本号
VERSION='v2.0.0'
#更新时间
UPDATE='2021-06-30'

INFO=$(curl https://gsgameshare.com/info.txt)

show() {
  echo -e "\e[1;35m${INFO}\033[0m"
}

download () {
  echo -e "${CGREEN}正在下载环境安装源码，此过程决定于网速，源码安装包大概 2MB 左右，请稍候……${CEND}"
  # wget -q ${FILENAME} https://gitee.com/yulinzhihou/gs_tl_env/repository/archive/${VERSION}.tar.gz  -O ${TMP_PATH}/${WHOLE_NAME}
  # gs env 服务器环境 ，组件
  wget -q https://gsgameshare.com/${WHOLE_NAME} -O ${TMP_PATH}/${WHOLE_NAME}
  cd ${TMP_PATH} && \
  # 解压目录
  tar zxf ${WHOLE_NAME} && mv ${FILENAME} ${ROOT_PATH}/${ENVDIR} && \
  rm -rf ${TMP_PATH}/${WHOLE_NAME}
  echo -e "${CGREEN}安装已经下载到本地并准备执行安装！请耐心等待！${CEND}"
}

show
download
if [ -d ${ROOT_PATH}/${ENVDIR} ]; then
    chmod -R 777 ${ROOT_PATH}/${ENVDIR} && \
    chown -R root:root ${ROOT_PATH}/${ENVDIR} && \
    \cp -rf ${ROOT_PATH}/${ENVDIR}/env.sample ${ROOT_PATH}/${ENVDIR}/${CONFIG_FILE} && \
    cd ${ROOT_PATH}/${ENVDIR} && \
    bash install.sh
fi