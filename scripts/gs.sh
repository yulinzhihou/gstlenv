#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-09-17
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 帮助命令
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

show_help() {
cat <<EFF
${CYELLOW}###########################################
#                                         #
#    GS游享网  https://gsgameshare.com    #
#    输入编号或者命令名称获取帮助         #
#                                         #
###########################################
#    01:untar      解压服务端             #
#    02:setini     配置ini参数            #
#    03:runtlbb    开启服务端             #
#    04:runtop     查看开服状态           #
#    05:link       连接容器               #
#    06:swap       增加虚拟缓存           #
#    07:rebuild    重构环境               #
#    08:remove     移除环境               #
#    09:setconfig  重新初始化配置         #
#    10:change     换端                   #
#    11:restart    重启服务端             #
#    12:gsbak      备份数据               #
#    13:upcmd      更新全局命令           #
#    14:upgm       配置在线GM网站         #
#    15:upow       配置开服网站           #
#    16:step       分步调试开服           #
#    17:gstl       环境安装初始化         #
#    18:backup     手动备份数据库         #
#    19:close      关服                   #
#    0:q 退出,或者按 CTRL+C               #
###########################################${CEND}
EFF
}


#    01:untar  
untar_help() {
cat  <<EOF
${CRED}untar${CEND} ${CGREEN}作用: 解压服务端压缩包，暂时只支持 tlbb.tar.gz 和 tlbb.zip 压缩包
      条件: 服务端压缩包必须上传到 /root 目录下
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
};
#    02:setini  
setini_help() {
cat  <<EOF
${CRED}setini${CEND} ${CGREEN}作用: 自动设置服务器配置文件，3个【ini】文件，以及数据库连接和 billing 文件
      条件: 必须要解压了服务端压缩包后执行
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    03:runtlbb  
runtlbb_help() {
cat  <<EOF
${CRED}runtlbb${CEND} ${CGREEN}作用: 运行一键服务端命令，会调用服务端 run.sh 脚本，如果运行不成功，则可能是服务端 run.sh 有问题
      条件: 必须在 setini / restart 命令后执行，或者重启服务器后
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    04:runtop  
runtop_help() {
cat  <<EOF
${CRED}runtop${CEND} ${CGREEN}作用: 查看开服是否成功，查看是否有 ShareMemory, Login , World, Server 等进程稳定在线
      条件: 无
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    05:link    
link_help() {
cat  <<EOF
${CRED}link${CEND} ${CGREEN}作用: 进行服务端所在的容器里面，此容器里面，以上所有命令都无法使用，要使用则需要退出容器，使用 exit 指令即可退出
      条件: 初始化容器后使用，用于进入容器，查看服务端的具体情况，或者是分步调试
      参数: gsserver 连接主服务器容器
            gsmysql 连接数据库容器
            gsnginx 连接网站容器
            gsphp   连接php容器
            gsredis 连接redis容器  
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    06:swap    
swap_help() {
cat  <<EOF
${CRED}swap${CEND} ${CGREEN}作用: 增加云服务器或者虚拟机系统的虚拟内存，默认增加 4GB 虚拟内存。只是占用硬盘空间，不需要多次执行，但此命令是临时生效，重启服务器后需要再次执行
      条件: 小于或等于 5GB 内存的虚拟机或者服务器配置，需要使用
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    07:rebuild  
rebuild_help() {
cat  <<EOF
${CRED}rebuild${CEND} ${CGREEN}作用: 删除当前所有容器，当前物理机所存储的数据，相当于重构了环境。
      条件: 相当于刚刚安装好环境的初始化状态
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    08:remove   
remove_help() {
cat  <<EOF
${CRED}remove${CEND} ${CGREEN}作用: 删除所有已经构建好的数据，需要重新安装环境和配置文件
      条件: 服务器环境错乱了，相当于重装系统
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    09:setconfig
setconfig_help() {
cat  <<EOF
${CRED}setconfig${CEND} ${CGREEN}作用: 会删除当前服务端版本里面的所有数据，重新配置端口，数据库密码，
      条件: 重新配置命令参数，按提示进行设置，设置完成后，需要配合 setini 命令才会生效
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    10:change  
change_help() {
cat  <<EOF
${CRED}change${CEND} ${CGREEN}作用: 执行此命令，即可完成更换服务端操作，数据库不会清除，原服务端版本的数据还会存在。建议不要使用相同账号进入，可能会报错
      条件: 新的服务端压缩包 【tlbb.tar.gz】或者 【tlbb.zip】必须上传到 /root 目录下
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    11:restart 
restart_help() {
cat  <<EOF
${CRED}restart${CEND} ${CGREEN}作用: 重启环境，不会清空数据，只是相当于重启服务端	
      条件: 前提是容器开启状态中
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    12:gsbak   
gsbak_help() {
cat  <<EOF
${CRED}gsbak${CEND} ${CGREEN}作用: 开启定时备份，默认是半小时备份一次版本，半小时备份一次数据库，保存7天的文件
      条件: 暂时不支持定制时间
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    13:upcmd 
upcmd_help() {
cat  <<EOF
${CRED}upcmd${CEND} ${CGREEN}作用: 更新命令，更新上述所有命令。
      条件: 无
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}
   
#    14:upgm
upgm_help() {
cat  <<EOF
${CRED}upgm${CEND} ${CGREEN}作用: 增加GM网站，暂时只支持GS游享网定制的在线GM管理系统
      条件: 无
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    15:upow  
upow_help() {
cat  <<EOF
${CRED}upow${CEND} ${CGREEN}作用: 增加官方网站，游戏官网，首页index.html、index.htm。
      条件: 无
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    16:step 
step_help() {
cat  <<EOF
${CRED}step${CEND} ${CGREEN}作用: 分步调试命令脚本，需要配合参数使用。用来调试服务端，主要用于改版本使用。可以即时发现问题
      条件: 需要复制或者克隆多个SSH容器
      参数: 1，2，3，4 分别代表启动四个不同的进程。
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    17:gstl  
gstl_help() {
cat  <<EOF
${CRED}gstl${CEND} ${CGREEN}作用: 环境初始化命令，根据提示进行安装。如果已经安装过，则会自动检测退出
      条件: 无
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    18:backup 
backup_help() {
cat  <<EOF
${CRED}backup${CEND} ${CGREEN}作用: 手动备份版本，数据库版本。
      条件: 无
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

#    19:close   
close_help() {
cat  <<EOF
${CRED}close${CEND} ${CGREEN}作用: 关闭服务端
      条件: 无
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
}

# 执行
show_help
while :; do echo
    read -e -p "${CCYAN}按上面展示的编号或者命令输入:${CEND}" IS_MODIFY
    IS_MODIFY=${IS_MODIFY:-'n'}
    if [[ $IS_MODIFY == 'n' ]]; then
        echo "${CWARNING}输入错误! ${CEND}"
        exit 1;
    else
        case "$IS_MODIFY" in
          '01'|'1'|'untar')
            untar_help;;
          '02'|'2'|'setini')
            setini_help;;
          '03'|'3'|'runtlbb')
            runtlbb_help;;
          '04'|'4'|'runtop')
            runtop_help;;
          '05'|'5'|'link')
            link_help;;
          '06'|'6'|'swap')
            swap_help;;
          '07'|'7'|'rebuild')
            rebuild_help;;
          '08'|'8'|'remove')
            remove_help;;
          '09'|'9'|'setconfig')
            setconfig_help;;
          '10'|'change')
            change_help;;
          '11'|'restart')
            restart_help;;
          '12'|'gsbak')
            gsbak_help;;
          '13'|'upcmd')
            upcmd_help;;
          '14'|'upgm')
            upgm_help;;
          '15'|'upow')
            upow_help;;
          '16'|'step')
            step_help;;
          '17'|'gstl')
            gstl_help;;
          '18'|'backup')
            backup_help;;
          '19'|'close')
            close_help;;
          '0'|'00'|'q'|'Q')
            break;;
          *)
            show_help;;
        esac
    fi
done
