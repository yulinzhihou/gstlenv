#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 备份数据库功能和打包服务端
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

FILENAME="`date +%Y_%m_%d_%H_%M_%S`"
FILEPATH="/tlgame/backup/"
LOG_FILE="backup.log"


if [ ! -d ${FILEPATH} ]; then
    mkdir -p ${FILEPATH}
fi

#备份数据库文件
mv /tlgame/tlmysql/*.sql ${FILEPATH}
#判断是否备份成功
if [[ $? -eq 0 ]]; then
    echo -e "`date '+%Y-%m-%d-%H-%M-%S'`\ttlbbdb-${FILENAME}.sql\t备份成功!!">>${FILEPATH}${LOG_FILE}
    echo -e "`date '+%Y-%m-%d-%H-%M-%S'`\tweb-${FILENAME}.sql\t备份成功">>${FILEPATH}${LOG_FILE}
else
    echo -e "`date '+%Y-%m-%d-%H-%M-%S'`\ttlbbdb-${FILENAME}.sql\t备份失败">>${FILEPATH}${LOG_FILE}
    echo -e "`date '+%Y-%m-%d-%H-%M-%S'`\tweb-${FILENAME}.sql\t备份失败">>${FILEPATH}${LOG_FILE}
fi
#备份服务端
tar zcf tlbb-${FILENAME}.tar.gz /tlgame/tlbb
#判断是否备份成功
if [ $? -eq 0 ]; then
    echo -e "${CSUCCESS}`date '+%Y-%m-%d-%H-%M-%S'`\ttlbb-${FILENAME}.tar.gz\t备份成功!!${CEND}">>${FILEPATH}${LOG_FILE}
else
    echo -e "${CRED}`date '+%Y-%m-%d-%H-%M-%S'`\ttlbb-${FILENAME}.tar.gz\t备份失败${CEND}">>${FILEPATH}${LOG_FILE}
fi

