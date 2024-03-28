#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2024-09-16
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 用来配置在线GM网站访问
# 增加容器是否存在的判断
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
  # 1、上传或者下载GM包
  # 2、验证包是否完整
  # 3、解压验证
  # 4、创建目录，解压程序包，程序目录必须和tlbb目录在同一层级
  # 5、修改配置。先查看tlbb目录是否存在
  # 6、修改Script.dat,查看里面是否存在相同脚本id，1111111
  # 7、修改 ScriptGlobal.lua，查看是否存在 GS_ONLINE_GAME_TOOLS,
  # 8、存在则提示修改为开启状态。0或者1
  # 9、如果脚本里面存在111111脚本ID，确定是本脚本而不是其他脚本，如果是本脚本则直接使用，如果是别的脚本，则修改脚本ID为其他不存在的值。
  # 10、导入web.sql文件到 web数据库。
  # 11、修改.env文件配置，mysql,redis都得用宿主机的ip地址和暴露出来的端口。
  # 12、启动程序并加为系统服务，设置开机自动启动

  # 获取安装包 群共享，网盘，论坛网站获取
  # 必须上传 tar.gz 和 .sha256文件
  function get_distribution_package() {
     if [ ! -r /root/GSOnlineGM.tar.gz ] || [ ! -r /root/GSOnlineGM.sha256 ];
        echo -e "${CRED}请上传 [GSOnlineGM.tar.gz] 和 [GSOnlineGM.sha256] 两个文件到 /root 目录下，缺一不可\r\n${CEND}"
        echo -e "${CRED}如果没有文件，添加客服QQ：1303588722 免费获取，或者进入网站 https://gsgameshare.com 免费下载${CEND}"
        exit 1
     fi
     # 验证包的完整性。
     if [ -f /usr/bin/sha256sum ]; then 
        SHA_1=$(cat /root/GSOnlineGM.sha256 | awk '{print $1}')
        SHA_2=$(sha256sum /root/GSOnlineGM.tar.gz | awk '{print $1}')
        if [ $SHA_1 != $SHA_2]; then
          echo -e "${CRED} GS游享GM在线发货安装包被非法串改，请不要使用，请从GS游享官方渠道下载 ！！！${CEND}"
          exit 1
        fi
     fi
     # 验证完成 。创建包
     tar zxf -C GSOnlineGM.tar.gz -C /tlgame
     chmod -R 777 /tlgame/GSOnlineGM
     chonw -R root.root /tlgame/GSOnlineGM
     if [ -r /tlgame/GSOnlineGM/GSOnlineGM ]; then
        echo -e "${CSUCCESS} GS游享GM在线发货已经解压完成！！！${CEND}"
     else
        echo -e "${CRED} GS游享GM在线发货安装包不存在或者异常，请从GS游享官方渠道下载 ！！！${CEND}"
        exit 1
     fi
  }

  # 修改配置  script.dat,和 ScriptGlobal.lua两个文件的修改
  function set_lua_config(){
    SCRIPT_DAT=/tlgame/tlbb/Public/Data/Script.dat
    SCRIPT_GLOBAL=/tlgame/tlbb/Public/Data/Script/ScriptGlobal.lua
    CORE_LUA=/tlgame/GSOnlineGM/Core.lua

    if [ ! -r $SCRIPT_DAT ] || [ ! -r $SCRIPT_GLOBAL ]; then
        echo -e "${CRED}请先开服，再进行GS游戏在线GM工具的配置\r\n${CEND}"
        exit 1
    fi

    # 查找有没有脚本ID存在
    IS_EXISTS_SCRIPT_ID=$(grep -q "111111" $SCRIPT_DAT)
    if [ $IS_EXISTS_SCRIPT_ID -eq 0 ]; then
      # 表示存在
      IS_EXISTS_SCRIPT_LUA=$(grep -q "\\Core.lua" $SCRIPT_DAT)
      if [ $IS_EXISTS_SCRIPT_ID -eq 1 ]; then
        # 表示不存在，此脚本ID被其他脚本所占用换ID
        # 先查询几个ID是否存在于 script.dat里面
        SCRIPT_ID=(222222,333333,444444,555555,666666,777777,888888,999999,802320)
        for INDEX in "${!SCRIPT_ID[@]}"; do
            IS_EXISTS_SCRIPT_ID=$(grep -q ${SCRIPT_ID[$INDEX]} $SCRIPT_DAT)
             if [ $IS_EXISTS_SCRIPT_ID -eq 0 ]; then
                # 替换模板文件里面的111111为指定的
                sed 's/111111/${SCRIPT_ID[$INDEX]}/g' $CORE_LUA
                # 再追加到ScriptGlobal.lua
                echo "${SCRIPT_ID[$INDEX]}=\\Core.lua" >> $SCRIPT_DAT
                break
             fi
        done
      fi
    else
      # 表示不存在 210005=\xxxx.lua 直接追加进去
      echo "111111=\Core.lua" >> $SCRIPT_DAT;
    fi

    echo "GS_ONLINE_GAME_TOOLS=1" >> $SCRIPT_GLOBAL
    echo -e "${CSUCCESS} GS游享GM在线发货配置写入成功，请查看 Script.dat文件最后一行对应的脚本有没在存在！！！${CEND}"
  }

  # 导入数据库到 web 库
  function import_sql_to_web() {
    SQL_FILE=/tlgame/GSOnlineGM/web.sql
    if [ -r $SQL_FILE ]; then
      # 再复制需要备份的文件到容器里面
      docker cp -q $SQL_FILE gsmysql:/tmp/web.sql
      # 再调用脚本还原
      docker exec -it gsmysql /bin/bash /usr/local/bin/gsmysqlRestore.sh web /tmp/web.sql
    else
      echo -e "${CRED} GS游享GM在线发货安装包,未发现 sql 文件，被非法串改，请从GS游享官方渠道下载 ！！！${CEND}"
      exit 1
    fi 

    if [ $? -eq 0 ]; then
      echo -e "${CSUCCESS} GS游享GM在线发货系统安装成功！！！${CEND}"
    fi
  }

  # 核心调用方法
  function main() {
    # 开始
    get_distribution_package
    set_lua_config
    import_sql_to_web
    
    # 11、修改.env文件配置，mysql,redis都得用宿主机的ip地址和暴露出来的端口。
    # 12、启动程序并加为系统服务，设置开机自动启动
    ENV_EXAMPLE_FILE=/tlgame/GSOnlineGM/.env.example
    ENV_FILE=/tlgame/GSOnlineGM/.env
    if [ -r $ENV_FILE ]; then
      \cp -rf $ENV_EXAMPLE_FILE $ENV_FILE
      # 开始替换配置文件
      sed -i "s/REDIS_PASS=.*/REDIS_PASS=''/g" $ENV_FILE # REDIS密码
      sed -i "s/REDIS_PORT=.*/REDIS_PORT=''/g" $ENV_FILE # REDIS密码
      sed -i "s/DB_PASS=.*/DB_PASS=''/g" $ENV_FILE # web库密码
      sed -i "s/DB_PORT=.*/DB_PORT=''/g" $ENV_FILE # web库端口
      sed -i "s/TLBB_PASS=.*/TLBB_PASS=''/g" $ENV_FILE # tlbbdb库密码
      sed -i "s/TLBB_PORT=.*/TLBB_PORT=''/g" $ENV_FILE # tlbbdb库端口
      
    else
      echo -e "${CRED} GS游享GM在线发货安装包,未发现 .env.example 文件，被非法串改，请从GS游享官方渠道下载 ！！！${CEND}"
      exit 1
    fi

    # sed -i "s/IS_DLQ=.*/IS_DLQ=${IS_NEW_DLQ}/g"
    if [ $? -eq 0 ]; then
      echo -e "${CSUCCESS} GS游享GM在线发货系统配置文件替换成功，准备启动！！！${CEND}"
      cd /tlgame/GSOnlineGM && ./GSOnlineGM start -d~
    else
      echo -e "${CRED} GS游享GM在线发货系统配置文件替换失败！！！，被非法串改，请从GS游享官方渠道下载 ！！！${CEND}"
      exit 1
    fi

  }



else
  echo -e "${GSISSUE}\r\n"
  echo -e "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
