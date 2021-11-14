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

# 授权
login() {
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
    # echo -e "${CRED}如果选择了W机+L机模式，则本服务器不要开启 [billing] 服务！！！\r"
    # echo -e "${CYELLOW}即将设置服务器环境配置荐，请仔细！！注意：W机=Windows服务器，L机=Linux服务器${CEND}"
    chattr -i ${WHOLE_PATH}
    # if [ -f ${WHOLE_PATH} ]; then
    # 配置是游戏注册还是登录器注册
    # while :; do
    #     echo
    #     read -e -p "当前【服务器】为${CBLUE}["${IS_DLQ}"]${CEND}，是否需要修改【1=W机+L机，0=单L机】 [y/n](默认: n): " IS_MODIFY
    #     IS_MODIFY=${IS_MODIFY:-'n'}
    #     if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
    #         echo "${CWARNING}输入错误! 请输入 y 或者 n ${CEND}"
    #     else
    #         if [ "${IS_MODIFY}" == 'y' ]; then
    #             while :; do
    #                 echo
    #                 read -p "请输入【服务器,1=W机+L机，0=单L机】(默认: [${IS_DEFAULT_DLQ}]): " IS_NEW_DLQ
    #                 IS_NEW_DLQ=${IS_NEW_DLQ:-${IS_DEFAULT_DLQ}}
    #                 case ${IS_NEW_DLQ} in
    #                 0 | 1)
    #                     sed -i "s/IS_DLQ=.*/IS_DLQ=${IS_NEW_DLQ}/g" ${WHOLE_PATH}
    #                     break
    #                     ;;
    #                 *)
    #                     echo "${CWARNING}输入错误! 服务器：1=W机+L机，0=单L机${CEND}"
    #                     break
    #                     ;;
    #                 esac
    #             done
    #         else
    #             IS_NEW_DLQ=0
    #         fi
    #         break
    #     fi
    # done

    # # 判断是否输入的是需要登录器。
    # if [ ${IS_NEW_DLQ} == '1' ]; then
    #     while :; do
    #         echo
    #         read -p "请输入【验证服务器IP地址】(默认: ${BILLING_DEFAULT_SERVER_IPADDR}): " BILLING_NEW_SERVER_IPADDR
    #         BILLING_NEW_SERVER_IPADDR=${BILLING_NEW_SERVER_IPADDR:-${BILLING_DEFAULT_SERVER_IPADDR}}
    #         read -p "请再次输入【验证服务器IP地址】(默认: ${BILLING_DEFAULT_SERVER_IPADDR}): " BILLING_NEW2_SERVER_IPADDR
    #         BILLING_NEW2_SERVER_IPADDR=${BILLING_NEW2_SERVER_IPADDR:-${BILLING_DEFAULT_SERVER_IPADDR}}
    #         # 正则验证是否有效IP
    #         regex="\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\b"
    #         [[ ${BILLING_NEW_SERVER_IPADDR} == ${BILLING_NEW2_SERVER_IPADDR} ]]
    #         ckstep1=$?
    #         ckStep2=$(echo $BILLING_NEW_SERVER_IPADDR | egrep $regex | wc -l)
    #         ckStep3=$(echo $BILLING_NEW2_SERVER_IPADDR | egrep $regex | wc -l)
    #         if [[ $ckStep1 -eq 0 && $ckStep2 -eq 1 && $ckStep3 -eq 1 ]]; then
    #             sed -i "s/BILLING_SERVER_IPADDR=.*/BILLING_SERVER_IPADDR=${BILLING_NEW_SERVER_IPADDR}/g" ${WHOLE_PATH}
    #             break
    #         else
    #             echo "服务器IP地址输入有误或者两次输入的不相同!，请重新输入"
    #         fi
    #     done
    # fi

    # # 配置BILLING_PORT
    # while :; do
    #     echo
    #     read -e -p "当前【Billing验证端口】为：${CBLUE}[${BILLING_PORT}]${CEND}，是否需要修改【Billing验证端口】 [y/n](默认: n): " IS_MODIFY
    #     IS_MODIFY=${IS_MODIFY:-'n'}
    #     if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
    #         echo "${CWARNING}输入错误! 请输入 'y' 或者 'n' ${CEND}"
    #     else
    #         if [ "${IS_MODIFY}" == 'y' ]; then
    #             while :; do
    #                 echo
    #                 read -p "请输入【Billing验证端口】：(默认: ${BILLING_DEFAULT_PORT}): " BILLING_NEW_PORT
    #                 BILLING_NEW_PORT=${BILLING_NEW_PORT:-${BILLING_DEFAULT_PORT}}
    #                 if [ ${BILLING_NEW_PORT} == ${BILLING_DEFAULT_PORT} -o ${BILLING_NEW_PORT} -gt 1024 -a ${BILLING_NEW_PORT} -lt 65535 ] >/dev/null 2>&1 >/dev/null 2>&1 >/dev/null 2>&1; then
    #                     sed -i "s/BILLING_PORT=.*/BILLING_PORT=${BILLING_NEW_PORT}/g" ${WHOLE_PATH}
    #                     break
    #                 else
    #                     echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
    #                 fi
    #             done
    #         fi
    #         break
    #     fi
    # done

    # # 修改MYSQL_PORT
    # while :; do
    #     echo
    #     read -e -p "当前【mysql端口】为：${CBLUE}[${TL_MYSQL_PORT}]${CEND}，是否需要修改【mysql端口】 [y/n](默认: n): " IS_MODIFY
    #     IS_MODIFY=${IS_MODIFY:-'n'}
    #     if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
    #         echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【mysql端口】为：[${TL_MYSQL_PORT}]${CEND}"
    #     else
    #         if [ "${IS_MODIFY}" == 'y' ]; then
    #             while :; do
    #                 echo
    #                 read -p "请输入【mysql端口】：(默认: ${TL_MYSQL_DEFAULT_PORT}): " TL_MYSQL_NEW_PORT
    #                 TL_MYSQL_NEW_PORT=${TL_MYSQL_NEW_PORT:-${TL_MYSQL_DEFAULT_PORT}}
    #                 if [ ${TL_MYSQL_NEW_PORT} -eq ${TL_MYSQL_DEFAULT_PORT} -o ${TL_MYSQL_NEW_PORT} -gt 1024 -a ${TL_MYSQL_NEW_PORT} -lt 65535 ] >/dev/null 2>&1 >/dev/null 2>&1 >/dev/null 2>&1; then
    #                     sed -i "s/TL_MYSQL_PORT=.*/TL_MYSQL_PORT=${TL_MYSQL_NEW_PORT}/g" ${WHOLE_PATH}
    #                     break
    #                 else
    #                     echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
    #                 fi
    #             done
    #         fi
    #         break
    #     fi
    # done

    # # 修改登录端口 LOGIN_PORT
    # while :; do
    #     echo
    #     read -e -p "当前【登录端口】为：${CBLUE}[${LOGIN_PORT}]${CEND}，是否需要修改【登录端口】 [y/n](默认: n): " IS_MODIFY
    #     IS_MODIFY=${IS_MODIFY:-'n'}
    #     if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
    #         echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【登录端口】为：[${LOGIN_PORT}]${CEND}"
    #     else
    #         if [ "${IS_MODIFY}" == 'y' ]; then
    #             while :; do
    #                 echo
    #                 read -p "请输入【登录端口】：(默认: ${LOGIN_DEFAULT_PORT}): " LOGIN_NEW_PORT
    #                 LOGIN_NEW_PORT=${LOGIN_NEW_PORT:-${LOGIN_PORT}}
    #                 if [ ${LOGIN_NEW_PORT} -eq ${LOGIN_DEFAULT_PORT} -o ${LOGIN_NEW_PORT} -gt 1024 -a ${LOGIN_NEW_PORT} -lt 65535 ] >/dev/null 2>&1 >/dev/null 2>&1 >/dev/null 2>&1; then
    #                     sed -i "s/LOGIN_PORT=.*/LOGIN_PORT=${LOGIN_NEW_PORT}/g" ${WHOLE_PATH}
    #                     break
    #                 else
    #                     echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
    #                 fi
    #             done
    #         fi
    #         break
    #     fi
    # done

    # # 修改GAME_PORT
    # while :; do
    #     echo
    #     read -e -p "当前【游戏端口】为：${CBLUE}[${SERVER_PORT}]${CEND}，是否需要修改【游戏端口】 [y/n](默认: n): " IS_MODIFY
    #     IS_MODIFY=${IS_MODIFY:-'n'}
    #     if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
    #         echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【游戏端口】为：[${SERVER_PORT}]${CEND}"
    #     else
    #         if [ "${IS_MODIFY}" == 'y' ]; then
    #             while :; do
    #                 echo
    #                 read -p "请输入【游戏端口】：(默认: ${SERVER_DEFAULT_PORT}): " SERVER_NEW_PORT
    #                 SERVER_NEW_PORT=${SERVER_NEW_PORT:-${SERVER_DEFAULT_PORT}}
    #                 if [ ${SERVER_NEW_PORT} -eq ${SERVER_DEFAULT_PORT} -o ${SERVER_NEW_PORT} -gt 1024 -a ${SERVER_NEW_PORT} -lt 65535 ] >/dev/null 2>&1 >/dev/null 2>&1 >/dev/null 2>&1; then
    #                     sed -i "s/SERVER_PORT=.*/SERVER_PORT=${SERVER_NEW_PORT}/g" ${WHOLE_PATH}
    #                     break
    #                 else
    #                     echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
    #                 fi
    #             done
    #         fi
    #         break
    #     fi
    # done

    # # 修改 WEB_PORT
    # while :; do
    #     echo
    #     read -e -p "当前【网站端口】为：${CBLUE}[${WEB_PORT}]${CEND}，是否需要修改【网站端口】 [y/n](默认: n): " IS_MODIFY
    #     IS_MODIFY=${IS_MODIFY:-'n'}
    #     if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
    #         echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【网站端口】为：[${WEB_PORT}]${CEND}"
    #     else
    #         if [ "${IS_MODIFY}" == 'y' ]; then
    #             while :; do
    #                 echo
    #                 read -p "请输入【网站端口】：(默认: ${WEB_DEFAULT_PORT}): " WEB_NEW_PORT
    #                 WEB_NEW_PORT=${WEB_NEW_PORT:-${WEB_PORT}}
    #                 if [ ${WEB_NEW_PORT} -eq ${WEB_DEFAULT_PORT} -o ${WEB_NEW_PORT} -gt 1024 -a ${WEB_NEW_PORT} -lt 65535 ] >/dev/null 2>&1 >/dev/null 2>&1 >/dev/null 2>&1; then
    #                     sed -i "s/WEB_PORT=.*/WEB_PORT=${WEB_NEW_PORT}/g" ${WHOLE_PATH}
    #                     break
    #                 else
    #                     echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
    #                 fi
    #             done
    #         fi
    #         break
    #     fi
    # done

    # # 修改数据库密码
    # while :; do
    #     echo
    #     read -e -p "当前【数据库密码】为：${CBLUE}[${TL_MYSQL_PASSWORD}]${CEND}，是否需要修改【数据库密码】 [y/n](默认: n): " IS_MODIFY
    #     IS_MODIFY=${IS_MODIFY:-'n'}
    #     if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
    #         echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【数据库密码】为：[${TL_MYSQL_PASSWORD}]${CEND}"
    #     else
    #         if [ "${IS_MODIFY}" == 'y' ]; then
    #             while :; do
    #                 echo
    #                 read -p "请输入【数据库密码】(默认: ${TL_MYSQL_DEFAULT_PASSWORD}): " TL_MYSQL_NEW_PASSWORD
    #                 TL_MYSQL_NEW_PASSWORD=${TL_MYSQL_NEW_PASSWORD:-${TL_MYSQL_PASSWORD}}
    #                 if ((${#TL_MYSQL_NEW_PASSWORD} >= 5)); then
    #                     sed -i "s/TL_MYSQL_PASSWORD=.*/TL_MYSQL_PASSWORD=${TL_MYSQL_NEW_PASSWORD}/g" ${WHOLE_PATH}
    #                     break
    #                 else
    #                     echo "${CWARNING}密码最少要6个字符! ${CEND}"
    #                 fi
    #             done
    #         fi
    #         break
    #     fi
    # done
    # else
    #     echo -e "GS专用环境容器还没下载下来，请重新执行【$0】命令！，或者加客服QQ：1303588722反馈问题"
    #     exit 1
    # fi
    \cp -rf ${WHOLE_PATH} /usr/local/bin/.env &&
        \cp -rf ${WHOLE_PATH} /root/.tlgame/.env
    chattr +i ${WHOLE_PATH}
}

