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
# Date :  2022-05-08
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 删除备份文件。默认保留10份 主要是 web.sql tlbbdb.sql tlbb.tar.gz 每个备份文件各10份
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

  if [ $# -eq 0 ]; then
    FILE_NUM=10
  else
    case $1 in
    [1-9] | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23)
      FILE_NUM=$1
      ;;
    *)
      FILE_NUM=10
      ;;
    esac
  fi

  # 数据定时清楚，保留个数
  cron_data_remove() {
    for FILE in tlbb web tlbbdb; do
      [ ${FILE} == 'tlbb' ] && SUFFIX=tar.gz || SUFFIX=sql
      FILE_CUR_NUM=$(ls -ltr /tlgame/backup | grep ${FILE}-.*.${SUFFIX} | wc -l)
      if [ ${FILE_CUR_NUM} -gt ${FILE_NUM} ]; then
        let NUM_DEL=${FILE_CUR_NUM}-${FILE_NUM}
        cd /tlgame/backup &&
          ls -ltr | grep ${FILE}-.*.${SUFFIX} | awk '{print $9}' | head -n ${NUM_DEL} | xargs rm -rf
      fi
    done
  }

  # 部署备份脚本
  if [ ${FILE_NUM} -ne 0 ]; then
    cron_data_remove
    echo -e "${CSUCCESS}自动清理备份文件完成。${CEND}"
    exit 0
  else
    echo -e "${GSISSUE}\r\n"
    echo -e "${CRED}备份文件保留数量不能为0${CEND}"
    exit 1
  fi
else
  echo -e "${GSISSUE}\r\n"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
