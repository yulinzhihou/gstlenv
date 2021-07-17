#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-06-30
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# 检测是不是root用户。不是则退出
if [ -f /usr/local/bin/color ]; then
    . /usr/local/bin/color
fi
[ $(id -u) != "0" ] && { echo "${CFAILURE}错误: 你必须使用ROOT用户${CEND}"; exit 1; }
# comment: 安装天龙环境docker
DOCKERNAME='gsdocker'
# 容器配置根目录
GSDIR='.gs'
# 容器存放的父级目录
ROOT_PATH='/root'
# 容器配置文件名称
CONFIG_FILE='.env'
# 容器配置文件绝对路径
WHOLE_PATH='/root/.gs/.env'
# 容器下载临时路径
TMP_PATH='/opt'
# 容器打包文件后缀
SUFFIX='.tar.gz'
# 容器完整包名称
WHOLE_NAME=${DOCKERNAME}${SUFFIX}

# 授权
login(){
    # 实现shell请求登录接口
    URL='http://grav.test'
    printf "Username: "
    read username
    printf "Password: "
    stty -echo
    read pass
    printf "\n"
    stty echo
    RESULT=${pass} | sed -e "s/^/-u ${username}:/" | curl --url "${url}" -K-
    unset username
    unset pass
    echo $RESULT
}

# 下载容器参数
download() {
    # gs docker 镜像
    cd ${TMP_PATH} && \
    wget -q https://gsgameshare.com/${WHOLE_NAME} -O ${TMP_PATH}/${WHOLE_NAME} && \
    tar zxf ${WHOLE_NAME} && mv ${DOCKERNAME} ${ROOT_PATH}/${GSDIR} && \
    chown -R root:root ${ROOT_PATH}/${GSDIR} && \
    cd ${ROOT_PATH}/${GSDIR} && \cp -rf env.sample .env && rm -rf ${TMP_PATH}/${WHOLE_NAME} 
}