# 运行容器
docker_run() {
    TIPS="${CRED}环境不充足，请重新安装服务器基础环境组件和必要安装包，运行【 curl -sOL https://gsgameshare.com/gsenv; /bin/bash gsenv 】${CEND}"
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
    cd ${ROOT_PATH}/${GSDIR} && docker-compose up -d
    if [ $? -eq 0 ]; then
        echo "success" >${ROOT_PATH}/${GSDIR}/gs.lock
        echo -e "${CGREEN}环境安装成功，配置文件已经初始化。如果不需要使用默认参数，请使用[setconfig]命令进行所有端口与密码的修改！！！${CEND}"
    else
        echo -e "${CRED}环境安装失败，配置文件已经初始化。更多命令执行 【gs】查看${CRED}"
    fi
}

# 如果重复使用，则需要跳过。
# 部署备份脚本
. ${WHOLE_PATH}

# if [ ! -f ${GS_PROJECT}"/include/gsmysqlBackup.sh" ]; then
#     \cp -rf ${GS_PROJECT}"/include/gsmysqlBackup.sh" /tlgame/gsmysql/
#     \cp -rf ${GS_PROJECT}"/include/gsmysqlRestore.sh" /tlgame/gsmysql/
#     chmod -R 777 /tlgame/gsmysql/*.sh
# fi
docker ps --format "{{.Names}}" | grep gsserver
if [ $? -eq 0 ] || [ -f "${ROOT_PATH}/${GSDIR}/gs.lock" ]; then
    curgs && gs
else
    if [ ! -d ${ROOT_PATH}/${GSDIR} ]; then
        download
    fi

    if [ -f ${WHOLE_PATH} ]; then
        . ${WHOLE_PATH}
    else
        echo -e "${CBLUE}GS专用环境容器还没下载下来，请重新执行【$0】命令！${CEND}"
        exit 1
    fi

    init_config &&
        docker_run && curgs && gs
fi
echo -e "${CRED}GS专用环境容器已经被初始化，如果需要重新初始化，请执行【setconfig】命令！${CEND}"
