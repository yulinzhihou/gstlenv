#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-07-18
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 手动执行备份数据库功能和打包服务端
# 颜色代码
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

  FILENAME="$(date +%Y_%m_%d_%H_%M_%S)"
  FILEPATH="/tlgame/backup/"
  LOG_FILE="backup.log"

  # 检测
  if [ ! -d ${FILEPATH} ]; then
    mkdir -p ${FILEPATH}
  fi

  backup_tlbb() {
    echo -e "${CYELLOW}正在备份版本目录，请稍等……\r${CEND}"
    #备份服务端
    cd /tlgame && tar zcf tlbb-${FILENAME}.tar.gz tlbb &&
      mv tlbb-*.tar.gz ${FILEPATH}
    #判断是否备份成功
    if [ $? -eq 0 ]; then
      echo -ne "${CSUCCESS}$(date '+%Y-%m-%d-%H-%M-%S')\ttlbb-${FILENAME}.tar.gz\t备份成功!!${CEND}" | tee -a ${FILEPATH}${LOG_FILE}
    else
      echo -ne "${CRED}$(date '+%Y-%m-%d-%H-%M-%S')\ttlbb-${FILENAME}.tar.gz\t备份失败${CEND}" | tee -a ${FILEPATH}${LOG_FILE}
    fi

    #清理7天前的，也就是保留7天的数据
    find /tlgame/backup/ -name "*.tar.gz" -type f -mtime +7 -exec rm -rf {} \; >/dev/null 2>&1
  }

  backup_mysql() {
    echo -e "${CYELLOW}正在备份数据库，请稍等……\r${CEND}"
    docker exec -it gsmysql /bin/sh /usr/local/bin/gsmysqlBackup.sh &&
      mv /tlgame/gsmysql/*.sql ${FILEPATH}
    #判断是否备份成功
    if [ $? -eq 0 ]; then
      echo -ne "${CSUCCESS}$(date '+%Y-%m-%d-%H-%M-%S')\t web和tlbbdb库 \t备份成功!!${CEND}" | tee -a ${FILEPATH}${LOG_FILE}
    else
      echo -ne "${CRED}$(date '+%Y-%m-%d-%H-%M-%S')\t web和tlbbdb库 \t备份失败${CEND}" | tee -a ${FILEPATH}${LOG_FILE}
    fi
    #清理7天前的，也就是保留7天的数据
    find /tlgame/backup/ -name "*.sql" -type f -mtime +7 -exec rm -rf {} \; >/dev/null 2>&1
  }

  # 根据输入判断备份类型
  if [ $# -eq 0 ]; then
    while :; do
      echo
      echo -e "${CYELLOW}请选择需要备份的类型，0=备份版本+数据库，1=只备份版本，2=只备份数据库。默认为[0]备份所有.备份目录[/tlgame/backup]${CEND}"
      read -e -p "${CYELLOW}请输入[0]=备份版本+数据库,[1]=只备份版本,[2]=只备份数据库[0、1、2](默认: 0):${CEND} " IS_MODIFY
      IS_MODIFY=${IS_MODIFY:-'0'}
      case ${IS_MODIFY} in
      0)
        backup_tlbb &&
          backup_mysql
        break
        ;;
      1)
        backup_tlbb
        break
        ;;
      2)
        backup_mysql
        break
        ;;
      *)
        echo -e "${CWARNING}输入错误! 请输入 0-2 ${CEND}"
        break
        ;;
      esac
    done
  else
    if [ $1 == 'all' ] || [ $1 -eq 0 ]; then
      backup_tlbb && backup_mysql
    elif [ $1 -eq 1 ]; then
      backup_tlbb
    elif [ $1 -eq 2 ]; then
      backup_mysql
    else
      echo -e "${CRED}参数错误！backup 后面跟 all,0,1,2这4个参数中的任意一个${CEND}"
      exit 1
    fi

  fi

  if [ $? -eq 0 ]; then
    echo -e "${CSUCCESS}已经成功备份完成，备份文件在 [/tlgame/backup] 目录下${CEND}"
    exit 0
  else
    echo -e "${CRED}备份失败！${CEND}"
    exit 1
  fi
else
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
