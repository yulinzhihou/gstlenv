#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-09-17
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 帮助命令
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
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

  show_help() {
    cat <<EFF
${CYELLOW}###########################################
#                                         #
#    此命令只获取命令帮助，不会直接执行   #
#                                         #
#    GS游享网  https://gsgameshare.com    #
#                                         #
#    用法1：gs 01  获取第一个命令帮助文档 #
#    用法2：gs 1  获取第一个命令帮助文档  #
#    用法3：gs untar 获取第一个命令帮助文档
#                                         #
###########################################
#    01:untar      解压服务端             #
#    02:setini     配置ini文件            #
#    03:runtlbb    开启服务端             #
#    04:runtop     查看开服状态           #
#    05:link       连接容器               #
#    06:swap       增加虚拟缓存           #
#    07:rebuild    重构环境               #
#    08:remove     移除环境               #
#    09:setconfig  设置配置参数           #
#    10:change     换端                   #
#    11:restart    重启容器               #
#    12:gsbak      备份数据               #
#    13:upcmd      更新全局命令           #
#    14:upgm       配置在线GM网站         #
#    15:upow       配置开服网站           #
#    16:step       分步调试开服           #
#    17:gstl       环境安装初始化         #
#    18:backup     手动备份数据库         #
#    19:close      关服                   #
#    20:gslog      查看日志               #
#    21:rmlog      删除日志               #
#    22:curgs      查看配置               #
#    23:setpoint   设置默认充值点数       #
#    24:reset      删档数据库             #
#    25:setvalid   解/封号                #
#    26:restore    还原数据库             #
#    27:crondel    删除备份文件           #
#    0:q 退出,或者按 CTRL+C               #
###########################################${CEND}
EFF
  }

  #    01:untar
  untar_help() {
    cat <<EOF
${CRED}untar${CEND} ${CGREEN}作用: 解压服务端压缩包，暂时只支持 tlbb.tar.gz 和 tlbb.zip 压缩包
      用法：untar
      条件: 服务端压缩包必须上传到 /root 目录下
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }
  #    02:setini
  setini_help() {
    cat <<EOF
${CRED}setini${CEND} ${CGREEN}作用: 自动设置服务器配置文件，3个【ini】文件，以及数据库连接和 billing 文件
      用法: setini
      条件: 必须要解压了服务端压缩包后执行
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    03:runtlbb
  runtlbb_help() {
    cat <<EOF
${CRED}runtlbb${CEND} ${CGREEN}作用: 运行一键服务端命令，会调用服务端 run.sh 脚本，如果运行不成功，则可能是服务端 run.sh 有问题
      用法: runtlbb
      条件: 必须在 setini / restart 命令后执行，或者重启服务器后
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    04:runtop
  runtop_help() {
    cat <<EOF
${CRED}runtop${CEND} ${CGREEN}作用: 查看开服是否成功，查看是否有 ShareMemory, Login , World, Server 等进程稳定在线
      用法: runtop
      条件: 无
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    05:link
  link_help() {
    cat <<EOF
${CRED}link${CEND} ${CGREEN}作用: 进行服务端所在的容器里面，此容器里面，以上所有命令都无法使用，要使用则需要退出容器，使用 exit 指令即可退出
      用法: link server
      条件: 初始化容器后使用，用于进入容器，查看服务端的具体情况，或者是分步调试
      参数: gsserver|server 连接主服务器容器
            gsmysql|mysql 连接数据库容器
            gsnginx|nginx 连接网站容器
            gsphp|php   连接php容器
            gsredis|redis 连接redis容器  
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    06:swap
  swap_help() {
    cat <<EOF
${CRED}swap${CEND} ${CGREEN}作用: 增加云服务器或者虚拟机系统的虚拟内存，默认增加 4GB 虚拟内存。只是占用硬盘空间，不需要多次执行，但此命令是临时生效，重启服务器后需要再次执行
      用法: swap
      条件: 小于或等于 5GB 内存的虚拟机或者服务器配置，需要使用
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    07:rebuild
  rebuild_help() {
    cat <<EOF
${CRED}rebuild${CEND} ${CGREEN}作用: 删除当前所有容器，当前物理机所存储的数据，相当于重构了环境。
      用法: rebuild
      条件: 相当于刚刚安装好环境的初始化状态
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    08:remove
  remove_help() {
    cat <<EOF
${CRED}remove${CEND} ${CGREEN}作用: 删除所有已经构建好的数据，需要重新安装环境和配置文件
      用法: remove
      条件: 服务器环境错乱了，相当于重装系统
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    09:setconfig
  setconfig_help() {
    cat <<EOF
${CRED}setconfig${CEND} ${CGREEN}作用: 会删除当前服务端版本里面的所有数据，重新配置端口，数据库密码，
      用法: setconfig
      条件: 重新配置命令参数，按提示进行设置，设置完成后，需要配合 setini 命令才会生效
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    10:change
  change_help() {
    cat <<EOF
${CRED}change${CEND} ${CGREEN}作用: 执行此命令，即可完成更换服务端操作，数据库不会清除，原服务端版本的数据还会存在。建议不要使用相同账号进入，可能会报错
      用法: change
      条件: 新的服务端压缩包 【tlbb.tar.gz】或者 【tlbb.zip】必须上传到 /root 目录下
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    11:restart
  restart_help() {
    cat <<EOF
${CRED}restart${CEND} ${CGREEN}作用: 只是相当于重启服务端，不会清空数据，使用后需要重新使用 runtlbb 进行开服操作
      用法: restart
      条件: 前提是服务端开启状态中
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    12:gsbak
  gsbak_help() {
    cat <<EOF
${CRED}gsbak${CEND} ${CGREEN}作用: 开启定时备份，默认是半小时备份一次版本，半小时备份一次数据库，保存7天的文件
      用法: gsbak 1
      描述: 表示会自动1小时进行备份操作
      条件: 暂时只支持一次性设置 N 小时定时备份一次
      参数: 1-23
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    13:upcmd
  upcmd_help() {
    cat <<EOF
${CRED}upcmd${CEND} ${CGREEN}作用: 更新命令，更新上述所有命令，更新命令到最新版本
      用法: upcmd
      条件: 无
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    14:upgm
  upgm_help() {
    cat <<EOF
${CRED}upgm${CEND} ${CGREEN}作用: 增加GM网站，暂时只支持GS游享网定制的在线GM管理系统
      用法: upgm
      条件: 无
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    15:upow
  upow_help() {
    cat <<EOF
${CRED}upow${CEND} ${CGREEN}作用: 增加官方网站，游戏官网，首页index.html、index.htm。
      用法: upow
      条件: 无
      参数: 无 
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    16:step
  step_help() {
    cat <<EOF
${CRED}step${CEND} ${CGREEN}作用: 分步调试命令脚本，需要配合参数使用。用来调试服务端，主要用于修改版本使用。可以即时发现问题
      用法: step 1
      条件: 需要复制或者克隆多个SSH容器
      参数: 1，2，3，4，5 分别代表启动五个不同的进程。
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    17:gstl
  gstl_help() {
    cat <<EOF
${CRED}gstl${CEND} ${CGREEN}[已废弃]作用: 环境初始化命令，根据提示进行安装。如果已经安装过，则会自动检测退出
      用法: gstl
      条件: 无
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    18:backup
  backup_help() {
    cat <<EOF
${CRED}backup${CEND} ${CGREEN}作用: 手动执行备份服务端版本，数据库。 备份目录在 /tlgame/backup 目录下
      用法: backup
      条件: 无
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    19:close
  close_help() {
    cat <<EOF
${CRED}close${CEND} ${CGREEN}作用: 关闭服务端
      用法: close 作用同 restart
      描述: 因为之前close方式关闭服务端，会出现长时间进程卡死情况，无法完全关闭，所以直接使用restart命令替代
      条件: 无
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    20:gslog
  gslog_help() {
    cat <<EOF
${CRED}gslog${CEND} ${CGREEN}作用: 查看调试日志，开启后，/tlgame/tlbb/Server/Log 目录会开启，里面存放服务端运行的所有日志
      条件: ◎ [1]：查看 [BILLING] 日志,只有用本服务器billing才能查看
            ◎ [2]：查看 [ShareMemory] 日志
            ◎ [3]：查看 [Login] 日志
            ◎ [4]：查看 [World] 日志
            ◎ [0]：查看 [error] 日志
            ◎ [q]：退出按 q 或者 Q，也可以按 CTRL+C 退出！
      描述: 也可自行去 /tlgame/tlbb/Server/Log 目录里面自行查看更多调试日志文件
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    21:rmlog
  rmlog_help() {
    cat <<EOF
${CRED}rmlog${CEND} ${CGREEN}作用: 删除调试日志，全清除 /tlgame/tlbb/Server/Log 目录
      用法: rmlog
      条件: 无
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    22:curgs
  curgs_help() {
    cat <<EOF
${CRED}curgs${CEND} ${CGREEN}作用: 查看配置信息，包括端口号，账号密码等
      用法: curgs
      描述: 显示当前服务器的配置信息
      条件: 请不要在大众面前使用，因为服务器的配置信息容易暴露
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    23:setpoint
  setpoint_help() {
    cat <<EOF
${CRED}setpoint${CEND} ${CGREEN}作用: 修复注册账号送默认充值点
      使用: setpoint 888
      描述: 表示从设置此命令起，注册的账号会自动赠送888的充值点数
      条件: 设置默认充值点，从即刻起，注册新账号会有默认的充值点
      参数: 1个 请输入0-21亿内的整数
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    24:reset
  reset_help() {
    cat <<EOF
${CRED}reset${CEND} ${CGREEN}作用: 删档数据库
      使用: reset
      条件: 清空账号数据库，角色数据库数据。使用前请一定要备份好，如有误删本环境概不负责
      参数: 无
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    25:setvalid
  setvalid_help() {
    cat <<EOF
${CRED}reset${CEND} ${CGREEN}作用: 封号/解封号
      使用: setvalid test@game.sohu.com 1
      条件: 封号 setvalid test@game.sohu.com 1； 解封 setvalid test@game.sohu.com
      参数: 1个或2个
      参数1: 游戏注册的账号，如 test@game.sohu.com
      参数2: 1 表示封号，不输入表示解封。
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }

  #    26:restore
  restore_help() {
    cat <<EOF
${CRED}restore${CEND} ${CGREEN}作用: 使用命令行进行数据库还原操作
      用法: restore web /tlgame/backup/web-2022-05-05-15-15-15.sql
      条件: 前提是服务端开启状态中
      参数: 2个
      参数1: 需要还原的数据库，web 或者 tlbbdb 
      参数2: 数据库文件的绝对路径， /tlgame/backup/web-2022-05-05-15-15-15.sql
      说明: 如有问题，可以向客服反馈
${CEND}
EOF
  }
  # 27 crondel
  crondel_help() {
    cat <<EOF
${CRED}crondel${CEND} ${CGREEN}作用: 删除备份文件，默认保留最新的文件各10份
      用法: crondel
      条件: 暂无
      参数: 暂无
      说明: 默认 gsbak 会1小时备份一次 web tlbbdb库，tlbb版本。crondel会定时删除多余的备份文件，只保留三种备份的各10份最新文件
${CEND}
EOF
  }

  # 执行
  if [ ! -z $1 ]; then
    case "$1" in
    '01' | '1' | 'untar')
      untar_help
      ;;
    '02' | '2' | 'setini')
      setini_help
      ;;
    '03' | '3' | 'runtlbb')
      runtlbb_help
      ;;
    '04' | '4' | 'runtop')
      runtop_help
      ;;
    '05' | '5' | 'link')
      link_help
      ;;
    '06' | '6' | 'swap')
      swap_help
      ;;
    '07' | '7' | 'rebuild')
      rebuild_help
      ;;
    '08' | '8' | 'remove')
      remove_help
      ;;
    '09' | '9' | 'setconfig')
      setconfig_help
      ;;
    '10' | 'change')
      change_help
      ;;
    '11' | 'restart')
      restart_help
      ;;
    '12' | 'gsbak')
      gsbak_help
      ;;
    '13' | 'upcmd')
      upcmd_help
      ;;
    '14' | 'upgm')
      upgm_help
      ;;
    '15' | 'upow')
      upow_help
      ;;
    '16' | 'step')
      step_help
      ;;
    '17' | 'gstl')
      gstl_help
      ;;
    '18' | 'backup')
      backup_help
      ;;
    '19' | 'close')
      close_help
      ;;
    '20' | 'gslog')
      gslog_help
      ;;
    '21' | 'rmlog')
      rmlog_help
      ;;
    '22' | 'curgs')
      curgs_help
      ;;
    '23' | 'setpoint')
      setpoint_help
      ;;
    '24' | 'reset')
      reset_help
      ;;
    '25' | 'setvalid')
      setvalid_help
      ;;
    '26' | 'restore')
      restore_help
      ;;
    '27' | 'crondel')
      crondel_help
      ;;
    '0' | '00' | 'q' | 'Q')
      break
      ;;
    *)
      show_help
      ;;
    esac
  else
    show_help
    while :; do
      echo
      read -e -p "${CCYAN}按上面展示的编号或者命令输入:${CEND}" IS_MODIFY
      IS_MODIFY=${IS_MODIFY:-'n'}
      if [[ $IS_MODIFY == 'n' ]]; then
        echo "${CWARNING}输入错误! ${CEND}"
        exit 1
      else
        case "$IS_MODIFY" in
        '01' | '1' | 'untar')
          untar_help
          ;;
        '02' | '2' | 'setini')
          setini_help
          ;;
        '03' | '3' | 'runtlbb')
          runtlbb_help
          ;;
        '04' | '4' | 'runtop')
          runtop_help
          ;;
        '05' | '5' | 'link')
          link_help
          ;;
        '06' | '6' | 'swap')
          swap_help
          ;;
        '07' | '7' | 'rebuild')
          rebuild_help
          ;;
        '08' | '8' | 'remove')
          remove_help
          ;;
        '09' | '9' | 'setconfig')
          setconfig_help
          ;;
        '10' | 'change')
          change_help
          ;;
        '11' | 'restart')
          restart_help
          ;;
        '12' | 'gsbak')
          gsbak_help
          ;;
        '13' | 'upcmd')
          upcmd_help
          ;;
        '14' | 'upgm')
          upgm_help
          ;;
        '15' | 'upow')
          upow_help
          ;;
        '16' | 'step')
          step_help
          ;;
        '17' | 'gstl')
          gstl_help
          ;;
        '18' | 'backup')
          backup_help
          ;;
        '19' | 'close')
          close_help
          ;;
        '20' | 'gslog')
          gslog_help
          ;;
        '21' | 'rmlog')
          rmlog_help
          ;;
        '22' | 'curgs')
          curgs_help
          ;;
        '23' | 'setpoint')
          setpoint_help
          ;;
        '24' | 'reset')
          reset_help
          ;;
        '25' | 'setvalid')
          setvalid_help
          ;;
        '26' | 'restore')
          restore_help
          ;;
        '27' | 'crondel')
          crondel_help
          ;;
        '0' | '00' | 'q' | 'Q')
          break
          ;;
        *)
          show_help
          ;;
        esac
      fi
    done
  fi
else
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
