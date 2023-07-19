#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-09-30
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 一键启动开服日志查看，暂时还未开启
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

    # 查看日志方法
    function tail_log_file() {
        cd ${TLBB_PATH}"/Server/Log" &&
            LOGFILENAME=$(ls -t | grep "${INPUTNAME}" | head -n1 | awk '{print $0}')
        tail -n 100 -f ${LOGFILENAME}
    }

    while :; do
        # 先判断目录是否存在
        if [ -d ${TLBB_PATH}"/Server/Log" ]; then
            # 存在目录则进行打印监听，通过传入的 login ShareMemory world等进程的参数进行查看
            for ((time = 2; time >= 0; time--)); do
                echo -ne "\r正准备查看日志动态！！,【${time}】秒请使用完一定记得关闭（命令【rmlog】）。不然日志可能会挤爆服务器硬盘！${CEND}"
                sleep 1
            done
            while :; do
                echo
                echo -e "
※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
◎ ${CRED}切记 ！！！看完日志需要退出请按 CTRL+C 退出！${CEND}
◎ ${CRED}如果想一次性查看所有日志，需要多开ssh容器分开运行${CEND}
◎ ${CRED}如若需要再查看其他日志，请重新进行本命令！${CEND}
◎ ${CRED}切记 ！！！查看完日志后，请使用【rmlog】命令进行清除，小心挤爆人的服务器${CEND}
◎ [1]：查看 [BILLING] 日志,只有用本服务器billing才能查看
◎ [2]：查看 [ShareMemory] ShareMemory进程日志
◎ [3]：查看 [Login] Login进程日志
◎ [4]：查看 [World] World进程日志
◎ [5]：查看 [Lua] 脚本报错日志
◎ [6]：查看 [debug] 引擎调试(系统相关)日志
◎ [7]：查看 [Debug] 引擎调试(角色相关)日志
◎ [0]：查看 [error] 全局报错日志
◎ [q]：退出按 q 或者 Q，也可以按 CTRL+C 退出！
※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※"
                read -e -p "请选择功能 输入序号并回车：" num
                case "$num" in
                '1')
                    INPUTNAME='billing'
                    if [ -f "/tlgame/billing/log.log" ]; then
                        tail -f /tlgame/billing/log.log
                    else
                        echo -e "${CRED}未发现日志文件，请按 CTRL+C 退出！${CEND}"
                    fi
                    ;;
                '2')
                    INPUTNAME='ShareMemory'
                    tail_log_file
                    ;;
                '3')
                    INPUTNAME='login'
                    tail_log_file
                    ;;
                '4')
                    INPUTNAME='world'
                    tail_log_file
                    ;;
                '5')
                    INPUTNAME='lua'
                    tail_log_file
                    ;;
                '6')
                    INPUTNAME='debug'
                    tail_log_file
                    ;;
                '7')
                    INPUTNAME='Debug'
                    tail_log_file
                    ;;
                'q' | 'Q')
                    break
                    exit 0
                    ;;
                * | "0")
                    INPUTNAME='error'
                    tail_log_file
                    ;;
                esac
            done
        else
            mkdir -p ${TLBB_PATH}"/Server/Log"
        fi
        break
    done
else
    echo -e "${GSISSUE}\r\n"
    echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
    exit 1
fi
