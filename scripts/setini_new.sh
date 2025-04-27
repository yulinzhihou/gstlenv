#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2025-04-27
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

    #每次更新后，先重置更改过的文件
    if [ ${IS_DLQ} -eq 0 ]; then
        echo "/home/billing/billing up -d" >>${GS_PROJECT_PATH}/tlbb/run.sh
    fi
    # 解压配置文件，根据服务端程序，进行生成 启动脚本 run.sh
    if [ -f "${GS_PROJECT_PATH}/tlbb/run.sh" ]; then
        sed -i '/^exit$/s||sleep 1|' ${GS_PROJECT_PATH}/tlbb/run.sh
        echo "tail -f /dev/null" >>${GS_PROJECT_PATH}/tlbb/run.sh
    fi

    # 游戏内注册=0，登录器注册=1
    if [ ${IS_DLQ} == 1 ]; then
        sed -i "s/GS_BILLING/sleep 0/g" ${GS_PROJECT_PATH}/tlbb/run.sh
    fi

    # 先将编码转换一下
    # 三个 ini 文件的替换
    # 定义新值（根据你的需求修改）
    IP1="${BILLING_SERVER_IPADDR}"
    PORT1="${BILLING_PORT}"
    IP2="127.0.0.1"
    PORT2="${SERVER_PORT}"
    IP3="127.0.0.1"
    PORT3="${LOGIN_PORT}"

    # 使用 awk 替换内容并强制保留 Windows 格式
    awk -v ip1="$IP1" -v port1="$PORT1" \
        -v ip2="$IP2" -v port2="$PORT2" \
        -v ip3="$IP3" -v port3="$PORT3" '
BEGIN {
    ips[0] = ip1
    ports[0] = port1
    ips[1] = ip2
    ports[1] = port2
    ips[2] = ip3
    ports[2] = port3
    count = 0
}
/^IP0=/ {
    # 替换 IP0 并递增计数器
    $0 = "IP0=" ips[count]
    count++
}
/^Port0=/ {
    # 替换 Port0（使用前一个 IP 对应的端口）
    $0 = "Port0=" ports[count-1]
}
{
    print
}
' "${GS_PROJECT_PATH}/tlbb/Server/Config/ServerInfo.ini" >${BASE_PATH}/tmp1 &&
        # 1. 强制转换换行符为 CRLF（双重保障）
        unix2dos ${BASE_PATH}/tmp1 &&
        # 2. 清理孤立 \r 字符（避免 \015 问题）
        # sed -i 's/\r$//' tmp1 &&
        # 3. 强制转为 ASCII 编码（清理特殊字符）
        # iconv -f ASCII -t ASCII//TRANSLIT//IGNORE -o tmp1 tmp1 &&

        # 定义新值（根据你的需求修改）
        # 定义新值（根据你的需求修改）
        DBIP_NEW="gsmysql"
    DBPort_NEW="3306"
    DBName_NEW="tlbbdb"
    DBUser_NEW="root"
    DBPassword_NEW="${TL_MYSQL_PASSWORD}"

    # 使用 awk 替换内容并强制保留 Windows 格式
    awk -v dbip="$DBIP_NEW" -v dbport="$DBPort_NEW" \
        -v dbname="$DBName_NEW" -v dbuser="$DBUser_NEW" \
        -v dbpassword="$DBPassword_NEW" '
