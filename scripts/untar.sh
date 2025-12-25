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
# Date :  2021-07-05
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 解压tar.gz文件包到指定的目录，并给相应的权限
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

if [ -f "/root/tlbb.tar.gz" ]; then
    tar zcf tlgame-$(date +%Y%m%d%H%I%S)${SUFFIX} ${TLBB_PATH} &&
        rm -rf ${TLBB_PATH} &&
        tar zxf /root/tlbb.tar.gz -C /tlgame/ >/dev/null 2>&1 &&
        # chown -R root:root /tlgame &&
        # chmod -R 777 /tlgame &&
        mv /root/tlbb.tar.gz /root/$(date +%Y%m%d%H%I%S)-tlbb.tar.gz

    echo -e "${CSUCCESS}服务端文件【tlbb.tar.gz】已经解压成功！接下来可以执行【 setini 】进行配置文件写入！${CEND}"
    exit 0
elif [ -f "/root/tlbb.zip" ]; then
    tar zcf tlgame-$(date +%Y%m%d%H%I%S)${SUFFIX} ${TLBB_PATH} &&
        rm -rf ${TLBB_PATH} &&
        unzip -q ~/tlbb.zip -d /tlgame/ >/dev/null 2>&1 &&
        # chmod -R 777 /tlgame &&
        mv ~/tlbb.zip ~/$(date +%Y%m%d%H%I%S)-tlbb.zip

    echo -e "${CSUCCESS}服务端文件【tlbb.zip】 已经解压成功！，可以执行【 setini 】进行配置文件写入${CEND}"
    exit 0
else
    echo -e "${GSISSUE}\r\n"
    echo -e "${CRED}服务端文件不存在，或者位置上传错误，请上传至 [/root] 目录下面${CEND}"
    exit 1
fi
