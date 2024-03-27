#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-07-05
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 当用户需要重新生成数据库端口，密码时，则使用此命令进行重装写入配置，注意，执行完成后需要重启服务器再进行配置。否则需要使用 upenv.d 让数据临时生效
# 修改billing参数
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

FILE_PATH="/root/.gs/"

# 设置配置参数
setconfig_rebuild() {
    if [ -f ${GS_WHOLE_PATH} ]; then
        echo "${CMAGENTA}如果选择了W机+L机模式，则本服务器不要开启 [billing] 服务！！！${CEND}"
        echo "${CYELLOW}即将设置服务器环境配置荐，请仔细！！注意：W机=Windows服务器，L机=Linux服务器${CEND}"
        echo "${CYELLOW}0=单L机验证，Linux服务器做验证机器，即只需要一台服务器即可${CEND}"
        echo "${CYELLOW}1=W机验证+L机，Windows服务器做验证机器,L机不要开验证服务${CEND}"
        chattr -i ${GS_WHOLE_PATH}
        while :; do
            echo
            read -e -p "当前【服务器】选择为${CYELLOW}["${IS_DLQ}"]${CEND}，是否需要修改【1=W机验证+L机，0=单L机验证】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 y 或者 n ${CEND}"
            else
                if [ "${IS_MODIFY}" == 'y' ]; then
                    while :; do
                        echo
                        read -e -p "请输入【服务器,1=W机验证+L机，0=单L机验证】(默认: [${IS_DEFAULT_DLQ}]): " IS_NEW_DLQ
                        IS_NEW_DLQ=${IS_NEW_DLQ:-${IS_DEFAULT_DLQ}}
                        case ${IS_NEW_DLQ} in
                        0 | 1)
                            sed -i "s/IS_DLQ=.*/IS_DLQ=${IS_NEW_DLQ}/g" ${GS_WHOLE_PATH}
                            break
                            ;;
                        *)
                            echo "${CWARNING}输入错误! 服务器：1=W机验证+L机，0=单L机${CEND}"
                            break
                            ;;
                        esac
                    done
                else
                    IS_NEW_DLQ=0
                fi
                break
            fi
        done

        # 判断是否输入的是需要登录器。
        if [ ${IS_NEW_DLQ} == '1' ]; then
            while :; do
                echo
                read -e -p "请输入【验证服务器IP地址】(默认: ${BILLING_DEFAULT_SERVER_IPADDR}): " BILLING_NEW_SERVER_IPADDR
                BILLING_NEW_SERVER_IPADDR=${BILLING_NEW_SERVER_IPADDR:-${BILLING_DEFAULT_SERVER_IPADDR}}
                read -e -p "请再次输入【验证服务器IP地址】(默认: ${BILLING_DEFAULT_SERVER_IPADDR}): " BILLING_NEW2_SERVER_IPADDR
                BILLING_NEW2_SERVER_IPADDR=${BILLING_NEW2_SERVER_IPADDR:-${BILLING_DEFAULT_SERVER_IPADDR}}
                # 正则验证是否有效IP
                regex="\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\b"

                [ ${BILLING_NEW_SERVER_IPADDR} = ${BILLING_NEW2_SERVER_IPADDR} ] && ckStep1=0 || ckStep1=1
                ckStep2=$(echo $BILLING_NEW_SERVER_IPADDR | egrep $regex | wc -l)
                ckStep3=$(echo $BILLING_NEW2_SERVER_IPADDR | egrep $regex | wc -l)
                if [[ ${ckStep2} -eq 0 ]] || [[ ${ckStep3} -eq 0 ]]; then
                    echo -e "${CRED}服务器IP地址输入有误，请重新输入${CEND}"
                    exit 1
                fi

                if [[ ${ckStep1} -eq 0 ]]; then
                    sed -i "s/BILLING_SERVER_IPADDR=.*/BILLING_SERVER_IPADDR=${BILLING_NEW_SERVER_IPADDR}/g" ${GS_WHOLE_PATH}
                    break
                else
                    echo -e "${CRED}两次输入的IP不一致，请重新输入${CEND}"
                    exit 1
                fi
            done
        fi

        # 配置BILLING_PORT
        while :; do
            echo
            read -e -p "当前【Billing验证端口】为：${CYELLOW}[${BILLING_PORT}]${CEND}，是否需要修改【Billing验证端口】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n' ${CEND}"
                exit 1
            else
                if [ "${IS_MODIFY}" == 'y' ]; then
                    while :; do
                        echo
                        read -e -p "请输入【Billing验证端口】：(默认: ${BILLING_DEFAULT_PORT}): " BILLING_NEW_PORT
                        BILLING_NEW_PORT=${BILLING_NEW_PORT:-${BILLING_DEFAULT_PORT}}
                        if [ ${BILLING_NEW_PORT} == ${BILLING_DEFAULT_PORT} -o ${BILLING_NEW_PORT} -gt 1024 -a ${BILLING_NEW_PORT} -lt 65535 ] >/dev/null 2>&1 >/dev/null 2>&1 >/dev/null 2>&1; then
                            sed -i "s/BILLING_PORT=.*/BILLING_PORT=${BILLING_NEW_PORT}/g" ${GS_WHOLE_PATH}
                            break
                        else
                            echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
                            exit 1
                        fi
                    done
                fi
                break
            fi
        done

        # 修改MYSQL_PORT
        while :; do
            echo
            read -e -p "当前【mysql端口】为：${CYELLOW}[${TL_MYSQL_PORT}]${CEND}，是否需要修改【mysql端口】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CRED}输入错误! 请输入 'y' 或者 'n',当前【mysql端口】为：[${TL_MYSQL_PORT}]${CEND}"
            else
                if [ "${IS_MODIFY}" == 'y' ]; then
                    while :; do
                        echo
                        read -e -p "请输入【mysql端口】：(默认: ${TL_MYSQL_DEFAULT_PORT}): " TL_MYSQL_NEW_PORT
                        TL_MYSQL_NEW_PORT=${TL_MYSQL_NEW_PORT:-${TL_MYSQL_DEFAULT_PORT}}
                        if [ ${TL_MYSQL_NEW_PORT} -eq ${TL_MYSQL_DEFAULT_PORT} -o ${TL_MYSQL_NEW_PORT} -gt 1024 -a ${TL_MYSQL_NEW_PORT} -lt 65535 ] >/dev/null 2>&1 >/dev/null 2>&1 >/dev/null 2>&1; then
                            sed -i "s/TL_MYSQL_PORT=.*/TL_MYSQL_PORT=${TL_MYSQL_NEW_PORT}/g" ${GS_WHOLE_PATH}
                            break
                        else
                            echo "${CRED}输入错误! 端口范围: 1025~65534${CEND}"
                            exit 1
                        fi
                    done
                fi
                break
            fi
        done

        # 修改登录端口 LOGIN_PORT
        while :; do
            echo
            read -e -p "当前【登录端口】为：${CYELLOW}[${LOGIN_PORT}]${CEND}，是否需要修改【登录端口】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【登录端口】为：[${LOGIN_PORT}]${CEND}"
            else
                if [ "${IS_MODIFY}" == 'y' ]; then
                    while :; do
                        echo
                        read -e -p "请输入【登录端口】：(默认: ${LOGIN_DEFAULT_PORT}): " LOGIN_NEW_PORT
                        LOGIN_NEW_PORT=${LOGIN_NEW_PORT:-${LOGIN_PORT}}
                        if [ ${LOGIN_NEW_PORT} -eq ${LOGIN_DEFAULT_PORT} -o ${LOGIN_NEW_PORT} -gt 1024 -a ${LOGIN_NEW_PORT} -lt 65535 ] >/dev/null 2>&1 >/dev/null 2>&1 >/dev/null 2>&1; then
                            sed -i "s/LOGIN_PORT=.*/LOGIN_PORT=${LOGIN_NEW_PORT}/g" ${GS_WHOLE_PATH}
                            break
                        else
                            echo "${CRED}输入错误! 端口范围: 1025~65534${CEND}"
                            exit 1
                        fi
                    done
                fi
                break
            fi
        done

        # 修改GAME_PORT
        while :; do
            echo
            read -e -p "当前【游戏端口】为：${CYELLOW}[${SERVER_PORT}]${CEND}，是否需要修改【游戏端口】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【游戏端口】为：[${SERVER_PORT}]${CEND}"
            else
                if [ "${IS_MODIFY}" == 'y' ]; then
                    while :; do
                        echo
                        read -e -p "请输入【游戏端口】：(默认: ${SERVER_DEFAULT_PORT}): " SERVER_NEW_PORT
                        SERVER_NEW_PORT=${SERVER_NEW_PORT:-${SERVER_DEFAULT_PORT}}
                        if [ ${SERVER_NEW_PORT} -eq ${SERVER_DEFAULT_PORT} -o ${SERVER_NEW_PORT} -gt 1024 -a ${SERVER_NEW_PORT} -lt 65535 ] >/dev/null 2>&1 >/dev/null 2>&1 >/dev/null 2>&1; then
                            sed -i "s/SERVER_PORT=.*/SERVER_PORT=${SERVER_NEW_PORT}/g" ${GS_WHOLE_PATH}
                            break
                        else
                            echo -e "${CRED}输入错误! 端口范围: 1025~65534${CEND}"
                            exit 1
                        fi
                    done
                fi
                break
            fi
        done

        # 修改 WEB_PORT
        while :; do
            echo
            read -e -p "当前【网站端口】为：${CYELLOW}[${WEB_PORT}]${CEND}，是否需要修改【网站端口】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【网站端口】为：[${WEB_PORT}]${CEND}"
            else
                if [ "${IS_MODIFY}" == 'y' ]; then
                    while :; do
                        echo
                        read -e -p "请输入【网站端口】：(默认: ${WEB_DEFAULT_PORT}): " WEB_NEW_PORT
                        WEB_NEW_PORT=${WEB_NEW_PORT:-${WEB_PORT}}
                        if [ ${WEB_NEW_PORT} -eq ${WEB_DEFAULT_PORT} -o ${WEB_NEW_PORT} -gt 1 -a ${WEB_NEW_PORT} -lt 65535 ] >/dev/null 2>&1 >/dev/null 2>&1 >/dev/null 2>&1; then
                            sed -i "s/WEB_PORT=.*/WEB_PORT=${WEB_NEW_PORT}/g" ${GS_WHOLE_PATH}
                            break
                        else
                            echo -e "${CRED}输入错误! 端口范围: 1~65534${CEND}"
                            exit 1
                        fi
                    done
                fi
                break
            fi
        done

        # 修改数据库密码
        while :; do
            echo
            read -e -p "当前【数据库密码】为：${CYELLOW}[${TL_MYSQL_PASSWORD}]${CEND}，是否需要修改【数据库密码】 [y/n](默认: n): " IS_MODIFY
            IS_MODIFY=${IS_MODIFY:-'n'}
            if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
                echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【数据库密码】为：[${TL_MYSQL_PASSWORD}]${CEND}"
            else
                if [ "${IS_MODIFY}" == 'y' ]; then
                    while :; do
                        echo
                        read -e -p "请输入【数据库密码】(默认: ${TL_MYSQL_DEFAULT_PASSWORD}): " TL_MYSQL_NEW_PASSWORD
                        TL_MYSQL_NEW_PASSWORD=${TL_MYSQL_NEW_PASSWORD:-${TL_MYSQL_PASSWORD}}
                        if ((${#TL_MYSQL_NEW_PASSWORD} >= 5)); then
                            sed -i "s/TL_MYSQL_PASSWORD=.*/TL_MYSQL_PASSWORD=${TL_MYSQL_NEW_PASSWORD}/g" ${GS_WHOLE_PATH}
                            break
                        else
                            echo "${CRED}密码最少要6个字符! ${CEND}"
                            exit 1
                        fi
                    done
                fi
                break
            fi
        done
        echo "${CYELLOW}请稍等，正在写入配置信息……${CEND}"
        chattr +i ${GS_WHOLE_PATH}
    else
        echo -e "${GSISSUE}\r\n"
        echo -e "GS专用环境容器还没下载下来，请重新执行【 curl -sSL https://gitee.com/yulinzhihou/gstlenv/raw/master/gsenv.sh | bash 】命令！"
        exit 1
    fi
    # 先停止容器，再将容器删除，重新根据镜像文件以及配置文件，通过docker-compose重新生成容器环境
    docker stop gsmysql gsnginx gsserver gsphp gsredis &&
        docker rm -f gsmysql gsnginx gsserver gsphp gsredis &&
        rm -rf /tlgame/gsmysql/mysql
}

# 备份数据
setconfig_backup() {
    echo -ne "正在备份版本数据请稍候……\r"
    [ ! -d /tlgame/backup ] && mkdir /tlgame/backup
    cd /tlgame && tar zcf tlbb-setconfig-backup.tar.gz tlbb &&
        docker exec -d gsmysql /bin/bash /usr/local/bin/gsmysqlBackup.sh
}

# 还原数据
setconfig_restore() {
    echo -ne "正在还原修改参数之前的数据库与版本请稍候……\r"
    if [ -f "/tlgame/tlbb-setconfig-backup.tar.gz" ]; then
        cd /tlgame && tar zxf tlbb-setconfig-backup.tar.gz && mv /tlgame/tlbb-setconfig-backup.tar.gz /tlgame/backup
        docker exec -d gsmysql /bin/bash /usr/local/bin/gsmysqlRestore.sh
    fi
}

# 核心调用
main() {
    for ((time = 3; time >= 0; time--)); do
        echo -ne "\r在准备正行重新生成配置文件操作！！，剩余 ${CRED}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！"
        sleep 1
    done
    #
    while :; do
        echo
        echo -e "${CYELLOW}请选择是否需要保留原来的版本与数据库${CEND}"
        echo -e "${CYELLOW}如果是刚刚搭建环境成功，则不需要保留原来版本和数据。请选择[n]${CEND}"
        read -e -p "${CYELLOW}保留请输入[y],不保留请输入[n],默认是保留[y]:${CEND} " IS_MODIFY
        IS_MODIFY=${IS_MODIFY:-'y'}
        if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
            echo "${CWARNING}输入错误! 请输入 y 或者 n ${CEND}"
        else
            . /root/.gs/.env
            if [ "${IS_MODIFY}" == 'y' ]; then
                # 备份数据
                setconfig_backup &&
                    # 设置参数
                    setconfig_rebuild &&
                    # 开环境
                    cd ${ROOT_PATH}/${GSDIR} && docker-compose up -d &&
                    # 还原数据
                    setconfig_restore

                if [ ! -d /tlgame/tlbb/Server/Config ]; then
                    echo -e "${CSUCCESS}未发现版本，请上传版本后依次执行 【 untar 】【 setini 】【 runtlbb 】进行开服！！${CEND}"
                    exit 0
                else
                    setini
                fi
            else
                # 设置参数
                setconfig_rebuild &&
                    # 开环境
                    cd ${ROOT_PATH}/${GSDIR} && docker-compose up -d &&
                    rm -rf /tlgame/tlbb-setconfig-backup.tar.gz &&
                    docker exec -it gsmysql /bin/bash /usr/local/bin/gsmysqlRestore.sh reset
            fi
            break
        fi
    done

    if [ $? -eq 0 ]; then
        echo -e "${CSUCCESS}配置写入成功！！,可以使用 【 curgs 】命令查看配置的信息${CEND}"
        exit 0
    else
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED}配置写入失败，请移除环境重新安装！！${CEND}"
        exit 1
    fi
}

main
