#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2025-05-21
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

  GLOBAL_SCRIPT="/tlgame/tlbb/Public/Data/Script/ScriptGlobal.lua"
  SCRIPT_DAT="/tlgame/tlbb/Public/Data/Script.dat"

  MONSTER_INI=$(
    cat <<EOF
[monster.xx]
guid=8623891
type=0
pos_x=0
pos_z=0
dir=27
script_id=591818
respawn_time=1800000
base_ai=3
scripttimer=2000
group_id=-1
team_id=-1
patrol_id=-1
shop0=-1
shop1=-1
shop2=-1
shop3=-1
ReputationID=-1

EOF
  )
  # 部署 GM 网站
  function deployGMCode() {
    if [ ! -f "${GS_PROJECT}/config/GS_GMTools.tar.gz" ]; then
      echo -e "${CRED} 请联系GS游享网购买在线GM软件包!!! https://gsgameshare.com, 客服Q：1303588722 ${CEND}"
      exit
    fi

    # 直接解压
    cd ${GS_PROJECT}/config &&
      tar zxf GS_GMTools.tar.gz &&
      \cp -rf ${GS_PROJECT}/config/web/* /tlgame/www/gm

    if [ -f "/tlgame/www/gm/GmTools.php" ]; then
      echo "${CMAGENTA}开始部署在线GM工具！${CEND}"
      echo "${CYELLOW}即将设置必要的账号密码，请仔细记录并保存！${CEND}"
      chattr -i ${GS_WHOLE_PATH}

      # 配置GM后台登录账号
      while :; do
        echo
        read -e -p "当前【GM后台登录账号】为：${CYELLOW}[${LOGIN_USER_NAME}]${CEND}，是否需要修改【GM后台登录账号】 [y/n](默认: n): " IS_MODIFY
        IS_MODIFY=${IS_MODIFY:-'n'}
        if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
          echo "${CWARNING}输入错误! 请输入 'y' 或者 'n' ${CEND}"
          exit 1
        else
          if [ "${IS_MODIFY}" == 'y' ]; then
            while :; do
              echo
              read -e -p "请输入【GM后台登录账号】：(默认: ${LOGIN_DEFAULT_USER_NAME}): " LOGIN_NEW_USER_NAME
              LOGIN_NEW_USER_NAME=${LOGIN_NEW_USER_NAME:-${LOGIN_USER_NAME}}
              # 修改配置文件
              sed -i "s/LOGIN_USER_NAME=.*/LOGIN_USER_NAME=${LOGIN_NEW_USER_NAME}/g" ${GS_WHOLE_PATH}
              break
            done
          else
            # 修改配置文件
            sed -i "s/LOGIN_USER_NAME=.*/LOGIN_USER_NAME=${LOGIN_USER_NAME}/g" ${GS_WHOLE_PATH}
          fi
          break
        fi
      done

      # 修改登录密码
      while :; do
        echo
        read -e -p "当前【GM后台登录密码】为：${CYELLOW}[${LOGIN_PASSWORD}]${CEND}，是否需要修改【GM后台登录密码】 [y/n](默认: n): " IS_MODIFY
        IS_MODIFY=${IS_MODIFY:-'n'}
        if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
          echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【GM后台登录密码】为：[${LOGIN_PASSWORD}]${CEND}"
        else
          if [ "${IS_MODIFY}" == 'y' ]; then
            while :; do
              echo
              read -e -p "请输入【GM后台登录密码】(默认: ${LOGIN_DEFAULT_PASSWORD}): " LOGIN_NEW_PASSWORD
              LOGIN_NEW_PASSWORD=${LOGIN_NEW_PASSWORD:-${LOGIN_PASSWORD}}
              if ((${#LOGIN_NEW_PASSWORD} >= 5)); then
                sed -i "s/LOGIN_PASSWORD=.*/LOGIN_PASSWORD=${LOGIN_NEW_PASSWORD}/g" ${GS_WHOLE_PATH}
                break
              else
                echo "${CRED}密码最少要6个字符! ${CEND}"
                exit 1
              fi
            done
          else
            sed -i "s/LOGIN_PASSWORD=.*/LOGIN_PASSWORD=${LOGIN_PASSWORD}/g" ${GS_WHOLE_PATH}
            break
          fi
          break
        fi
      done

      # 修改登录密码
      while :; do
        echo
        read -e -p "当前【通讯密钥】为：${CYELLOW}[${PRIVATE_KEY}]${CEND}，是否需要修改【通讯密钥】 [y/n](默认: n): " IS_MODIFY
        IS_MODIFY=${IS_MODIFY:-'n'}
        if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
          echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【通讯密钥】为：[${PRIVATE_KEY}]${CEND}"
        else
          if [ "${IS_MODIFY}" == 'y' ]; then
            while :; do
              echo
              read -e -p "请输入【通讯密钥】(默认: ${PRIVATE_DEFAULT_KEY}): " PRIVATE_NEW_KEY
              PRIVATE_NEW_KEY=${PRIVATE_NEW_KEY:-${PRIVATE_KEY}}
              if ((${#PRIVATE_NEW_KEY} >= 5)); then
                sed -i "s/PRIVATE_KEY=.*/PRIVATE_KEY=${PRIVATE_NEW_KEY}/g" ${GS_WHOLE_PATH}
                break
              else
                echo "${CRED}密码最少要6个字符! ${CEND}"
                exit 1
              fi
            done
          else
            sed -i "s/PRIVATE_KEY=.*/PRIVATE_KEY=${PRIVATE_KEY}/g" ${GS_WHOLE_PATH}
            break
          fi
          break
        fi
      done
    else
      echo -e "${CRED} 请联系GS游享网购买在线GM软件包!!! https://gsgameshare.com, 客服Q：1303588722 ${CEND}"
      exit
    fi

    # 部署脚本到服务端
    if [ -f "${GLOBAL_SCRIPT}" ]; then
      cat "${GLOBAL_SCRIPT}" | grep "GMDATA_ISOPEN_GMTOOLS" >/dev/null 2>&1
      if [ $? -eq 1 ]; then
        # 表示没开启
        echo "\r\nGMDATA_ISOPEN_GMTOOLS=1\r\n" >>"${GLOBAL_SCRIPT}"
      fi
      cat "${GLOBAL_SCRIPT}" | grep "PRIVATE_KEY=" >/dev/null 2>&1
      if [ $? -eq 1 ]; then
        # 表示没开启
        echo "\r\nPRIVATE_KEY='${PRIVATE_KEY}'\r\n" >>"${GLOBAL_SCRIPT}"
      fi
    fi

    # 增加脚本
    if [ -f "${SCRIPT_DAT}" ]; then
      cat "${SCRIPT_DAT}" | grep "591818" >/dev/null 2>&1
      if [ $? -eq 1 ]; then
        \cp -rf ${GS_PROJECT}/config/tlbb/Public/Data/Script/GmSecondsTimer.lua /tlgame/tlbb/Public/Data/Script
        # 表示没有这个脚本编号，
        echo "\r\n591818=\\GmSecondsTimer.lua\r\n" >>${SCRIPT_DAT}
      fi
    fi

    # DB_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' gsmysql)
    # REDIS_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' gsredis)

    # 定义配置变量（按需修改这些值）
    LOGIN_USER_NAME="${LOGIN_USER_NAME}"
    LOGIN_PASSWORD="${LOGIN_PASSWORD}"
    PRIVATE_KEY="${PRIVATE_KEY}"
    DB_HOST="gsmysql"
    DB_NAME="gs_gmtools"
    DB_USER="root"
    DB_PASS="${TL_MYSQL_PASSWORD}"
    DB_PORT="3306"
    DB_CHARSET="utf8"
    WEB_HOST="gsmysql"
    WEB_NAME="web"
    WEB_PORT="3306"
    WEB_USER="root"
    WEB_PASS="${TL_MYSQL_PASSWORD}"
    WEB_charset="utf8"
    REDIS_HOST="gsredis"
    REDIS_PORT="6379"
    REDIS_PASSWORD="${REDIS_PASSWORD}"
    REDIS_DATABASE="0"
    REDIS_TIMEOUT=30
    REDIS_PERSISTENT=false

    # 定义替换规则（PHP变量名 -> Shell变量名）
    declare -A replacements=(
      ["db_host"]="DB_HOST"
      ["db_name"]="DB_NAME"
      ["db_user"]="DB_USER"
      ["db_pass"]="DB_PASS"
      ["db_port"]="DB_PORT"
      ["db_charset"]="DB_CHARSET"
      ["web_host"]="WEB_HOST"
      ["web_name"]="WEB_NAME"
      ["web_port"]="WEB_PORT"
      ["web_user"]="WEB_USER"
      ["web_pass"]="WEB_PASS"
      ["web_charset"]="WEB_charset"
      ["redis_host"]="REDIS_HOST"
      ["redis_port"]="REDIS_PORT"
      ["redis_password"]="REDIS_PASSWORD"
      ["redis_database"]="REDIS_DATABASE"
      ["redis_timeout"]="REDIS_TIMEOUT"
      ["redis_persistent"]="REDIS_PERSISTENT"
      ["privateKey"]="PRIVATE_KEY"
      ["loginUserName"]="LOGIN_USER_NAME"
      ["loginPassword"]="LOGIN_PASSWORD"
    )

    # 构建sed替换命令（关键修复点）
    sed_commands=()
    for php_key in "${!replacements[@]}"; do
      shell_var="${replacements[$php_key]}"
      value="${!shell_var}"

      # 修复转义逻辑：仅处理必要字符，避免末尾添加反斜杠
      escaped_value=$(printf '%s' "$value" | sed -e 's/[\/&]/\\&/g' -e 's/\\/\\\\/g' | tr -d '\n')

      # 构建精确匹配模式（匹配PHP类属性赋值语法）
      sed_commands+=("-e" "s|public static \\\$${php_key} = '[^']*'|public static \\\$${php_key} = '${escaped_value}'|g")
    done

    # 执行替换并保留文件格式
    sed "${sed_commands[@]}" <<'EOF' >/tlgame/www/gm/DBConfig.php
<?php
 
class DBConfig
{
    // GM工具数据库配置
    public static $db_host = 'DB_HOST';
    public static $db_name = 'DB_NAME';
    public static $db_user = 'DB_USER';
    public static $db_pass = 'DB_PASS';
    public static $db_port = 'DB_PORT';
    public static $db_prefix = '';
    public static $db_charset = 'DB_CHARSET';
 
    // 账号数据库配置
    public static $web_host = 'WEB_HOST';
    public static $web_name = '~';
    public static $web_user = 'WEB_USER';
    public static $web_pass = 'WEB_PASS';
    public static $web_port = 'WEB_PORT';
    public static $web_prefix = '';
    public static $web_charset = 'WEB_CHARSET';
 
    // Redis配置
    public static $redis_host = 'REDIS_HOST';
    public static $redis_port = 'REDIS_PORT';
    public static $redis_password = 'REDIS_PASSWORD';
    public static $redis_database = 'REDIS_DATABASE';
    public static $redis_timeout = 'REDIS_TIMEOUT';
    public static $redis_persistent = 'REDIS_PERSISTENT';
 
    // 业务配置
    public static $privateKey = 'PRIVATE_KEY';
    public static $loginUserName = 'LOGIN_USER_NAME';
    public static $loginPassword = 'LOGIN_PASSWORD';
}
EOF

    echo "配置文件生成成功：DBConfig.php"

  }

  # 获取用户目录
  # function getUserInput() {
  #   # 配置是游戏注册还是登录器注册
  #   while :; do
  #     read -e -p "当前【域名】为${CYELLOW}["0.0.0.0"]${CEND}，是否需要修改【0.0.0.0=使用服务器外网IP+端口访问】 [y/n](默认: n): " IS_MODIFY
  #     IS_MODIFY=${IS_MODIFY:-'n'}
  #     if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
  #       echo "${CWARNING}输入错误! 请输入 y 或者 n ${CEND}"
  #     else
  #       if [ "${IS_MODIFY}" == 'y' ]; then
  #         while :; do
  #           echo
  #           read -e -p "请输入【IP地址或者解析过来的域名】(默认: [0.0.0.0]): " DOMAIN_IP
  #           DOMAIN_IP=${DOMAIN_IP:-"0.0.0.0"}
  #           if [ ${DOMAIN_IP} ]; then
  #             sed -i "s/server_name  .*/server_name  ${DOMAIN_IP}/g" /tlgame/conf.d/gm.conf
  #             break
  #           else
  #             echo "${CWARNING}输入错误!${CEND}"
  #           fi
  #         done
  #       fi
  #       break
  #     fi
  #   done
  #   docker restart gsnginx gsphp gsredis
  # }

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

    error_log  /var/log/nginx/nginx.gm.error.log  warn;
    
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location ~ \.php$ {
        fastcgi_pass   gsphp:9000;
        include        fastcgi.conf;
        set \$real_script_name \$fastcgi_script_name;
        if (\$fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
            set \$real_script_name \$1;
        }
        fastcgi_param SCRIPT_FILENAME \$document_root\$real_script_name;
        fastcgi_param SCRIPT_NAME \$real_script_name;
    }
}
EOF
    fi

  }

  owConf
  deployGMCode
  chmod -R 777 /tlgame/www
  docker restart gsnginx gsphp gsredis

  echo -ne "\r\n"
  echo -ne "\r\n${CYELLOW} http://IP地址:${WEB_GM_PORT} 访问！ ${CEND}"
  echo -ne "\r\n${CYELLOW} 访问网站进行后面的配置工作，配置完后需要重启服务端才能生效！！！ ${CEND}"
  echo -ne "\r\n"
  echo -ne "\r\n"
else
  echo -e "${GSISSUE}\r\n"
  echo -e "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
