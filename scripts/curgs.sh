#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-10-04
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 查看当前配置项信息。需要在没人的时候查看，不然别人容易查看到你的关键信息
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

cat <<EOF
${CGREEN}
※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
◎  [1].数据库端口: $([ ${TL_MYSQL_PORT} == ${TL_MYSQL_DEFAULT_PORT} ] && echo ${TL_MYSQL_PORT} || echo ${TL_MYSQL_DEFAULT_PORT})
◎  [2].数据库密码: $([ ${TL_MYSQL_PASSWORD} == ${TL_MYSQL_DEFAULT_PASSWORD} ] && echo ${TL_MYSQL_PASSWORD} || echo ${TL_MYSQL_DEFAULT_PASSWORD})
◎  [3].验证端口: $([ ${BILLING_PORT} == ${BILLING_DEFAULT_PORT} ] && echo ${BILLING_PORT} || echo ${BILLING_DEFAULT_PORT})
◎  [4].登录网关端口: $([ ${LOGIN_PORT} == ${LOGIN_DEFAULT_PORT} ] && echo ${LOGIN_PORT} || echo ${LOGIN_DEFAULT_PORT})
◎  [5].游戏网关端口: $([ ${SERVER_PORT} == ${SERVER_DEFAULT_PORT} ] && echo ${SERVER_PORT} || echo ${SERVER_DEFAULT_PORT})
◎  [6].网站端口: $([ ${WEB_PORT} == ${WEB_DEFAULT_PORT} ] && echo ${WEB_PORT} || echo ${WEB_DEFAULT_PORT})
◎  [7].是否单服务器: $([ ${IS_DLQ} == '1' ] && echo "是" || echo "否")
◎  [8].转发机器: $([ ${BILLING_DEFAULT_SERVER_IPADDR} == ${BILLING_SERVER_IPADDR} ] && echo ${BILLING_SERVER_IPADDR} || echo ${BILLING_DEFAULT_SERVER_IPADDR})
◎  [9].网站端口: $([ ${WEB_PORT} == ${WEB_DEFAULT_PORT} ] && echo ${WEB_PORT} || echo ${WEB_DEFAULT_PORT})
◎  [0].服务端路径: $(echo ${TLBB_PATH})
※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
${CEND}
EOF