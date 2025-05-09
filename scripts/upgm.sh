#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-09-16
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 用来配置在线GM网站访问。默认网站内容请自觉上传到/tlgame/www/gm目录下
# 增加容器是否存在的判断
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

  # 部署 GM 网站
  function deployGMCode() {
    # 直接解压
    cd ${GS_PROJECT}/config &&
      tar zxf TLBB_GMTools.tar.gz -C /tlgame/www/gm
    echo -e "剩下的操作需要手动去修改配置。。。。。。后续更新自动配置"
    # 替换密码，秘钥，数据库账号密码。
    # ScriptGlobal.lua 配置
    # echo "GMDATA_ISOPEN_GMTOOLS = 1" >> /tlgame/tlbb/Server/Public/Data/Script/ScriptGlobal.lua
    # 洛阳，苏州，大理，楼兰增加心跳NPC

    # PHP 验证KEY

    # 替换数据加密码端口。

  }

  # 获取用户目录
  function getUserInput() {
    # 配置是游戏注册还是登录器注册
    while :; do
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
              sed -i "s/server_name  .*/server_name  ${DOMAIN_IP}/g" /tlgame/conf.d/gm.conf
              break
            else
              echo "${CWARNING}输入错误!${CEND}"
            fi
          done
        fi
        break
      fi
    done
    docker restart gsnginx gsphp gsredis
  }

  # 创建目录，生成配置文件
  function owConf() {
    # 创建目录
    if [ ! -d /tlgame/www/gm ]; then
      mkdir -p /tlgame/www/gm
    fi

    if [ -d /tlgame/conf.d ]; then
      cat >/tlgame/conf.d/gm.conf <<EOF
server {
    listen       81  default;
    server_name  0.0.0.0;
    root   /www/gm;
    index  index.php index.html index.htm;
    #charset koi8-r;
    
    access_log /dev/null;
    #access_log  /var/log/nginx/nginx.localhost.access.log  main;
    error_log  /var/log/nginx/nginx.localhost.error.log  warn;
    
    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        fastcgi_pass   gsphp:9000;
        include        fastcgi.conf;
        set \$real_script_name \$fastcgi_script_name;
        if (\$fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
            set \$real_script_name \$1;
            set \$path_info \$2;
        }
        fastcgi_param SCRIPT_FILENAME \$document_root\$real_script_name;
        fastcgi_param SCRIPT_NAME \$real_script_name;
        fastcgi_param PATH_INFO \$path_info;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}

# server {
#     listen 443  default ssl http2;
#     server_name  0.0.0.0;
#     root   /www/ow;
#     index  index.php index.html index.htm;
#     #charset koi8-r;

#     access_log /dev/null;
#     #access_log  /var/log/nginx/nginx.localhost.access.log  main;
#     error_log  /var/log/nginx/nginx.localhost.error.log  warn;

#     #error_page  404              /404.html;

#     ssl_certificate /ssl/localhost/localhost.crt;
#     ssl_certificate_key /ssl/localhost/localhost.key;

#     # redirect server error pages to the static page /50x.html
#     #
#     error_page   500 502 503 504  /50x.html;
#     location = /50x.html {
#         root   /usr/share/nginx/html;
#     }

#     # proxy the PHP scripts to Apache listening on 127.0.0.1:80
#     #
#     #location ~ \.php$ {
#     #    proxy_pass   http://127.0.0.1;
#     #}

#     # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
#     #
#     location ~ \.php$ {
#         fastcgi_pass   gsphp:9000;
#         include        fastcgi-php.conf;
#         include        fastcgi_params;
#     }

#     # deny access to .htaccess files, if Apache's document root
#     # concurs with nginx's one
#     #
#     #location ~ /\.ht {
#     #    deny  all;
#     #}
# }
EOF
    fi

  }

  owConf
  getUserInput
  deployGMCode
else
  echo -e "${GSISSUE}\r\n"
  echo -e "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
