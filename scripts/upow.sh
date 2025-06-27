#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-09-16
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 用来配置网站访问。默认网站内容请自觉上传到/tlgame/www/ow 目录下
# 引入全局参数
# 增加容器是否存在的判断
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
  if [ -f /root/.gs/.env ]; then
    . /root/.gs/.env
  fi
  # 颜色代码
  if [ -f ./color.sh ]; then
    . ${GS_PROJECT}/scripts/color.sh
  else
    . /usr/local/bin/color
  fi

  # 获取用户目录
  function getUserInput() {
    # 配置是游戏注册还是登录器注册
    while :; do
      echo
      echo -e "${CYELLOW}国内机器需要已经备案域名，才能使用80端口。默认端口为51888，默认是服务器外网IP+端口访问${CEND}"
      read -e -p "当前【域名】为${CYELLOW}["0.0.0.0"]${CEND}，是否需要修改【0.0.0.0=使用服务器外网IP+端口访问】 [y/n](默认: n): " IS_MODIFY
      IS_MODIFY=${IS_MODIFY:-'n'}
      if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
        echo "${CWARNING}输入错误! 请输入 y 或者 n ${CEND}"
      else
        if [ "${IS_MODIFY}" == 'y' ]; then
          while :; do
            echo
            read -e -p "请输入【IP地址或者解析过来的域名】(默认: [0.0.0.0]): " DOMAIN_IP
            DOMAIN_IP=${DOMAIN_IP:-"0.0.0.0"}
            if [ ${DOMAIN_IP} ]; then
              sed -i "s/server_name .*/server_name  ${DOMAIN_IP}/g" /tlgame/conf.d/ow.conf
              break
            else
              echo "${CWARNING}输入错误!${CEND}"
            fi
          done
        fi
        break
      fi
    done
    docker restart gsnginx
  }

  # 创建目录，生成配置文件
  function owConf() {
    # 创建目录
    if [ ! -d "/tlgame/www/ow" ]; then
      mkdir -p /tlgame/www/ow
    fi

    if [ -d "/tlgame/conf.d" ]; then
      cat >/tlgame/conf.d/ow.conf <<EOF
server {
    listen       80  default;
    server_name  0.0.0.0;
    root   /www/ow;
    index  index.html index.htm default.html default.htm;

    #access_log  /var/log/nginx/nginx.ow.access.log  main;
    error_log  /var/log/nginx/nginx.ow.error.log  warn;
    
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF
    fi
  }

  owConf
  getUserInput
  echo -e "${CSUCCESS}创建成功，请将网站上传到/tlgame/www/ow目录里面，并且首页必须是index.html index.htm default.html default.htm中的一种${CEND}"
  exit 0
else
  echo -e "${GSISSUE}\r\n"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
