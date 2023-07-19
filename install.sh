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

# 获取发行版本和版本ID
get_distribution() {
    LSB_DIST=""
    LSB_DIST_VERSION=""
    if [ -r /etc/os-release ]; then
        local TEMP="$(. /etc/os-release && echo "$NAME")"
        TEMP=(${TEMP})
        LSB_DIST="${TEMP[0]}"
        LSB_DIST_VERSION="$(. /etc/os-release && echo "$VERSION_ID")"
    fi
    local ID_VERSION_ID=(${LSB_DIST} ${LSB_DIST_VERSION})
    echo "${ID_VERSION_ID[@]}"
}

# 检测命令是否存在
command_exists() {
    command -v "$@" >/dev/null 2>&1
}

# 系统组件安装
sys_plugins_install() {
    echo -e "${CYELLOW}开始安装系统常用组件 ！！！${CEND}"
    local packages="gcc wget curl git jq vim unzip zip"
    # 安装 wget gcc curl git python
    ${PM} -y install python $packages
    [ "${OS_VERSION}" == "8" ] && {
        ${PM} -y install python38 $packages
        sudo alternatives --set python /usr/bin/python3
    }
}

# 安装docker docker-compose
do_install_docker() {
    echo -e "${CYELLOW}开始安装GS游享环境核心软件 docker + docker-compose ！！！${CEND}"
    egrep "^docker" /etc/group >&/dev/null
    if [ $? -ne 0 ]; then
        sudo groupadd docker
        sudo usermod -aG docker ${USER}
        sudo gpasswd -a ${USER} docker
    fi
    # 通过 os-release 获取发行版本及ID,通过数组返回数据。[0]为发生版本，[1]为版本号
    OS_VERSION=($(get_distribution))
    OS=${OS_VERSION[0]}
    OS_VERSION=${OS_VERSION[1]}

    # 安装docker docker-compose 及导入离线镜像前，先检验sha256是否符合规则
    if [ -f /usr/bin/sha256sum ] && [ $IS_OFFLINE -eq 1 ]; then
        OS_NAME_UPPER=$(echo $OS | tr '[:lower:]' '[:upper:]')
        local PACKAGES=("gstlenv_offline.tar.gz" "gs_docker_compose.tar.gz" "gs_docker_ce.tar.gz")
        GS_DOCKER_CE="GS_DOCKER_CE_PACKAGE_"${OS_NAME_UPPER}
        local PACKAGES_SHA256=("${GS_OFFLINE_PACKAGE}" "${GS_DOCKER_COMPOSE_PACKAGE}" "${!GS_DOCKER_CE}")
        for INDEX in "${!PACKAGES[@]}"; do
            if [ -n ${PACKAGES[$INDEX]} ] && [ -f /root/${PACKAGES[$INDEX]} ]; then
                PACKAGE_TEMP=$(sha256sum /root/${PACKAGES[$INDEX]} | awk '{print $1}')
                if [ $PACKAGE_TEMP != ${PACKAGES_SHA256[$INDEX]} ]; then
                    echo -e "${CRED} GS游享环境离线镜像包 ${PACKAGES[$INDEX]} 被非法串改，请从GS游享官方人渠道下载 ！！！${CEND}"
                    exit 1
                fi
            fi
        done
    fi

    # 获取系统版本 及安装命令
    if [ "${OS}" == "CentOS" ] || [ "${OS}" == "CentOSStream" ] || [ "${OS}" == "CentOS Stream release 9" ]; then
        # 导入rpm公钥
        rpm --import config/gpg
        INSTALL_COMMAND="rpm -Uvh --nodeps --force *.rpm"
    elif [ "${OS}" == "Debian" ]; then
        INSTALL_COMMAND="sudo dpkg -i *.deb"
    elif [ "${OS}" == "Fedora" ]; then
        INSTALL_COMMAND="rpm -Uvh --nodeps --force *.rpm"
    elif [ "${OS}" == "Ubuntu" ]; then
        INSTALL_COMMAND="sudo dpkg -i *.deb"
    fi

    # 先使用本地安装脚本
    if [ ! $(command_exists docker) ]; then
        # 表示没有安装过docker,先检测离线安装包
        if [ -f /root/gs_docker_ce.tar.gz ]; then
            # 解压离线包
            cd /root && tar zxf gs_docker_ce.tar.gz
            # 检测对应离线包是否存在
            if [ -d "/root/gs_docker_ce/"${OS}/${OS_VERSION} ]; then
                # 表示安装包是完整的
                cd /root/gs_docker_ce/${OS}/${OS_VERSION} && $INSTALL_COMMAND
            else
                echo -e "${CRED}GS游享环境核心软件 docker 安装失败 ！！！${CEND}"
                exit 1
            fi
        else
            # 在线安装 docker
            if [ -f ./gsdocker.sh ]; then
                bash gsdocker.sh -s docker --mirror Aliyun --version 24.0
            else
                # 制作的国内镜像安装脚本
                curl -sSL https://gsgameshare.com/gsdocker | bash -s docker --mirror Aliyun --version 24.0
            fi
        fi

        # 兼容真离线版本，可以手动安装 docker-ce docker-ce-cli
        if [ ! -d "/etc/docker" ]; then
            sudo mkdir -p /etc/docker
        fi

        # 复制配置文件到指定位置
        \cp -rf /root/.tlgame/config/daemon.json /etc/docker

        # 安装成功后，根据不同系统，进行服务的启动与开机自动启动
        [ "${OS}" == "Debian" ] || [ "${OS}" == "Ubuntu" ] && sudo apt-get services docker start && sudo systemctl enable docker
        [ "${OS}" == "CentOS" ] || [ "${OS}" == "CentOSStream" ] || [ "${OS}" == "CentOS Stream release 9" ] && sudo systemctl daemon-reload && sudo systemctl start docker && sudo systemctl enable docker

    fi

    # 检测 docker 是否已经安装成功
    $(command_exists docker)
    if [ $? -eq 0 ]; then
        echo -e "${CYELLOW}GS游享环境核心软件 docker 安装成功 ！！！${CEND}"
    else
        echo -e "${CRED}GS游享环境核心软件 docker 安装失败 ！！！${CEND}"
        exit 1
    fi

    # 检测 docker-compose 是否存在
    # s390x：IBM System z 系列计算机的架构名称，使用大端字节序。
    # arm64：ARM 64 位处理器的架构名称，也称为 AArch64，支持 ARMv8-A 架构。
    # amd64：64 位 x86 处理器的架构名称，也称为 x86-64 或者 Intel 64，是一种扩展的 x86 架构。
    # armv6：ARMv6 架构的处理器，支持 ARMv6 指令集。
    # armv7：ARMv7 架构的处理器，支持 ARMv7 指令集。
    # darwin：苹果公司的操作系统 macOS 的系统架构名称，基于 x86 和 ARM 架构。
    # ppc64le：IBM Power 架构的 64 位处理器，使用小端字节序。
    # riscv64：RISC-V 架构的 64 位处理器，是一种开放指令集架构。
    if [ ! $(command_exists docker-compose) ] && [ ! -f /usr/local/bin/docker-compose ]; then
        if [ -f /root/gs_docker_compose.tar.gz ]; then
            local NAME=$(uname -s)
            # 转换成小写 linux，因为不是通过网络下载，不会自动转换成小写，所以这里会报错
            NAME=${NAME,,}
            cd /root && tar zxf gs_docker_compose.tar.gz && cd gs_docker_compose && mv docker-compose-$NAME-$(uname -m) /usr/local/bin/docker-compose
        else
            # 直接将 v2.20.0 版本的 docker-compose 下载到码云进行加速
            # curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            curl -L https://gitee.com/yulinzhihou/docker-compose/releases/download/v2.16.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
        fi

        if [ -f /usr/local/bin/docker-compose ]; then
            # 可以手动上传 docker-compose 到指定目录
            chmod a+x /usr/local/bin/docker-compose
        fi
    fi

    # docker-compose 安装成功
    $(command_exists docker-compose)
    if [ $? -eq 0 ]; then
        echo -e "${CYELLOW}GS游享环境核心软件 docker-compose 安装成功 ！！！ ${CEND}"
    else
        echo -e "${CRED}GS游享环境核心软件 docker-compose 安装失败 ！！！ ${CEND}"
        exit 1
    fi
}

