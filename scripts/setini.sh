#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-07-11
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 根据env文件的环境变量，修改对应的配置文件，复制配置文件替换到指定目录，并给与相应权限
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
    # 颜色代码
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

    BASE_PATH="/root/.tlgame/config"
    GS_PROJECT_PATH="/tlgame"

    # 增加对合区工具的兼容
    docker exec -d gsmysql chown -R mysql:mysql /var/lib/mysql

    # 前置判断,如果服务端的路径都正确，就直接退出吧。
    if [ ! -d "${GS_PROJECT_PATH}/tlbb/Server/" ]; then
        echo -e "${GSISSUE}\r\n"
        echo "${CRED}请检查服务端的路径是否正确,必须是 /tlgame/tlbb/Server 不能是 /tlgame/tlbb2/Server, /tlgame/tlbbh${CEND}"
        exit 1
    fi

    tar zxf ${BASE_PATH}/ini.tar.gz -C ${BASE_PATH}
    if [ ! -d "${GS_PROJECT_PATH}/billing/" ]; then
        mkdir -p ${GS_PROJECT_PATH}/billing/ &&
            chown -R root:root ${GS_PROJECT_PATH}/billing ${GS_PROJECT_PATH}/tlbb &&
            chmod -R 777 ${GS_PROJECT_PATH}/billing ${GS_PROJECT_PATH}/tlbb
    fi
    \cp -rf ${BASE_PATH}/billing ${GS_PROJECT_PATH}/billing/

    # 解压配置文件，根据服务端程序，进行生成 启动脚本 run.sh
    if [ -f "${BASE_PATH}/run.sh" ]; then
        sed -i '/^exit$/s||tail -f /dev/null|' ${BASE_PATH}/run.sh
    fi

    # 游戏内注册=0，登录器注册=1
    if [ ${IS_DLQ} == 1 ]; then
        sed -i "s/127.0.0.2/${BILLING_SERVER_IPADDR}/g" ${BASE_PATH}/ServerInfo.ini
        sed -i "s/GS_BILLING/sleep 0/g" ${BASE_PATH}/run.sh
    else
        sed -i "s/127.0.0.2/127.0.0.1/g" ${BASE_PATH}/ServerInfo.ini
    fi

    # 游戏配置文件
    if [ "${TL_MYSQL_PASSWORD}" != "123456" ]; then
        sed -i "s/DBPassword=123456/DBPassword=${TL_MYSQL_PASSWORD}/g" ${BASE_PATH}/LoginInfo.ini
        sed -i "s/DBPassword=123456/DBPassword=${TL_MYSQL_PASSWORD}/g" ${BASE_PATH}/ShareMemInfo.ini
        sed -i "s/123456/${TL_MYSQL_PASSWORD}/g" ${BASE_PATH}/odbc.ini
        sed -i "s/123456/${TL_MYSQL_PASSWORD}/g" ${BASE_PATH}/config.yaml
    fi

    if [ ${BILLING_PORT} != "21818" ]; then
        sed -i "s/21818/${BILLING_PORT}/g" ${BASE_PATH}/config.yaml
        sed -i "s/Port0=21818/Port0=${BILLING_PORT}/g" ${BASE_PATH}/ServerInfo.ini
    fi

    if [ "${LOGIN_PORT}" != "13580" ]; then
        sed -i "s/Port0=13580/Port0=${LOGIN_PORT}/g" ${BASE_PATH}/ServerInfo.ini
    fi

    if [ "${SERVER_PORT}" != "15680" ]; then
        sed -i "s/Port0=15680/Port0=${SERVER_PORT}/g" ${BASE_PATH}/ServerInfo.ini
    fi

    if [ ! -d /tlgame/tlbb/Server ]; then
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED}未上传服务端执行解压操作; 正确操作：上传服务端压缩包 tlbb.tar.gz或者 tlbb.zip 到 /root 目录下，执行 untar 再执行本命令${CEND}"
        echo -e "${CRED}上传了服务端也解压了，但服务端的目录名不正确：必须是 /tlgame/tlbb 不能是 /tlgame/tlbb2, /tlgame/tlbbhj${CEND}"
        exit 1
    else
        #复制到已经修改好的文件到指定容器
        \cp -rf ${BASE_PATH}/config.yaml ${GS_PROJECT_PATH}/billing/
        \cp -rf ${BASE_PATH}/LoginInfo.ini ${BASE_PATH}/ShareMemInfo.ini ${BASE_PATH}/ServerInfo.ini ${GS_PROJECT_PATH}/tlbb/Server/Config/
        docker cp -q ${BASE_PATH}/odbc.ini gsserver:/etc
        docker cp -q ${GS_PROJECT}/scripts/step.sh gsserver:/usr/local/bin/step
        docker exec -d gsserver chmod -R 777 /usr/local/bin
        # 复制配置文件
        for file in $(ls -l ${GS_PROJECT}/include | awk '{print $9}'); do
            if [ -n ${file} ]; then
                docker cp -q ${GS_PROJECT}/include/${file} gsmysql:/usr/local/bin/${file}
            fi
        done

        #每次更新后，先重置更改过的文件
        if [ ${IS_DLQ} -eq 0 ]; then
            sed -i "s/GS_BILLING/\/home\/billing\/billing up -d/g" ${BASE_PATH}/run.sh
        fi
        \cp -rf ${BASE_PATH}/run.sh ${GS_PROJECT_PATH}/tlbb &&
            cd ${BASE_PATH}/ &&
            rm -rf ${BASE_PATH}/*.ini ${BASE_PATH}/config.yaml ${BASE_PATH}/billing ${BASE_PATH}/run.sh
        # chown -R root:root ${GS_PROJECT_PATH} &&
        chmod -R 777 ${GS_PROJECT_PATH}/billing ${GS_PROJECT_PATH}/tlbb
        if [ $? -eq 0 ]; then
            echo -e "${CSUCCESS}配置文件已经写入成功，可以执行【runtlbb】进行开服操作！！${CEND}"
            exit 0
        else
            echo -e "${GSISSUE}\r\n"
            echo -e "${CRED}配置文件写入失败！${CEND}"
            exit 1
        fi
    fi
else
    echo -e "${GSISSUE}\r\n"
    echo -e "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
    exit 1
fi
