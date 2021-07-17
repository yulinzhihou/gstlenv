#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 一键开服，适合于那种可以一键开启的服务端，如果3-5分钟后，服务端没开启，则需要使用分步开服方式
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

chmod -R 777 /tlgame && \
chown -R root:root /tlgame && \
cd ${ROOT_PATH}/${GSDIR} && \
docker exec -d gsserver /home/billing/billing up -d && \
docker exec -d gsserver /bin/bash run.sh
if [ $? == 0 ]; then
  echo -e "${CSUCCESS} 已经成功启动服务端，请耐心等待几分钟后，建议使用：【runtop】查看开服的情况！！${CEND}"
else
  echo -e "${CRED} 启动服务端失败！${CEND}"
fi