#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-07-17
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
DIR=$(pwd)
clear
# 检测是不是root用户。不是则退出
[ $(id -u) != "0" ] && {
    echo "${CFAILURE}错误: 你必须使用ROOT用户${CEND}"
    exit 1
}
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
VERSION='v2.8.1'
# 展示信息
if [ -f info.txt ]; then
    INFO=$(cat info.txt)
else
    INFO=$(curl https://gitee.com/yulinzhihou/gstlenv/raw/master/info.txt)
fi

show() {
    echo -e "\e[1;35m${INFO}\033[0m"
}

download() {
    echo -e "${CYELLOW}正在下载环境安装源码，此过程决定于网速，源码安装包大约 2MB 左右，请稍候……${CEND}"
    if [ -f /root/${VERSION}.tar.gz ]; then
        cd /root &&
            mv ${VERSION}.tar.gz ${TMP_PATH}/${WHOLE_NAME}
    else
        curl -sOL https://gitee.com/yulinzhihou/gstlenv/repository/archive/${VERSION}.tar.gz &&
            mv ${VERSION}.tar.gz ${TMP_PATH}/${WHOLE_NAME}
    fi

    # gs env 服务器环境 ，组件，手动测试时使用
    cd ${TMP_PATH} &&
        tar zxf ${WHOLE_NAME}
    if [ -d /root/.tlgame ]; then
        \cp -rf ${FILENAME}-${VERSION}/* ${ROOT_PATH}/${ENVDIR}
    else
        mv ${FILENAME}-${VERSION} ${ROOT_PATH}/${ENVDIR}
    fi
    rm -rf ${TMP_PATH}/${WHOLE_NAME} ${TMP_PATH}/${FILENAME}-${VERSION}

    echo -e "${CYELLOW}安装包已经下载到本地并准备执行安装！请耐心等待！${CEND}"
}
# 展示环境信息
show
# 兼容在线和离线
if [ ! -f /root/gs_docker_ce.tar.gz ] && [ ! -f /root/gstlenv_offline.tar.gz ] && [ ! -f /root/gs_docker_compose.tar.gz ]; then
    # 下载环境源码
    download
    # 安装并写入安装日志
    cd /root/.tlgame && { bash install.sh 2>&1 | tee -a install.log; }
    # cd /root/.tlgame && bash install.sh | tee -a /root/.tlgame/install.log
else
    # 安装并写入安装日志
    cd /root/.tlgame && bash install.sh local | tee -a /root/.tlgame/install.log
fi