# 配置常用命令到系统中
set_command() {
    echo -e "${CYELLOW}开始设置GS游享环境全局命令 ！！！${CEND}"
    for VAR in $(ls -l ${GS_PROJECT}/scripts/ | awk '{print $9}'); do
        if [ -n ${VAR} ]; then
            \cp -rf ${GS_PROJECT}/scripts/${VAR} /usr/local/bin/${VAR%%.*} && chmod +x /usr/local/bin/${VAR%%.*}
        fi
    done
}

# 设置服务器时间
set_timezone() {
    echo -e "${CYELLOW}开始设置时区 ！！！${CEND}"
    rm -rf /etc/localtime
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
}

# 安装整合
do_install() {
    set_timezone
    [ $? -eq 0 ] && echo -e "${CYELLOW}设置时区成功，当前时间为: $(date +"%Y-%m-%d %H:%M:%S") ${CEND}" || {
        echo -e "${CRED}设置时区失败 ！！！;${CEND}"
        exit 1
    }
    do_install_docker
    [ $? -eq 0 ] && echo -e "${CYELLOW}GS游享环境核心软件 docker, docker-compose 安装成功 ！！！ ${CEND}" || {
        echo -e "${CRED}GS游享环境核心软件 docker, docker-compose 安装失败 ！！！;${CEND}"
        exit 1
    }
    set_command
    [ $? -eq 0 ] && echo -e "${CYELLOW}设置GS游享环境全局命令成功 ！！！${CEND}" || {
        echo -e "${CRED}设置GS游享环境全局命令失败 ！！！${CEND}"
        exit 1
    }
}

