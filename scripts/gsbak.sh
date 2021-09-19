#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-07-06
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 定时数据备份
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

FILENAME=`date "+%Y-%m-%d-%H-%M-%S"`

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

# 数据备份
data_backup(){
    echo -e "${CGREEN}开始设置数据备份 !!!${CEND}";
    #备份数据库
    crontabCount=`crontab -l | grep docker exec -it `docker ps --format "{{.Names}}" | grep "gsmysql"` | grep -v grep |wc -l`
    # crontabCount=`crontab -l | grep docker exec -it gsmysql | grep -v grep | wc -l`
    if [ $crontabCount -eq 0 ];then
        # (echo "0 */1 * * * sh docker exec -it `docker ps --format "{{.Names}}" | grep "gsmysql"``docker ps --format "{{.Names}}" | grep "gsmysql"` /bin/bash -c './gsmysqlBackup.sh' > /dev/null 2>&1 &"; crontab -l) | crontab
        (echo "0 */1 * * * sh docker exec -it gsmysql /bin/bash /var/lib/mysql/gsmysqlBackup.sh > /dev/null 2>&1 &"; crontab -l) | crontab
    fi

    #备份服务端
    crontabCount=`crontab -l | grep `docker ps --format "{{.Names}}" | grep "gsserver"` | grep -v grep |wc -l`
    if [ $crontabCount -eq 0 ];then
        (echo "0 0 */1 * * /bin/bash /usr/local/bin/backup > /dev/null 2>&1 &"; crontab -l) | crontab
    fi
}

data_backup