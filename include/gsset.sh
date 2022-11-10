#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2022-11-3
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 设置默认充值点数,元宝，赠点，帮贡，门贡

FILENAME=$(date "+%Y-%m-%d")
EXCHANGE_LOG_PATH="/home/backup/point-${FILENAME}.log"
ALTER_POINT='/usr/local/bin/alter_point.sql'
ALTER_TLBBDB_POINT='/usr/local/bin/alter_tlbbdb_point.sql'
UPDATE_POINT='/usr/local/bin/update_point.sql'
UPDATE_TLBBDB_POINT='/usr/local/bin/update_tlbbdb_point.sql'

# 执行脚本前，先备份一下2个默认文件
\cp -rf /usr/local/bin/alter_point.sql /usr/local/bin/alter_point_bak.sql
\cp -rf /usr/local/bin/alter_tlbbdb_point.sql /usr/local/bin/alter_tlbbdb_point_bak.sql
\cp -rf /usr/local/bin/update_point.sql /usr/local/bin/update_point_bak.sql
\cp -rf /usr/local/bin/update_tlbbdb_point.sql /usr/local/bin/update_tlbbdb_point_bak.sql

if [ $# -ne 0 ]; then
    FIRST_PARAM=$1
    SECOND_PARAM=$2
    THIRD_PARAM=$3
    FOURTH_PARAM=$4

    case $1 in
    'point' | 'p' | 'POINT' | 'P' | '充值点') FIRST_PARAM_NAME='充值点' ;;
    'yuanbao' | 'y' | 'YUANBAO' | 'Y' | '元宝') FIRST_PARAM_NAME='元宝' ;;
    'zengdian' | 'z' | 'ZENGDIAN' | 'Z' | '赠点') FIRST_PARAM_NAME='赠点' ;;
    'menpaipoint' | 'm' | 'MENPAIPOINT' | 'M' | '门贡') FIRST_PARAM_NAME='门贡' ;;
    'guildpoint' | 'g' | 'GUILDPOINT' | 'G' | '帮贡') FIRST_PARAM_NAME='帮贡' ;;
    'points' | 'po' | 'POINTS' | 'PO' | '潜能') FIRST_PARAM_NAME='潜能' ;;
    'vmoney' | 'v' | 'VMONEY' | 'V' | '金币') FIRST_PARAM_NAME='金币' ;;
    esac

    # 根据传入的参数进行生成sql文件
    if [ $# -eq 2 ]; then
        if [ ${FIRST_PARAM} == 'point' ]; then
            sed -i "s/default .*/default ${SECOND_PARAM}/g" ${ALTER_POINT}
            cat ${ALTER_POINT} >>$EXCHANGE_LOG_PATH
            echo -e "刷【充值点】成功，如果未成功，请将角色下线再继续尝试"
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web <${ALTER_POINT}
        else
            sed -i "s/column .* set default .*/column ${FIRST_PARAM} set default ${SECOND_PARAM}/g" ${ALTER_TLBBDB_POINT}
            cat ${ALTER_TLBBDB_POINT} >>$EXCHANGE_LOG_PATH
            echo -e "刷【${FIRST_PARAM_NAME:-'点'}】成功，如果未成功，请将角色下线再继续尝试"
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb <${ALTER_TLBBDB_POINT}
        fi

    elif [ $# -eq 3 ]; then
        if [ ${FIRST_PARAM} == 'point' ]; then
            sed -i "s/point = .* WHERE name = .*;/point = ${SECOND_PARAM} WHERE name = '${THIRD_PARAM}';/g" ${UPDATE_POINT}
            cat ${UPDATE_POINT} >>$EXCHANGE_LOG_PATH
            echo -e "刷【${FIRST_PARAM_NAME:-'点'}】成功，如果未成功，请将角色下线再继续尝试"
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web <${UPDATE_POINT}
        else
            sed -i "s/SET .* = .* WHERE aid IN ( SELECT aid FROM ( SELECT aid FROM t_char WHERE accname = .* ) AS aids );/SET ${FIRST_PARAM} = ${SECOND_PARAM} WHERE aid IN ( SELECT aid FROM ( SELECT aid FROM t_char WHERE accname = '${THIRD_PARAM}') AS aids );/g" ${UPDATE_TLBBDB_POINT}
            cat ${UPDATE_TLBBDB_POINT} >>$EXCHANGE_LOG_PATH
            echo -e "刷【${FIRST_PARAM_NAME:-'点'}】成功，如果未成功，请将角色下线再继续尝试"
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb <${UPDATE_TLBBDB_POINT}
        fi
    elif [ $# -eq 4 ]; then
        if [ ${FIRST_PARAM} == 'point' ]; then
            sed -i "s/point = .* WHERE name = .*;/point = ${SECOND_PARAM} WHERE name = '${THIRD_PARAM}';/g" ${UPDATE_POINT}
            cat ${UPDATE_POINT} >>$EXCHANGE_LOG_PATH
            echo -e "刷【${FIRST_PARAM_NAME:-'点'}】成功，如果未成功，请将角色下线再继续尝试"
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web <${UPDATE_POINT}
        else
            sed -i "s/SET .* = .* WHERE aid IN ( SELECT aid FROM ( SELECT aid FROM t_char WHERE accname = .* LIMIT 1 OFFSET .* ) AS aids );/SET ${FIRST_PARAM} = ${SECOND_PARAM} WHERE aid IN ( SELECT aid FROM ( SELECT aid FROM t_char WHERE accname = '${THIRD_PARAM}' LIMIT 1 OFFSET ${FOURTH_PARAM} ) AS aids );/g" ${UPDATE_TLBBDB_POINT}
            cat ${UPDATE_TLBBDB_POINT} >>$EXCHANGE_LOG_PATH
            echo -e "刷【${FIRST_PARAM_NAME:-'点'}】成功，如果未成功，请将角色下线再继续尝试"
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb <${UPDATE_TLBBDB_POINT}
        fi
    else
        sed -i "s/default .*/default 0/g" ${ALTER_POINT}
        cat ${ALTER_POINT} >>$EXCHANGE_LOG_PATH
        echo -e "刷【${FIRST_PARAM_NAME:-'点'}】成功，如果未成功，请将角色下线再继续尝试"
        echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web <${ALTER_POINT}
    fi
fi

# 执行完成之后，删除替换了的文件
rm -rf /usr/local/bin/alter_point.sql
rm -rf /usr/local/bin/alter_tlbbdb_point.sql
rm -rf /usr/local/bin/update_point.sql
rm -rf /usr/local/bin/update_tlbbdb_point.sql
# 再将备份文件复制回来，方便下次执行
\cp -rf /usr/local/bin/alter_point_bak.sql /usr/local/bin/alter_point.sql
\cp -rf /usr/local/bin/alter_tlbbdb_point_bak.sql /usr/local/bin/alter_tlbbdb_point.sql
\cp -rf /usr/local/bin/update_point_bak.sql /usr/local/bin/update_point.sql
\cp -rf /usr/local/bin/update_tlbbdb_point_bak.sql /usr/local/bin/update_tlbbdb_point.sql
