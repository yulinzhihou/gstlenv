#!/usr/bin/env bash
# 设置字符编码，确保中文正常显示
# 尝试设置 locale，如果失败则静默处理（不显示警告）
# 使用命令块包裹并重定向所有错误输出，彻底屏蔽警告信息
{
    export LANG=C.UTF-8 2>/dev/null || export LANG=en_US.UTF-8 2>/dev/null || export LANG=POSIX 2>/dev/null || true
    export LC_ALL=C.UTF-8 2>/dev/null || export LC_ALL=en_US.UTF-8 2>/dev/null || export LC_ALL=POSIX 2>/dev/null || true
} 2>/dev/null
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-10-02
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 删除调试日志，防止服务端启动时间长，导致服务器硬盘被日志挤爆
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
    # 颜色代码
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

    # 先判断目录是否存在
    if [ -f ${TLBB_PATH}"/Server/Log" ]; then
        # 存在目录则进行打印监听，通过传入的 login ShareMemory world等进程的参数进行查看
        rm -rf ${TLBB_PATH}"/Server/Log"
    fi

    if [ $? -eq 0 ]; then
        echo -e "${CSUCCESS} 清理成功！如果需要重新打开，请使用【gslog】,请使用完一定记得关闭。小心挤爆服务器硬盘！${CEND}"
        exit 0
    else
        echo -e "${GSISSUE}\r\n"
        exit 1
    fi
else
    echo -e "${GSISSUE}\r\n"
    echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
    exit 1
fi
