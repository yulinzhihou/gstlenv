#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-09-30
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 重启服务器后开启docker服务
# 颜色代码
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
# 系统识别
if [ -f ./check_os.sh ]; then
    . ${GS_PROJECT}/scripts/check_os.sh
else
    . /usr/local/bin/check_os
fi


if [ ! -n ${OS} ]; then
    [ "${OS}" == "Debian" ] || [ "${OS}" == "Ubuntu" ] && sudo apt-get service docker start
    [ "${OS}" == "CentOS" ] && sudo systemctl daemon-reload && sudo systemctl restart docker
    # 安装 docker-compose
    [ "${OS}" == "Debian" ] || [ "${OS}" == "Ubuntu" ] && sudo apt-get service docker start
    [ "${OS}" == "CentOS" ] && sudo systemctl daemon-reload && sudo systemctl restart docker
fi

if [ $? == '0' ]; then
    echo -e "${CSUCCESS} 【docker】服务开启成功！！${CEND}"
    exit 0;
else
    echo -e "${CRED}【docker】服务开启失败，请检查配置或者与客户QQ:1303588722联系${CEND}"
    exit 1;
fi
