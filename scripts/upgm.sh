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

  GLOBAL_SCRIPT="/tlgame/tlbb/Public/Data/Script/ScriptGlobal.lua"
  SCRIPT_DAT="/tlgame/tlbb/Public/Data/Script.dat"
  LUOYANG_SCENE="/tlgame/tlbb/Public/Scene/luoyang_monster.ini"
  DALI_SCENE="/tlgame/tlbb/Public/Scene/dali_monster.ini"
  SU_ZHOU_SCENE="/tlgame/tlbb/Public/Scene/suzhou_monster.ini"
  LOULAN_SCENE="/tlgame/tlbb/Public/Scene/loulangucheng_monster.ini"

  # 部署 GM 网站
  function deployGMCode() {
    if [ ! -f "${GS_PROJECT}/config/GS_GMTools.tar.gz" ]; then
      echo -e "${CRED} 请联系GS游享网购买在线GM软件包!!! https://gsgameshare.com, 客服Q：1303588722 ${CEND}"
      exit
    fi

    # 直接解压
    cd ${GS_PROJECT}/config &&
      tar zxf GS_GMTools.tar.gz &&
      \cp -rf web\* /tlgame/www/gm

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
              read -e -p "请输入【GM后台登录账号】：(默认: ${LOGIN_DEFAULT_USER_NAME}): " LOGIN_USER_NAME
              LOGIN_NEW_USER_NAME=${LOGIN_NEW_USER_NAME:-${LOGIN_DEFAULT_USER_NAME}}
              if [ ${LOGIN_NEW_USER_NAME} == ${LOGIN_DEFAULT_USER_NAME} ] >/dev/null 2>&1; then
                # 修改配置文件
                sed -i "s/LOGIN_USER_NAME=.*/LOGIN_USER_NAME=${LOGIN_NEW_USER_NAME}/g" ${GS_WHOLE_PATH}
                # 更改程序
                sed -i "s/LOGIN_USER_NAME/${LOGIN_USER_NAME}/g" ${SHARED_DIR}/www/gm/GmTools.php
                break
              else
                echo "${CWARNING}输入错误! 请输入6-12位的账号名！${CEND}"
                exit 1
              fi
            done
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
                # 更改程序
                sed -i "s/LOGIN_PASSWORD/${LOGIN_PASSWORD}/g" ${SHARED_DIR}/www/gm/GmTools.php
                break
              else
                echo "${CRED}密码最少要6个字符! ${CEND}"
                exit 1
              fi
            done
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
                # 更改程序
                sed -i "s/PRIVATE_KEY/${PRIVATE_KEY}/g" ${SHARED_DIR}/www/gm/GmTools.php
                break
              else
                echo "${CRED}密码最少要6个字符! ${CEND}"
                exit 1
              fi
            done
          fi
          break
        fi
      done
    else
      echo -e "${CRED} 请联系GS游享网购买在线GM软件包!!! https://gsgameshare.com, 客服Q：1303588722 ${CEND}"
      exit
    fi

    # 创建目录
    if [ ! -d "/tlgame/tlbb/Server/SecondsTimer" ]; then
      mkdir -p /tlgame/tlbb/Server/SecondsTimer
    fi

    # 部署脚本到服务端
    if [ -f "${GLOBAL_SCRIPT}" ]; then
      cat "${GLOBAL_SCRIPT}" | grep "GMDATA_ISOPEN_GMTOOLS" >/dev/null 2>&1
      if [ $? -eq 1 ]; then
        # 表示没开启
        echo "GMDATA_ISOPEN_GMTOOLS=1" >>"${GLOBAL_SCRIPT}"
      fi
    fi

    # 增加脚本
    if [ -f "${SCRIPT_DAT}" ]; then
      cat "${SCRIPT_DAT}" | grep "591818" >/dev/null 2>&1
      if [ $? -eq 1 ]; then
        # 表示没有这个脚本编号，
        echo "591818=\\GmSecondsTimer.lua" >>${SCRIPT_DAT}
      fi
    fi

    # 部署地图隐藏NPC
    if [ -f "${LUOYANG_SCENE}" ]; then
      current_count=$(awk -F'=' '/\[info\]/{f=1} f&&/monstercount/{print $2; exit}' "$LUOYANG_SCENE")
      new_count=$((current_count + 1))
      SCENE_FILE=${LUOYANG_SCENE}
    else
      echo -e "${CRED} 洛阳场景未加入GM功能，请手动检查！ ${CEND}"
    fi

    if [ -f "${DALI_SCENE}" ]; then
      current_count=$(awk -F'=' '/\[info\]/{f=1} f&&/monstercount/{print $2; exit}' "$DALI_SCENE")
      new_count=$((current_count + 1))
      SCENE_FILE=${DALI_SCENE}
    else
      echo -e "${CRED} 大理场景未加入GM功能，请手动检查！ ${CEND}"
    fi

    if [ -f "${SU_ZHOU_SCENE}" ]; then
      current_count=$(awk -F'=' '/\[info\]/{f=1} f&&/monstercount/{print $2; exit}' "$SU_ZHOU_SCENE")
      new_count=$((current_count + 1))
      SCENE_FILE=${SU_ZHOU_SCENE}
    else
      echo -e "${CRED} 苏州场景未加入GM功能，请手动检查！ ${CEND}"
    fi

    if [ -f "${LOULAN_SCENE}" ]; then
      current_count=$(awk -F'=' '/\[info\]/{f=1} f&&/monstercount/{print $2; exit}' "$LOULAN_SCENE")
      new_count=$((current_count + 1))
      SCENE_FILE=${LOULAN_SCENE}
    else
      echo -e "${CRED} 楼兰场景未加入GM功能，请手动检查！ ${CEND}"
    fi

    awk -v new="$new_count" '
    /\[info\]/ {in_section=1; next}
    in_section && /monstercount=/ {
        $0 = "monstercount=" new  # 直接替换整行
        in_section=0             # 只处理第一个匹配项
    }
    {print}
' "$SCENE_FILE" >tmp && mv tmp "$SCENE_FILE" && unix2dos "$SCENE_FILE" >/dev/null 2>&1

    echo "monstercount 已更新为：$new_count"

    cat >${SCENE_FILE} <<EOF
[monster${new_count}]
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

    access_log  /var/log/nginx/nginx.mg.access.log  main;
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
  getUserInput
  deployGMCode
else
  echo -e "${GSISSUE}\r\n"
  echo -e "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