/^\[System\]/ { in_system=1 }
/^\[/ && !/\[System\]/ { in_system=0 }
in_system && /^DBIP=/ { $0="DBIP=" dbip }
in_system && /^DBPort=/ { $0="DBPort=" dbport }
in_system && /^DBName=/ { $0="DBName=" dbname }
in_system && /^DBUser=/ { $0="DBUser=" dbuser }
in_system && /^DBPassword=/ { $0="DBPassword=" dbpassword }
{ print }  # 打印所有行（包括未修改的）
' "${GS_PROJECT_PATH}/tlbb/Server/Config/LoginInfo.ini" >${BASE_PATH}/tmp2 &&
        # 1. 强制转换换行符为 CRLF（双重保障）
        unix2dos ${BASE_PATH}/tmp2 &&
        # 2. 清理孤立 \r 字符（避免 \015 问题）
        # sed -i 's/\r$//' tmp2 &&
        # 3. 强制转为 ASCII 编码（清理特殊字符）
        # iconv -f ASCII -t ASCII//TRANSLIT//IGNORE -o tmp2 tmp2 &&

        # 定义新值（根据你的需求修改）
        DBIP_NEW="gsmysql"
    DBPort_NEW="3306"
    DBName_NEW="tlbbdb"
    DBUser_NEW="root"
    DBPassword_NEW="${TL_MYSQL_PASSWORD}"

    # 使用 awk 替换内容并强制保留 Windows 格式
    awk -v dbip="$DBIP_NEW" -v dbport="$DBPort_NEW" \
        -v dbname="$DBName_NEW" -v dbuser="$DBUser_NEW" \
        -v dbpassword="$DBPassword_NEW" '
/^\[System\]/ { in_system=1 }
/^\[/ && !/\[System\]/ { in_system=0 }
in_system && /^DBIP=/ { $0="DBIP=" dbip }
in_system && /^DBPort=/ { $0="DBPort=" dbport }
in_system && /^DBName=/ { $0="DBName=" dbname }
in_system && /^DBUser=/ { $0="DBUser=" dbuser }
in_system && /^DBPassword=/ { $0="DBPassword=" dbpassword }
{ print }
' "${GS_PROJECT_PATH}/tlbb/Server/Config/ShareMemInfo.ini" >${BASE_PATH}/tmp3 &&
        # 1. 强制转换换行符为 CRLF
        unix2dos ${BASE_PATH}/tmp3 &&
        # 2. 清理孤立 \r 字符
        # sed -i 's/\r$//' tmp3 &&
        # 3. 强制转为 ASCII 编码
        # iconv -f ASCII -t ASCII//TRANSLIT//IGNORE -o tmp3 tmp3 &&

        # 定义变量（根据你的需求修改值）
        SERVER_VAR="gsmysql"
    PORT_VAR="3306"
    USER_VAR="root"
    PASSWORD_VAR="${TL_MYSQL_PASSWORD}"
    DATABASE_VAR="tlbbdb"

    # 使用双引号包裹EOF以启用变量替换
    ODBCConfig= <<"EOF"
[tlbbdb]
Driver		= /usr/lib/libmyodbc5.so
Description	= MyODBC Driver DSN
SERVER		= ${SERVER_VAR}
PORT		= ${PORT_VAR}
USER		= ${USER_VAR}
Password	= ${PASSWORD_VAR}
Database	= ${DATABASE_VAR}
OPTION		= 3
SOCKET		=
 
[Default]
Driver		= /usr/lib/libmyodbc5.so
Description	= MyODBC Driver DSN
SERVER	   	= ${SERVER_VAR}
PORT		= ${PORT_VAR}
USER		= ${USER_VAR}
Password	= ${PASSWORD_VAR}
Database	= ${DATABASE_VAR}
OPTION		= 3
SOCKET		=

EOF

    # 输出结果验证
    echo "$ODBCConfig" >>${BASE_PATH}/odbc.ini

    # 定义变量（根据你的需求修改值）
    BILLING_DB_HOST="gsmysql"
    BILLING_DB_PORT="3306"
    BILLING_DB_USER="root"
    BILLING_DB_PASS="${TL_MYSQL_PASSWORD}"
    BILLING_DB_NAME="web"

    # 使用双引号包裹EOF以启用变量替换
    BillingConfig= <<"EOF"
ip: 127.0.0.1
port: 21818
db_host:  ${BILLING_DB_HOST}
db_port: ${BILLING_DB_PORT}
db_user: ${BILLING_DB_USER}
db_password: ${BILLING_DB_PASS}
db_name: ${BILLING_DB_NAME}
allow_old_password: false
auto_reg: true
# allow_ips:
#  - 127.0.0.1
#  - 192.168.10.3
point_fix: 0
max_client_count: 500
pc_max_client_count: 3

EOF

    # 输出结果验证
    echo "$BillingConfig" >>${BASE_PATH}/config.yaml

    if [ ! -d /tlgame/tlbb/Server ]; then
        echo -e "${GSISSUE}\r\n"
        echo -e "${CRED}未上传服务端执行解压操作; 正确操作：上传服务端压缩包 tlbb.tar.gz或者 tlbb.zip 到 /root 目录下，执行 untar 再执行本命令${CEND}"
        echo -e "${CRED}上传了服务端也解压了，但服务端的目录名不正确：必须是 /tlgame/tlbb 不能是 /tlgame/tlbb2, /tlgame/tlbbhj${CEND}"
        exit 1
    else
        #复制到已经修改好的文件到指定容器
        \cp -rf ${BASE_PATH}/config.yaml ${GS_PROJECT_PATH}/billing/
        # 复制 ini 到 tlbb 配置目录
        \cp -rf ${BASE_PATH}/tmp1 "${GS_PROJECT_PATH}/tlbb/Server/Config/ServerInfo.ini"
        \cp -rf ${BASE_PATH}/tmp2 "${GS_PROJECT_PATH}/tlbb/Server/Config/LoginInfo.ini"
        \cp -rf ${BASE_PATH}/tmp3 "${GS_PROJECT_PATH}/tlbb/Server/Config/ShareMemInfo.ini"
        # 部署配置文件到容器里面
        docker cp -q ${BASE_PATH}/odbc.ini gsserver:/etc
        docker cp -q ${GS_PROJECT}/scripts/step.sh gsserver:/usr/local/bin/step
        docker exec -d gsserver chmod -R 777 /usr/local/bin
        # 复制配置文件
        for file in $(ls -l ${GS_PROJECT}/include | awk '{print $9}'); do
            if [ -n ${file} ]; then
                docker cp -q ${GS_PROJECT}/include/${file} gsmysql:/usr/local/bin/${file}
            fi
        done

        cd ${BASE_PATH}/ &&
            rm -rf ${BASE_PATH}/*.ini ${BASE_PATH}/config.yaml ${BASE_PATH}/billing
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
