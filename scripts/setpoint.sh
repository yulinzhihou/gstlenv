#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-12-25
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 设置默认充值点数

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

  if [ $# -eq 0 ]; then
    # 不传参数，表示一切归零，还原
    docker exec gsmysql /bin/bash /usr/local/bin/gsset.sh 0
  else
    # 分2个参数和3个参数，
    # 2个参数：设置成功后，所有角色有效果。
    # setpoint point 123
    # 命令      参数1  参数2
    # 3个参数：设置成单个账号的第一个角色有效果
    # 如： setpoint point 123 abcd
    #     命令      参数1 参数2 参数3
    # 增加设置充值点，门贡，帮贡，赠点，元宝的设置默认值和对玩家的离线充值
    if [ $# -eq 2 ] || [ $# -eq 3 ] || [ $# -eq 4 ]; then
      FIRST_PARAM='point'
      SECOND_PARAM=0
      THIRD_PARAM=''
      FOURTH_PARAM=''

      case $1 in
      'point' | 'p' | 'POINT' | 'P' | '充值点') FIRST_PARAM='point' ;;
      'yuanbao' | 'y' | 'YUANBAO' | 'Y' | '元宝') FIRST_PARAM='yuanbao' ;;
      'zengdian' | 'z' | 'ZENGDIAN' | 'Z' | '赠点') FIRST_PARAM='zengdian' ;;
      'menpaipoint' | 'y' | 'MENPAIPOINT' | 'M' | '门贡') FIRST_PARAM='menpaipoint' ;;
      'guildpoint' | 'g' | 'GUILDPOINT' | 'G' | '帮贡') FIRST_PARAM='guildpoint' ;;
      *)
        echo -e "${CWARNING}参数1：[point|p|POINT|P|充值点]\r\n[yuanbao|y|YUANBAO|Y|元宝]\r\n[zengdian|z|ZENGDIAN|Z|赠点]\r\n[menpaipoint|m|MENPAIPOINT|M|门贡]\r\n[guildpoint|g|GUILDPOINT|G|帮贡]\r\n中的任意一个,英文参数可以简写，不区分大小写。\r\n如：p 表示充值点，Y表示元宝${CEND}"
        ;;
      esac

      if [[ $2 =~ ^[0-9]+$ ]] && [ $2 -ge 0 ] && [ $2 -lt 2100000000 ]; then
        SECOND_PARAM=$2
      else
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED}错误:输入有误,充值点数格式不正确，请输入0-21亿之间的整数!!${CEND}"
        exit 1
      fi

      if [ $3 =~ ^[A-Za-z0-9]+$ ]; then
        THIRD_PARAM=$3
      else
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED}错误:输入有误,用户账号不需要加后缀 @game.sohu.com,只需要前面账号,并且暂不支持中文${CEND}"
        exit 1
      fi

      case $4 in
      1) FOURTH_PARAM=1 ;;
      2) FOURTH_PARAM=2 ;;
      3) FOURTH_PARAM=3 ;;
      *) FOURTH_PARAM=1 ;;
      esac
      # 组装参数发送命令
      docker exec gsmysql /bin/bash /usr/local/bin/gsset.sh ${FIRST_PARAM} ${SECOND_PARAM} ${THIRD_PARAM} ${FOURTH_PARAM}
    else
      echo "${CRED}错误:输入有误,如果需要命令帮助，请使用 gs 查询!!${CEND}"
      exit 1
    fi
  fi

else
  echo -e "${GSISSUE}\r\n"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装!!!${CEND}"
  exit 1
fi
