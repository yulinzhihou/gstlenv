#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-07-06
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 数据备份
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


# 数据备份
data_backup(){
    echo -e "${CGREEN}开始设置数据备份 !!!${CEND}";
    #备份数据库
    crontabCount=`crontab -l | grep docker exec -it `docker ps --format "{{.Names}}" | grep "gs_mysql"` | grep -v grep |wc -l`
    if [ $crontabCount -eq 0 ];then
        (echo "0 */1 * * * sh docker exec -it `docker ps --format "{{.Names}}" | grep "gs_mysql"``docker ps --format "{{.Names}}" | grep "gs_mysql"` /bin/bash -c './tlmysql_backup.sh' > /dev/null 2>&1 &"; crontab -l) | crontab
    fi

    docker cp ${GS_PROJECT}/include/tlmysql_backup.sh `docker ps --format "{{.Names}}" | grep "gs_mysql"`:/
    docker exec -it gs_tlmysql_1 /bin/bash -c "chmod -R 777 /tlmysql_backup.sh"

    #备份服务端
    crontabCount=`crontab -l | grep `docker ps --format "{{.Names}}" | grep "server"` | grep -v grep |wc -l`
    if [ $crontabCount -eq 0 ];then
        (echo "0 */1 * * * sh  > /dev/null 2>&1 &"; crontab -l) | crontab
    fi
}