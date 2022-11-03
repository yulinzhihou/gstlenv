#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2022-11-3
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 设置默认充值点数,元宝，赠点，帮贡，门贡

FILENAME=$(date "+%Y-%m-%d-%H-%M-%S")
EXCHANGE_LOG_PATH="/home/backup/point-${FILENAME}.log"
ALTER_POINT='/usr/local/bin/alter_point.sql'
ALTER_TLBBDB_POINT='/usr/local/bin/alter_tlbbdb_point.sql'
UPDATE_POINT='/usr/local/bin/update_point.sql'
UPDATE_TLBBDB_POINT='/usr/local/bin/update_tlbbdb_point.sql'

if [ $# -ne 0 ]; then
    FIRST_PARAM=''
    SECOND_PARAM=''
    THIRD_PARAM=''
    FOURTH_PARAM=0

    case $1 in
    'point') FIRST_PARAM='point' ;;
    'yuanbao') FIRST_PARAM='yuanbao' ;;
    'zengdian') FIRST_PARAM='zengdian' ;;
    'menpaipoint') FIRST_PARAM='menpaipoint' ;;
    'guildpoint') FIRST_PARAM='guildpoint' ;;
    *) FIRST_PARAM=point ;;
    esac

    if [ $# -eq 2 ]; then
        if [[ $2 =~ ^[0-9]+$ ]] && [ $2 -ge 0 ] && [ $2 -lt 2100000000 ]; then
            SECOND_PARAM=$2
        else
            SECOND_PARAM=0
        fi
    fi

    if [ $# -eq 3 ]; then
        if [[ $3 =~ ^[A-Za-z0-9]+$ ]]; then
            THIRD_PARAM=$3
            if [[ $4 =~ ^[0-9]+$ ]] && [ $4 -ge 0 ] && [ $4 -lt 2100000000 ]; then
                FOURTH_PARAM=$($4 - 1)
            else
                FOURTH_PARAM=0
            fi
        else
            THIRD_PARAM=''
            FOURTH_PARAM=0
        fi
    fi
    # 根据传入的参数进行生成sql文件
    if [ $# -eq 2 ]; then
        if [ ${FIRST_PARAM} == 'point' ]; then
            sed -i "s/default .*/default ${SECOND_PARAM}/g" ${ALTER_POINT}
            cat ${ALTER_POINT} | tee -a $EXCHANGE_LOG_PATH
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web <${ALTER_POINT}
        else
            sed -i "s/column .* set default .*/column ${FIRST_PARAM} set default ${SECOND_PARAM}/g" ${ALTER_TLBBDB_POINT}
            cat ${ALTER_TLBBDB_POINT} | tee -a $EXCHANGE_LOG_PATH
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb <${ALTER_TLBBDB_POINT}
        fi

    elif [ $# -eq 3 ] && [[ ${THIRD_PARAM} -ne '' ]]; then
        if [ ${FIRST_PARAM} == 'point' ]; then
            sed -i "s/point = .* WHERE name = .*;/point = ${SECOND_PARAM} WHERE name = ${THIRD_PARAM};/g" ${UPDATE_POINT}
            cat ${UPDATE_POINT} | tee -a $EXCHANGE_LOG_PATH
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web <${UPDATE_POINT}
        else
            sed -i "s/SET .* = .* WHERE aid IN ( SELECT aid FROM ( SELECT aid FROM t_char WHERE accname = .* LIMIT 1 OFFSET .* ) AS aids );/SET ${FIRST_PARAM} = ${SECOND_PARAM} WHERE aid IN ( SELECT aid FROM ( SELECT aid FROM t_char WHERE accname = ${THIRD_PARAM} LIMIT 1 OFFSET 0 ) AS aids );/g" ${UPDATE_TLBBDB_POINT}
            cat ${UPDATE_TLBBDB_POINT} | tee -a $EXCHANGE_LOG_PATH
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb <${UPDATE_TLBBDB_POINT}
        fi
    elif [ $# -eq 4 ] && [[ ${FOURTH_PARAM} -ne 0 ]]; then
        if [ ${FIRST_PARAM} == 'point' ]; then
            sed -i "s/point = .* WHERE name = .*;/point = ${SECOND_PARAM} WHERE name = ${THIRD_PARAM};/g" ${UPDATE_POINT}
            cat ${UPDATE_POINT} | tee -a $EXCHANGE_LOG_PATH
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web <${UPDATE_POINT}
        else
            sed -i "s/SET .* = .* WHERE aid IN ( SELECT aid FROM ( SELECT aid FROM t_char WHERE accname = .* LIMIT 1 OFFSET .* ) AS aids );/SET ${FIRST_PARAM} = ${SECOND_PARAM} WHERE aid IN ( SELECT aid FROM ( SELECT aid FROM t_char WHERE accname = ${THIRD_PARAM} LIMIT 1 OFFSET ${FOURTH_PARAM} ) AS aids );/g" ${UPDATE_TLBBDB_POINT}
            cat ${UPDATE_TLBBDB_POINT} | tee -a $EXCHANGE_LOG_PATH
            echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb <${UPDATE_TLBBDB_POINT}
        fi
    else
        sed -i "s/default .*/default 0/g" ${ALTER_POINT}
        cat ${ALTER_POINT} | tee -a $EXCHANGE_LOG_PATH
        echo -e "\r" | tee -a $EXCHANGE_LOG_PATH
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web <${ALTER_POINT}
    fi
fi
