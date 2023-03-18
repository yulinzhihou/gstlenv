#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-07-19
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+

# 第一步：更新系统组件，安装docker,docker-composer
# 第二步：下载GS相关命令到系统
# 第三步：在线下载打包好的镜像或者导入离线版本的镜像
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
startTime=$(date +%s)
# 检测是不是root用户。不是则退出
[ $(id -u) != "0" ] && {
    echo "${CFAILURE}错误: 你必须使用ROOT用户${CEND}"
    exit 1
}
#获取当前脚本路径
GSTL_DIR=$(dirname "$(readlink -f $0)")
pushd ${GSTL_DIR} >/dev/null
# 加载配置
. ./env.sample
. ./scripts/color.sh

# 判断是否为离线环境
if [ ! -d /root/.gs ]; then
    mkdir -p /root/.gs
fi

if [ ! -f /root/.gs/.env ]; then
    \cp -rf env.sample /root/.gs/.env
    \cp -rf docker-compose.yml /root/.gs
fi
# 加载配置
. /root/.gs/.env
. ./include/check_os.sh

if [ -f /root/gstlenv_offline.tar.gz ]; then
    [ ! -d ${SHARED_DIR} ] && mkdir -p ${SHARED_DIR}
    [ ! -d ${GS_PROJECT} ] && mkdir -p ${GS_PROJECT}

    \cp -rf ./* ${GS_PROJECT} &&
        \cp -rf docker-compose.yml /root/.gs/docker-compose.yml &&
        . ${GS_WHOLE_PATH} &&
        chmod -R 777 ${GS_PROJECT}
    # chown -R root:root ${GS_PROJECT}
fi

# 系统组件安装
sys_plugins_install() {
    echo -e "${CYELLOW}开始安装系统常用组件 !!!${CEND}"
    # 安装 wget gcc curl git python
    ${PM} -y install wget gcc curl python git jq vim unzip zip
    [ "${CentOS_ver}" == '8' ] && {
        yum -y install python36 gcc wget curl git jq vim unzip zip
        sudo alternatives --set python /usr/bin/python3
    }
}

# 安装docker docker-compose
do_install_docker() {
    echo -e "${CYELLOW}开始安装环境核心组件 Docker + docker-compose !!!${CEND}"
    egrep "^docker" /etc/group >&/dev/null
    if [ $? -ne 0 ]; then
        sudo groupadd docker
        sudo usermod -aG docker ${USER}
        sudo gpasswd -a ${USER} docker
    fi

    docker info >&/dev/null
    if [ $? -ne 0 ]; then
        # 制作的国内镜像安装脚本
        curl -sSL https://gsgameshare.com/gsdocker | bash -s docker --mirror Aliyun
        if [ ! -d "/etc/docker" ]; then
            sudo mkdir -p /etc/docker
            sudo tee /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://f0tv1cst.mirror.aliyuncs.com"]
}
EOF
        fi

        [ "${OS}" == "Debian" ] || [ "${OS}" == "Ubuntu" ] && sudo apt-get services docker start && systemctl enable docker
        [ "${OS}" == "CentOS" ] || [ "${OS}" == "CentOSStream" ] || [ "${OS}" == "CentOS Stream release 9" ] && sudo systemctl daemon-reload && sudo systemctl start docker && systemctl enable docker

    else
        echo -e "${CYELLOW}环境 Docker 安装成功 !!!${CEND}"
    fi

    if [ ! -f /usr/local/bin/docker-compose ]; then
        # curl -L https://get.daocloud.io/docker/compose/releases/download/${DOCKER_COMPOSER_VERSION:-v2.12.2}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
        curl -L https://ghproxy.com/https://github.com/docker/compose/releases/download/${DOCKER_COMPOSER_VERSION:-1.29.2}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    fi
    docker-compose --version >&/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${CYELLOW}容器编排工具 docker-compose 安装成功 !!! ${CEND}"
    else
        echo -e "${CRED}容器编排工具 docker-compose 安装失败 !!! ${CEND}"
        exit 1
    fi
}

# 配置常用命令到系统中
set_command() {
    echo -e "${CYELLOW}开始设置全局命令 !!!${CEND}"
    for VAR in $(ls -l ${GS_PROJECT}/scripts/ | awk '{print $9}'); do
        if [ -n ${VAR} ]; then
            \cp -rf ${GS_PROJECT}/scripts/${VAR} /usr/local/bin/${VAR%%.*} && chmod +x /usr/local/bin/${VAR%%.*}
        fi
    done
}

# 设置服务器时间
set_timezone() {
    echo -e "${CYELLOW}开始设置时区 !!!${CEND}"
    rm -rf /etc/localtime
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
    # 复制一份到docker镜像里面。可以在制作docker镜像时添加
}

# 安装整合
do_install() {
    set_timezone
    [ $? -eq 0 ] && echo -e "${CYELLOW}设置时区成功!! ${CEND}" || {
        echo -e "${CRED}设置时区失败!! ;${CEND}"
        exit 0
    }
    do_install_docker
    [ $? -eq 0 ] && echo -e "${CYELLOW}环境核心组件安装成功！！ ${CEND}" || {
        echo -e "${CRED}环境核心组件安装失败!! ;${CEND}"
        exit 0
    }
    set_command
    [ $? -eq 0 ] && echo -e "${CYELLOW}设置全局命令成功！！${CEND}" || {
        echo -e "${CRED}设置全局命令失败！！${CEND}"
        exit 0
    }
}

# mysql 5.1 初始化
init_mysql51() {
    docker exec -d gsmysql /bin/bash /usr/local/bin/init_db.sh
}

##################################################################
# 调用系统组件
sys_plugins_install
clear
# 开始安装
do_install && gstl && init_mysql51