# 配置容器启动的参数
init_config(){
    echo -e "${CYELLOW}即将设置服务器环境配置荐，请仔细！！${CEND}"
    chattr -i ${WHOLE_PATH}
    if [ -f ${WHOLE_PATH} ]; then
        # 配置BILLING_PORT
        while :; do echo
            read -e -p "当前【Billing验证端口】为：${CBLUE}[${BILLING_PORT}]${CEND}，是否需要修改【Billing验证端口】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n' ${CEND}"
            else
            if [ "${IS_MODIFY}" == 'y' ]; then
                while :; do echo
                read -p "请输入【Billing验证端口】：(默认: ${BILLING_DEFAULT_PORT}): " BILLING_NEW_PORT
                BILLING_NEW_PORT=${BILLING_NEW_PORT:-${BILLING_DEFAULT_PORT}}
                if [ ${BILLING_NEW_PORT} == ${BILLING_DEFAULT_PORT} >/dev/null 2>&1 -o ${BILLING_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${BILLING_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
                    sed -i "s/BILLING_PORT=.*/BILLING_PORT=${BILLING_NEW_PORT}/g" ${WHOLE_PATH}
                    break
                else
                    echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
                fi
                done
            fi
            break;
            fi
        done

        # 修改MYSQL_PORT
        while :; do echo
            read  -e -p "当前【mysql端口】为：${CBLUE}[${TL_MYSQL_PORT}]${CEND}，是否需要修改【mysql端口】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【mysql端口】为：[${TL_MYSQL_PORT}]${CEND}"
            else
            if [ "${IS_MODIFY}" == 'y' ]; then
                while :; do echo
                read -p "请输入【mysql端口】：(默认: ${TL_MYSQL_DEFAULT_PORT}): " TL_MYSQL_NEW_PORT
                TL_MYSQL_NEW_PORT=${TL_MYSQL_NEW_PORT:-${TL_MYSQL_DEFAULT_PORT}}
                if [ ${TL_MYSQL_NEW_PORT} -eq ${TL_MYSQL_DEFAULT_PORT} >/dev/null 2>&1 -o ${TL_MYSQL_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${TL_MYSQL_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
                    sed -i "s/TL_MYSQL_PORT=.*/TL_MYSQL_PORT=${TL_MYSQL_NEW_PORT}/g" ${WHOLE_PATH}
                    break
                else
                    echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
                fi
                done
            fi
            break
            fi
        done
        
        # 修改登录端口 LOGIN_PORT
        while :; do echo
            read  -e -p "当前【登录端口】为：${CBLUE}[${LOGIN_PORT}]${CEND}，是否需要修改【登录端口】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【登录端口】为：[${LOGIN_PORT}]${CEND}"
            else
            if [ "${IS_MODIFY}" == 'y' ]; then
                while :; do echo
                read -p "请输入【登录端口】：(默认: ${LOGIN_DEFAULT_PORT}): " LOGIN_NEW_PORT
                LOGIN_NEW_PORT=${LOGIN_NEW_PORT:-${LOGIN_PORT}}
                if [ ${LOGIN_NEW_PORT} -eq ${LOGIN_DEFAULT_PORT} >/dev/null 2>&1 -o ${LOGIN_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${LOGIN_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
                    sed -i "s/LOGIN_PORT=.*/LOGIN_PORT=${LOGIN_NEW_PORT}/g" ${WHOLE_PATH}
                    break
                else
                    echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
                fi
                done
            fi
            break
            fi
        done

        # 修改GAME_PORT
        while :; do echo
            read  -e -p "当前【游戏端口】为：${CBLUE}[${SERVER_PORT}]${CEND}，是否需要修改【游戏端口】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【游戏端口】为：[${SERVER_PORT}]${CEND}"
            else
            if [ "${IS_MODIFY}" == 'y' ]; then
                while :; do echo
                read -p "请输入【游戏端口】：(默认: ${SERVER_DEFAULT_PORT}): " SERVER_NEW_PORT
                SERVER_NEW_PORT=${SERVER_NEW_PORT:-${SERVER_DEFAULT_PORT}}
                if [ ${SERVER_NEW_PORT} -eq ${SERVER_DEFAULT_PORT} >/dev/null 2>&1 -o ${SERVER_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${SERVER_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
                    sed -i "s/SERVER_PORT=.*/SERVER_PORT=${SERVER_NEW_PORT}/g" ${WHOLE_PATH}
                    break
                else
                    echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
                fi
                done
            fi
            break
            fi
        done

        # 修改 WEB_PORT
        while :; do echo
            read  -e -p "当前【网站端口】为：${CBLUE}[${WEB_PORT}]${CEND}，是否需要修改【网站端口】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【网站端口】为：[${WEB_PORT}]${CEND}"
            else
            if [ "${IS_MODIFY}" == 'y' ]; then
                while :; do echo
                read -p "请输入【网站端口】：(默认: ${WEB_DEFAULT_PORT}): " WEB_NEW_PORT
                WEB_NEW_PORT=${WEB_NEW_PORT:-${WEB_PORT}}
                if [ ${WEB_NEW_PORT} -eq ${WEB_DEFAULT_PORT} >/dev/null 2>&1 -o ${WEB_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${WEB_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
                    sed -i "s/WEB_PORT=.*/WEB_PORT=${WEB_NEW_PORT}/g" ${WHOLE_PATH}
                    break
                else
                    echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
                fi
                done
            fi
            break
            fi
        done

        # 修改数据库密码
        while :; do echo
            read  -e -p "当前【数据库密码】为：${CBLUE}[${TL_MYSQL_PASSWORD}]${CEND}，是否需要修改【数据库密码】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【数据库密码】为：[${TL_MYSQL_PASSWORD}]${CEND}"
            else
            if [ "${IS_MODIFY}" == 'y' ]; then
                while :; do echo
                read -p "请输入【数据库密码】(默认: ${TL_MYSQL_DEFAULT_PASSWORD}): " TL_MYSQL_NEW_PASSWORD
                TL_MYSQL_NEW_PASSWORD=${TL_MYSQL_NEW_PASSWORD:-${TL_MYSQL_PASSWORD}}
                if (( ${#TL_MYSQL_NEW_PASSWORD} >= 5 )); then
                    sed -i "s/TL_MYSQL_PASSWORD=.*/TL_MYSQL_PASSWORD=${TL_MYSQL_NEW_PASSWORD}/g" ${WHOLE_PATH}
                    break
                else
                    echo "${CWARNING}密码最少要6个字符! ${CEND}"
                fi
                done
            fi
            break
            fi
        done
    else 
        echo -e "GS专用环境容器还没下载下来，请重新执行【$0】命令！"
        exit 1;
    fi
    \cp -rf ${WHOLE_PATH} /usr/local/bin/.env
    chattr +i ${WHOLE_PATH}
}

# 运行容器
docker_run() {
    TIPS="${CRED}环境不充足，请重新安装服务器基础环境组件和必要安装包，运行【 wget -q https://gsgameshare.com/gsenv -O ./gsenv && bash gsenv 】${CEND}"
    docker info >& /dev/null
    if [ $? -ne 0 ]; then
        echo -e $TIPS
        exit 1;
    fi
    docker-compose  >& /dev/null
    if [ $? -ne 0 ]; then
        echo -e $TIPS
        exit 1;
    fi
    # 开始根据编排工具安装
    cd ${ROOT_PATH}/${GSDIR} && docker-compose up -d
    if [ $? -eq 0 ]; then
        echo -e "${CBLUE}环境安装成功，配置文件已经初始化。更多命令执行 【gs】查看${CEND}"
        exit 1;
    else
        echo -e "${CRED}环境安装失败，配置文件已经初始化。更多命令执行 【gs】查看${CEND}"
        exit 1;
    fi
}

if [ ! -d ${ROOT_PATH}/${GSDIR} ]; then
    download
fi

if [ -f ${WHOLE_PATH} ]; then
    . ${WHOLE_PATH}
else 
    echo -e "GS专用环境容器还没下载下来，请重新执行【$0】命令！"
    exit 1;
fi

init_config
docker_run