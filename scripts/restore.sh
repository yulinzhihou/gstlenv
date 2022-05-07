#!/usr/bin/env sh
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2022-05-07
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 还原数据库
# 指定需要恢复的数据库名称。
# 指定需要恢复的数据库文件
# 先备份目标数据库到指定目录
# 再执行还原指定数据库文件
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
    # 颜色代码
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

    if [ $# -ne 2 ]; then
        echo "${CRED}参数不正确，请输入【restore web web.sql】参数1：数据库名，参数2：需要还原的数据库文件的绝对路径 ${CEND}"
        exit 1
    else
        if [ $1 != 'web' ] && [ $1 != 'tlbbdb' ]; then
            echo "${CRED}参数1不正确，请输入 【web】 或者 【tlbbdb】 ${CEND}"
            exit 1
        else
            if [ ! -f $2 ]; then
                echo "${CRED}参数2，数据库文件不存在或者路径不正确，请输入正确文件路径。如：【/tlgame/backup/web-2022-05-06.sql】 ${CEND}"
                exit 1
            else
                FILENAME=$(basename $2)
                # 先执行备份
                backup 2
                # 再复制需要备份的文件到容器里面
                docker cp $2 gsmysql:/tmp/${FILENAME}
                # 再调用脚本还原
                docker exec -it gsmysql /bin/sh /usr/local/bin/gsmysqlRestore.sh $1 /tmp/${FILENAME}

                if [ $? -eq 0 ]; then
                    echo -e "${CSUCCESS} 数据还原成功！！如有疑问可查看【/tlgame/backup】有还原前的备份，可尝试手动使用工具导入${CEND}"
                    exit 0
                else
                    echo -e "${CRED} 数据还原失败！！${CEND}"
                    exit 1
                fi
            fi
        fi
    fi
else
    echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
    exit 1
fi
