#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 删除所有数据
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

while :; do
  echo
  for ((time = 5; time >= 0; time--)); do
    echo -ne "\r正准备删除GS环境，数据全清！！，剩余 ${CBLUE}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！\r"
    sleep 1
  done
  echo -ne "\r\n"
  echo -ne "${CYELLOW}正在进行清除操作…………\r\n${CEND}"

  # bug:移除本环境的docker镜像与容器。还有写入系统的命令
  for VAR in $(ls -l ${GS_PROJECT}/scripts/ | awk '{print $9}'); do
    if [ -n ${VAR} ]; then
      rm -rf /usr/local/bin/${VAR%%.*}
    fi
  done

  docker stop gsmysql gsnginx gsserver gsphp gsredis
  docker rm -f gsmysql gsnginx gsserver gsphp gsredis
  mv /tlgame /tlgame-$(date +%Y%m%d%H%I%S)
  \cp -rf ${ROOT_PATH}/${GSDIR}/.env /root/gsenv-$(date +%Y%m%d%H%I%S)
  chattr -i ${GS_WHOLE_PATH}
  rm -rf /usr/local/bin/.env
  rm -rf ${ROOT_PATH}/${GSDIR}
  rm -rf ${GS_PROJECT}
  docker rmi -f ${HUB_ALIYUN}yulinzhihou/gs_mysql51 ${HUB_ALIYUN}yulinzhihou/gs_server ${HUB_ALIYUN}yulinzhihou/gs_nginx ${HUB_ALIYUN}yulinzhihou/gs_php ${HUB_ALIYUN}yulinzhihou/gs_redis

  if [ $? -eq 0 ]; then
    echo -e "${CSUCCESS} 数据清除成功，请重新安装环境 ！！！ 可以重新输入 【 curl -sSL https://gitee.com/yulinzhihou/gstlenv/raw/master/gsenv.sh | bash 】进行重新安装 ！！！${CEND}"
    exit 0
  else
    echo -e "${GSISSUE}\r\n"
    echo -e "${CRED} 数据清除失败！可能需要重装系统或者环境了！${CEND}"
    exit 1
  fi
  break
done
# 自毁
rm -rf $0
