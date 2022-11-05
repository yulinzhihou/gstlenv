#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-07-06
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 定时数据备份
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
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
  # 获取数据
  if [ $# -eq 0 ]; then
    TIME=1
  else
    case $1 in
    [1-9] | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23)
      TIME=$1
      ;;
    *)
      TIME=1
      ;;
    esac
  fi

  # 数据库备份
  SQL_TASK="docker exec -d gsmysql /bin/bash /usr/local/bin/gsmysqlBackup.sh > /dev/null 2>&1 &"
  # 版本备份
  VERSION_TASK="/bin/bash /usr/local/bin/backup all > /dev/null 2>&1 &"
  # 定时清理
  CRON_DEL_TASK="/bin/bash /usr/local/bin/delbak > /dev/null 2>&1 &"
  # 定时任务临时备份文件
  CRONTAB_BAK_FILE="/tmp/crontab_bak"

  # *    *    *    *    *
  # -    -    -    -    -
  # |    |    |    |    |
  # |    |    |    |    +----- 一个星期的星期几 (0 - 7) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
  # |    |    |    +---------- 几月 (1 - 12) OR jan,feb,mar,apr ...
  # |    |    +--------------- 一个月里面的几号 (1 - 31)
  # |    +-------------------- 小时 (0 - 23)
  # +------------------------- 分钟 (0 - 59)
  #
  # 星号（*）：代表所有可能的值，例如month字段如果是星号，则表示在满足其它字段的制约条件后每月都执行该命令操作。
  # 逗号（,）：可以用逗号隔开的值指定一个列表范围，例如，“1,2,5,7,8,9”
  # 中杠（-）：可以用整数之间的中杠表示一个整数范围，例如“2-6”表示“2,3,4,5,6”
  # 正斜线（/）：可以用正斜线指定时间的间隔频率，例如“0-23/2”表示每两小时执行一次。同时正斜线可以和星号一起使用，例如*/10，如果用在minute字段，表示每十分钟执行一次。

  # 定时备份
  cron_data_back() {
    echo "${CYELLOW}开始设置定时数据备份，目前为【${TIME}】小时备份一次数据库和版本！备份到 /tlgame/backup 目录下${CEND}"
    crontab -l >${CRONTAB_BAK_FILE} 2>/dev/null
    # 删除掉存在的任务
    sed -i "/docker exec -d gsmysql *./d" ${CRONTAB_BAK_FILE}
    sed -i "/\/bin\/bash \/usr\/local\/bin\/backup all *./d" ${CRONTAB_BAK_FILE}
    sed -i "/\/bin\/bash \/usr\/local\/bin\/delbak *./d" ${CRONTAB_BAK_FILE}
    echo "0 */${TIME} * * * ${SQL_TASK}" >>${CRONTAB_BAK_FILE}
    echo "0 */${TIME} * * * ${VERSION_TASK}" >>${CRONTAB_BAK_FILE}
    echo "0 */${TIME} * * * ${CRON_DEL_TASK}" >>${CRONTAB_BAK_FILE}
    crontab ${CRONTAB_BAK_FILE} && rm -rf ${CRONTAB_BAK_FILE}
    if [ $? -eq 0 ]; then
      echo -e "${CSUCCESS}设置定时备份成功.【${TIME}】小时备份一次数据库和版本！备份到 /tlgame/backup ${CEND}"
    else
      echo -e "${GSISSUE}\r\n"
      echo -e "${CRED}备份命令不完整，请更新命令[upcmd]后再执行！${CEND}"
    fi
  }

  # 部署备份脚本
  cron_data_back

  if [ $? -eq 0 ]; then
    echo -e "${CYELLOW}定时备份已启动，如果未生效，请重启 crond 服务或者直接重启一下服务器！${CEND}"
    [ "${OS}" == "Debian" ] || [ "${OS}" == "Ubuntu" ] && service cron restart
    [ "${OS}" == "CentOS" ] || [ "${OS}" == "CentOSStream" ] && systemctl restart crond
    exit 0
  else
    echo -e "${GSISSUE}\r\n"
    echo -e "${CRED}备份命令不完整，请更新命令[upcmd]后再执行！${CEND}"
    exit 1
  fi

else
  echo -e "${GSISSUE}\r\n"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
