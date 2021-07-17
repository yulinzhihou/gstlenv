#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-07-05
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 当用户需要重新生成数据库端口，密码时，则使用此命令进行重装写入配置，注意，执行完成后需要重启服务器再进行配置。否则需要使用 upenv.d 让数据临时生效
# 修改billing参数
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

FILE_PATH="/root/.gs/"

if [ -e ${FILE_PATH} ] && [ ! -f ${FILE_PATH}.env ]; then
  cd ${FILE_PATH} && \cp -rf env.sample .env && source ${FILE_PATH}.env
fi

if [ -f ${WHOLE_PATH} ]; then
    echo -e "${CYELLOW}即将设置服务器环境配置荐，请仔细！！${CEND}"
    chattr -i ${WHOLE_PATH}
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
    \cp -rf ${WHOLE_PATH} /usr/local/bin/.env
    chattr +i ${WHOLE_PATH}
else 
    echo -e "GS专用环境容器还没下载下来，请重新执行【gstl】命令！"
    exit 1;
fi
#############################################################################################################################
# 配置完成，加载读取配置。进行重新生成

# 先停止容器，再将容器删除，重新根据镜像文件以及配置文件，通过docker-compose重新生成容器环境
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
# 开环境
cd ${ROOT_PATH}/${GSDIR} && docker-compose up -d
if [ $? == 0 ]; then
  echo -e "${CSUCCESS} 配置写入成功！！${CEND}"
else
  echo -e "${CRED} 配置写入失败，请移除环境重新安装！！${CEND}"
fi
