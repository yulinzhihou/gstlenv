#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 换版本
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

docker stop $(docker ps -a -q) && \
docker rm $(docker ps -a -q) && \
rm -rf /tlgame/tlbb/* && \
untar && \
cd ${ROOT_PATH}/${GSDIR} && \
setini && \
docker-compose up -d && \
runtlbb
if [ $? == 0 ]; then
  echo -e "${CSUCCESS} 换端成功，请耐心等待几分钟后，建议使用：【runtop】查看开服的情况！${CEND}"
else
  echo -e "${CRED} 换端失败！请检查配置！${CEND}"
fi