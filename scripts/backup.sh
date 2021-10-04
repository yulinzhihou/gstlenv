#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-07-18
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 手动执行备份数据库功能和打包服务端
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

FILENAME="$(date +%Y_%m_%d_%H_%M_%S)"
FILEPATH="/tlgame/backup/"
LOG_FILE="backup.log"

if [ ! -d ${FILEPATH} ]; then
  mkdir -p ${FILEPATH}
fi

backup_tlbb() {
  #备份服务端
  cd /tlgame && tar zcf tlbb-${FILENAME}.tar.gz tlbb
  #判断是否备份成功
  if [ $? -eq 0 ]; then
    echo -e "${CSUCCESS}$(date '+%Y-%m-%d-%H-%M-%S')\ttlbb-${FILENAME}.tar.gz\t备份成功!!${CEND}" >>${FILEPATH}${LOG_FILE}
  else
    echo -e "${CRED}$(date '+%Y-%m-%d-%H-%M-%S')\ttlbb-${FILENAME}.tar.gz\t备份失败${CEND}" >>${FILEPATH}${LOG_FILE}
  fi

  #清理7天前的，也就是保留7天的数据
  find /tlgame/backup/ -name "*.tar.gz" -type f -mtime +7 -exec rm -rf {} \; >/dev/null 2>&1
}

backup_mysql() {
  docker exec -it gsmysql /bin/sh /var/lib/mysql/gsmysqlBackup.sh
  #判断是否备份成功
  if [ $? -eq 0 ]; then
    echo -e "${CSUCCESS}$(date '+%Y-%m-%d-%H-%M-%S')\tgsmysqlBackup\t备份成功!!${CEND}" >>${FILEPATH}${LOG_FILE}
  else
    echo -e "${CRED}$(date '+%Y-%m-%d-%H-%M-%S')\tgsmysqlBackup\t备份失败${CEND}" >>${FILEPATH}${LOG_FILE}
  fi
  #清理7天前的，也就是保留7天的数据
  find /tlgame/backup/ -name "*.sql" -type f -mtime +7 -exec rm -rf {} \; >/dev/null 2>&1
}

if [ $# -eq 0 ]; then
  #表示只备份服务端版本。
  backup_tlbb
else
  if [ $1 == 'all' ]; then
    backup_tlbb
    backup_mysql
    if [ $? == 0 ]; then
      echo -e "${CSUCCESS} 已经成功备份完成，备份文件在 [/tlgame/backup] 目录下${CEND}"
    else
      echo -e "${CRED} 备份失败！${CEND}"
    fi
  fi
fi

mv /tlgame/gsmysql/*.sql ${FILEPATH} && mv *.tar.gz ${FILEPATH}
