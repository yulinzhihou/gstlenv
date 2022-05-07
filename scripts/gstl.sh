#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-06-30
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# 检测是不是root用户。不是则退出
if [ -f /usr/local/bin/color ]; then
    . /usr/local/bin/color
fi
[ $(id -u) != "0" ] && {
    echo "${CFAILURE}错误: 你必须使用ROOT用户${CEND}"
    exit 1
}
# comment: 安装天龙环境docker
DOCKERNAME='gsdocker'
# 容器配置根目录
GSDIR='.gs'
# 容器存放的父级目录
ROOT_PATH='/root'
# 容器配置文件名称
CONFIG_FILE='.env'
# 容器配置文件绝对路径，使用gstlenv的配置文件
WHOLE_PATH='/root/.gs/.env'
# 容器下载临时路径
TMP_PATH='/opt'
# 容器打包文件后缀
SUFFIX='.tar.gz'
# 容器完整包名称
WHOLE_NAME=${DOCKERNAME}${SUFFIX}

# 下载容器参数
download() {
    # gs docker 镜像
    # cd ${TMP_PATH} && \
    # wget -q https://gsgameshare.com/${WHOLE_NAME} -O ${TMP_PATH}/${WHOLE_NAME} && \
    # tar zxf ${WHOLE_NAME} && mv ${DOCKERNAME} ${ROOT_PATH}/${GSDIR} && \
    # chown -R root:root ${ROOT_PATH}/${GSDIR} && \
    if [ ! -d ${ROOT_PATH}/${GSDIR} ]; then
        mkdir -p ${ROOT_PATH}/${GSDIR}
    fi
    cd ${ROOT_PATH}/.tlgame && \cp -rf docker-compose.yml ${ROOT_PATH}/${GSDIR} && \cp -rf env.sample ${WHOLE_PATH}
}

# 配置容器启动的参数
init_config() {
    chattr +i ${WHOLE_PATH}
}

# 运行容器
docker_run() {
    TIPS="${CRED}环境不充足，请重新安装服务器基础环境组件和必要安装包，运行【 curl -sSL https://gsgameshare.com/gsenv | bash 】${CEND}"
    docker info >&/dev/null
    if [ $? -ne 0 ]; then
        echo -e $TIPS
        exit 1
    fi
    docker-compose >&/dev/null
    if [ $? -ne 0 ]; then
        echo -e $TIPS
        exit 1
    fi
    # 开始根据编排工具安装
    if [ -f ${OFFLINE_TAR} ]; then
        cd /root &&
            tar zxf ${OFFLINE_TAR} -C /root &&
            cd /root/gs_tl_offline

        for file in $(ls -l /root/gs_tl_offline | awk '{print $9}'); do
            if [ -n ${file} ]; then
                docker import ${file}
            fi
        done
    else
        cd ${ROOT_PATH}/${GSDIR} && docker-compose up -d
    fi

    if [ $? -eq 0 ]; then
        echo "success" >${ROOT_PATH}/${GSDIR}/gs.lock
        echo -e "${CGREEN}环境安装成功！！，配置文件已初始化为默认配置。如不想使用默认参数，请使用[setconfig]命令进行所有端口与密码的修改！！！${CEND}"
    else
        echo -e "${CRED}环境安装失败，配置文件已经初始化。更多命令执行 【gs】查看${CRED}"
    fi
}

# 如果重复使用，则需要跳过。
# 部署备份脚本
docker ps --format "{{.Names}}" | grep gsserver
if [ $? -eq 0 ] || [ -f "${ROOT_PATH}/${GSDIR}/gs.lock" ]; then
    curgs && swap
else
    if [ ! -d ${ROOT_PATH}/${GSDIR} ]; then
        download
    fi

    if [ -f ${WHOLE_PATH} ]; then
        . ${WHOLE_PATH}
    else
        echo -e "${CYELLOW}GS专用环境容器还没下载下来，请重新执行【$0】命令！${CEND}"
        exit 1
    fi

    init_config &&
        docker_run && curgs && swap
fi
echo -e "${CYELLOW}【GS游享网】环境已初始化配置参数，如上所示，请保管好参数，如需重新配置，请执行【setconfig】命令！获取命令帮助请使用 [gs] 命令${CEND}"
