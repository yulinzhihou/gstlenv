#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 改变服务器下载慢，切换成国内更新源。
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

function main() {
 echo -e "
  ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
  0. ◎ 【阿里云】镜像源
  1. ◎ 【华为云】镜像源
  2. ◎ 【腾讯云】镜像源
  3. ◎ 【清华】镜像源
  4. ◎ 【科技大】镜像源
  5. ◎ 退出脚本
  ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
  read -p "请选择功能 输入序号并回车：" num
  case "$num" in
  [0]) (aliyun) ;;
  [1]) (huaweiyun) ;;
  [2]) (tecentyun) ;;
  [3]) (tsinghua) ;;
  [4]) (ustc) ;;
  [5]) ;;
  *) (main) ;;
  esac
}

function aliyun(){

}

function huaweiyun(){
  
}

function tecentyun(){
  
}

function tsinghua(){
  
}

function ustc(){
  
}

if [ $1 == "tlmysql" ] || [ $1 == "web" ]; then
    cd /root/.tlgame && docker-compose exec $1 bash
elif [ -z $1 ]; then
    cd /root/.tlgame && docker-compose exec server bash
else
  echo  -e "${CBLUE}错误：输入有误！！请使用 link tlmysql|nginx|server${CEND}";
fi