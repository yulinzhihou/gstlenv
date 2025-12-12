#!/usr/bin/env bash
# 设置字符编码，确保中文正常显示
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2025-06-19
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 重新构建环境版本，751 757 980 651
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

  # 备份数据
  setconfig_backup() {
    echo -ne "正在备份版本数据请稍候……\r\n"
    cd /tlgame && tar zcf tlbb-setconfig-backup.tar.gz tlbb &&
      docker exec -d gsmysql /bin/bash /usr/local/bin/gsmysqlBackup.sh
  }

  # 还原数据
  setconfig_restore() {
    echo -ne "正在还原修改参数之前的数据库与版本请稍候……\r\n"
    if [ -f "/tlgame/tlbb-setconfig-backup.tar.gz" ]; then
      cd /tlgame && tar zxf tlbb-setconfig-backup.tar.gz && mv /tlgame/tlbb-setconfig-backup.tar.gz /tlgame/backup/
    fi

    docker exec -d gsmysql /bin/bash /usr/local/bin/gsmysqlRestore.sh

  }

  # mysql 初始化
  init_mysql() {
    docker exec -d gsmysql /bin/bash /usr/local/bin/init_db.sh
  }

  main_transfer() {
    cat <<EOF
${CYELLOW}
※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
◎           
◎  GS游戏享网服务器环境 gstlenv
◎           
◎  编号1：Centos 6 + Mysql5.1 (默认，输入1或不输，按回车)  ---> （老品种，没有改引擎和数据库）
◎  编号2：Centos 7 + Mysql5.1 (输入2，按回车) ---> （老品种，没有改引擎和数据库）
◎  编号3：Centos 7 + Mysql5.7 (输入3，按回车) --->  (大河马引擎，大背包，逍遥子引擎，有改引擎和数据库的)
◎  编号4：Centos 9 + Mysql8.0 (输入4，按回车) --->  (源端64位引擎专用)
◎
※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
${CEND}
EOF

    read -e -p "请输入你需要安装的环境编号【默认不输入则为1，直接回车即可】(默认: ${DEFAULT_ENV_INDEX}): " DEFAULT_ENV_INDEX

    # 解压防线安装包
    if [ -d ${GS_PROJECT} ]; then
      # 部署脚本
      case "${DEFAULT_ENV_INDEX}" in
      '01' | '1')
        \cp -rf ${GS_PROJECT}/docker-compose.yml /root/.gs/docker-compose.yml &&
          . ${GS_WHOLE_PATH} &&
          chmod -R 777 ${GS_PROJECT}
        ;;
      '02' | '2')
        \cp -rf ${GS_PROJECT}/docker-compose751.yml /root/.gs/docker-compose.yml &&
          . ${GS_WHOLE_PATH} &&
          chmod -R 777 ${GS_PROJECT}
        ;;
      '03' | '3')
        \cp -rf ${GS_PROJECT}/docker-compose757.yml /root/.gs/docker-compose.yml &&
          . ${GS_WHOLE_PATH} &&
          chmod -R 777 ${GS_PROJECT}
        ;;
      '04' | '4')
        \cp -rf ${GS_PROJECT}/docker-compose980.yml /root/.gs/docker-compose.yml &&
          . ${GS_WHOLE_PATH} &&
          chmod -R 777 ${GS_PROJECT}
        ;;
      *)
        \cp -rf ${GS_PROJECT}/docker-compose.yml /root/.gs/docker-compose.yml &&
          . ${GS_WHOLE_PATH} &&
          chmod -R 777 ${GS_PROJECT}
        ;;
      esac
    else
      echo -e "${CRED}环境不存在，请先安装环境！${CEND}"
      exit 1
    fi
  }

  while :; do
    echo
    for ((time = 5; time >= 0; time--)); do
      echo -ne "\r在准备构建环境版本！！，剩余 ${CYELLOW}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！\r"
      sleep 1
    done
    echo -ne "\r\n"
    echo -ne "${CYELLOW}正在重构，数据不会清除……${CEND}\r\n"
    #重构前，先备份数据库以及版本数据。
    setconfig_backup &&
      cd ${ROOT_PATH}/${GSDIR} &&
      docker-compose down &&
      rm -rf /tlgame/gsmysql/mysql &&
      rm -rf /tlgame/tlbb/* &&
      cd ${ROOT_PATH}/${GSDIR} &&
      docker-compose up -d &&
      setconfig_restore &&
      init_mysql &&
      main_transfer
    if [ $? -eq 0 ]; then
      echo -e "${CSUCCESS}环境已经重构成功，请上传服务端到指定位置，然后再开服操作！！可以重新上传服务端进行【untar】【setini】【runtlbb】进行开服操作！！${CEND}"
      exit 0
    else
      echo -e "${GSISSUE}\r\n"
      echo -e "${CRED}环境已经重构失败！可能需要重装系统或者环境了！${CEND}"
      exit 1
    fi
  done
else
  echo -e "${GSISSUE}\r\n"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