# mysql 5.1 初始化
init_mysql51() {
    docker exec -d gsmysql /bin/bash /usr/local/bin/init_db.sh
}

##################################################################
# GS环境安装开始
##################################################################
startTime=$(date +%s)
# 检测是不是root用户。不是则退出
[ $(id -u) != "0" ] && {
    echo "${CFAILURE}错误: 你必须使用ROOT用户${CEND}"
    exit 1
}
#获取当前脚本路径
GSTL_DIR=$(dirname "$(readlink -f $0)")
pushd ${GSTL_DIR} >/dev/null
# 是否为离线环境，如果为离线环境，变量为1，否则为0
IS_OFFLINE=0
# 加载配置
. ./scripts/color.sh
# 检测服务器，并获取系统的发行版本及版本号
. ./include/get_os.sh

# 分配资源及配置参数
if [ ! -d /root/.gs ]; then
    mkdir -p /root/.gs
fi

if [ ! -f /root/.gs/.env ]; then
    \cp -rf env.sample /root/.gs/.env
    \cp -rf docker-compose.yml /root/.gs
fi
# 加载配置
. /root/.gs/.env

# 第一步，检测当前系统是否可以安装 docker 及 docker-compose
bash check-docker-env.sh --dry-run >/dev/null 2>&1
if [ $? != 0 ]; then
    echo -e "${CRED}当前服务器系统暂不支持本环境，请联系客服QQ:1303588722 反馈并获取适合安装的环境 ${CEND}"
    exit 1
fi

# 第二步：判断并兼容离线环境
if [ $# -eq 1 ]; then

    if [ $1 != 'local' ]; then
        echo -e "${CRED}离线环境安装命令输入错误，请输入 bash install.sh local ${CEND}"
        exit 1
    else
        # 配置离线环境变量
        IS_OFFLINE=1
    fi

    # 解压防线安装包
    if [ -f /root/gstlenv_offline.tar.gz ]; then
        [ ! -d ${SHARED_DIR} ] && mkdir -p ${SHARED_DIR}
        [ ! -d ${GS_PROJECT} ] && mkdir -p ${GS_PROJECT}

        \cp -rf ./* ${GS_PROJECT} &&
            \cp -rf docker-compose.yml /root/.gs/docker-compose.yml &&
            . ${GS_WHOLE_PATH} &&
            chmod -R 777 ${GS_PROJECT}
    fi
else
    # 调用系统组件
    sys_plugins_install
    clear
fi

# 第三步：核心调用及安装
do_install && gstl && init_mysql51
##################################################################
# GS环境安装结束
##################################################################
