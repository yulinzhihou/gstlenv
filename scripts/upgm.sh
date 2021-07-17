#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 用来配置在线GM网站访问。默认网站内容请自觉上传到/tlgame/www/gsgm目录下
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




touch ServerInfo.ini ShareMemInfo.ini LoginInfo.ini
iconv -f ISO-8859-1 -t UTF-8//TRANSLIT ServerInfo.ini -o ServerInfo.ini
iconv -f ISO-8859-1 -t UTF-8//TRANSLIT ShareMemInfo.ini -o ShareMemInfo.ini
iconv -f ISO-8859-1 -t UTF-8//TRANSLIT LoginInfo.ini -o LoginInfo.ini

echo -e "[System]">ShareMemInfo.ini
echo -e "DBIP=gsmysql		;数据库ip">> ShareMemInfo.ini
echo -e "DBPort=3306		;数据库端口">> ShareMemInfo.ini
echo -e "DBName=tlbbdb		;数据库名称">> ShareMemInfo.ini
echo -e "DBUser=root		;用户名">> ShareMemInfo.ini
echo -e "DBPassword=sinall0	;密码">> ShareMemInfo.ini
echo -e "SMUInterval=1200000		;world数据存盘时间（毫秒）">> ShareMemInfo.ini
echo -e "DATAInterval=900000		;Human数据存盘时间(毫秒）">> ShareMemInfo.ini
echo -e "CryptPwd=0		;密码是否加密">> ShareMemInfo.ini
echo -e "" >> ShareMemInfo.ini
echo  -e  "[ShareMem]" >> ShareMemInfo.ini
echo  -e  "KeyCount=11" >> ShareMemInfo.ini
echo  -e  "Key0=1001" >> ShareMemInfo.ini
echo  -e  "Type0=1     ;HumanSMU" >> ShareMemInfo.ini
echo  -e  "Key1=2001" >> ShareMemInfo.ini
echo  -e  "Type1=2     ;GuildSMU" >> ShareMemInfo.ini
echo  -e  "Key2=3001" >> ShareMemInfo.ini
echo  -e  "Type2=3     ;MailSMU" >> ShareMemInfo.ini
echo  -e  "Key3=4001" >> ShareMemInfo.ini
echo  -e  "Type3=4     ;PlayerShopSM" >> ShareMemInfo.ini
echo  -e  "Key4=5001" >> ShareMemInfo.ini
echo  -e  "Type4=5     ;GlobalDataSMU" >> ShareMemInfo.ini
echo  -e  "Key5=6001" >> ShareMemInfo.ini
echo  -e  "Type5=6     ;CommisionShopSMU" >> ShareMemInfo.ini
echo  -e  "Key6=7001" >> ShareMemInfo.ini
echo  -e  "Type6=7     ;ItemSerialKeySMU" >> ShareMemInfo.ini
echo  -e  "Key7=8001" >> ShareMemInfo.ini
echo  -e  "Type7=8     ;PetProcreateItemSM" >> ShareMemInfo.ini
echo  -e  "Key8=9001" >> ShareMemInfo.ini
echo  -e  "Type8=9     ;CitySMU" >> ShareMemInfo.ini
echo  -e  "Key9=10001" >> ShareMemInfo.ini
echo  -e  "Type9=10    ;GuildLeagueSMU" >> ShareMemInfo.ini
echo  -e  "Key10=11001" >> ShareMemInfo.ini
echo  -e  "Type10=11   ;FindFriendADSMU" >> ShareMemInfo.ini


echo -e "[System]	" > LoginInfo.ini
echo -e "LoginID=2	" >> LoginInfo.ini
echo -e "DBIP=gsmysql" >> LoginInfo.ini
echo -e "DBPort=3306	" >> LoginInfo.ini
echo -e "DBName=tlbbdb	" >> LoginInfo.ini
echo -e "DBUser=root	" >> LoginInfo.ini
echo -e "DBPassword=sinall0" >> LoginInfo.ini
echo -e "ClientVersion=1005	" >> LoginInfo.ini
echo -e "DBConnectCount=10	" >> LoginInfo.ini
echo -e "TurnPlayerCount=100	" >> LoginInfo.ini
echo -e "CryptPwd=0	" >> LoginInfo.ini
echo -e "ProxyConnect=1	" >> LoginInfo.ini

echo -e "[System]" > ServerInfo.ini
echo -e "Desc0=功能：配置服务器端程序的相关情况；" >> ServerInfo.ini
echo -e "Desc1=IP0、Port0指外网的地址和端口；" >> ServerInfo.ini
echo -e "Desc2=IP1、Port1指内网的地址和端口；" >> ServerInfo.ini
echo -e "Desc3=Type：Game=0；Login=1；" >> ServerInfo.ini
echo -e "" >> ServerInfo.ini
echo -e "CurrentServerID=0" >> ServerInfo.ini
echo -e "ServerNumber=2" >> ServerInfo.ini
echo -e "" >> ServerInfo.ini
echo -e "EnableEffAudit=0" >> ServerInfo.ini
echo -e "EffAuditSaveResultInterval=0" >> ServerInfo.ini
echo -e "EffAuditReportInterval=0" >> ServerInfo.ini
echo -e "" >> ServerInfo.ini
echo -e "EnableEffAuditSceneID_1ST=0" >> ServerInfo.ini
echo -e "EnableEffAuditSceneID_2ND=0" >> ServerInfo.ini
echo -e "EnableEffAuditSceneID_3RD=0" >> ServerInfo.ini
echo -e "EnableEffAuditSceneID_3RD=0" >> ServerInfo.ini
echo -e "" >> ServerInfo.ini
echo -e "[Mother]" >> ServerInfo.ini
echo -e "IP=0.0.0.0" >> ServerInfo.ini
echo -e "Port=0" >> ServerInfo.ini
echo -e "" >> ServerInfo.ini
echo -e "[World]" >> ServerInfo.ini
echo -e "IP=127.0.0.1" >> ServerInfo.ini
echo -e "Port=777" >> ServerInfo.ini
echo -e "" >> ServerInfo.ini
echo -e "[Billing]" >> ServerInfo.ini
echo -e "Number=1" >> ServerInfo.ini
echo -e "IP0=127.0.0.1" >> ServerInfo.ini
echo -e "Port0=31818" >> ServerInfo.ini
echo -e "IP1=0.0.0.0" >> ServerInfo.ini
echo -e "Port1=10101" >> ServerInfo.ini
echo -e "IP2=0.0.0.0" >> ServerInfo.ini
echo -e "Port2=10101" >> ServerInfo.ini
echo -e "IP3=0.0.0.0" >> ServerInfo.ini
echo -e "Port3=10101" >> ServerInfo.ini
echo -e "IP4=0.0.0.0" >> ServerInfo.ini
echo -e "Port4=10101" >> ServerInfo.ini
echo -e "" >> ServerInfo.ini
echo -e "[Proxy]" >> ServerInfo.ini
echo -e "Proxy0ForCncUser= 0.0.0.0" >> ServerInfo.ini
echo -e ";Proxy1ForCncUser=0.0.0.0" >> ServerInfo.ini
echo -e "Proxy0ForCtcUser=0.0.0.0" >> ServerInfo.ini
echo -e ";Proxy1ForCtcUser=0.0.0.0" >> ServerInfo.ini
echo -e "Proxy0ForEduUser= 0.0.0.0" >> ServerInfo.ini
echo -e ";Proxy1ForEduUser=0.0.0.0" >> ServerInfo.ini
echo -e "" >> ServerInfo.ini
echo -e "[Server0]" >> ServerInfo.ini
echo -e "ServerID=0" >> ServerInfo.ini
echo -e "MachineID=0" >> ServerInfo.ini
echo -e "IP0=127.0.0.1" >> ServerInfo.ini
echo -e "Port0=25680" >> ServerInfo.ini
echo -e "IP1=127.0.0.1" >> ServerInfo.ini
echo -e "Port1=8880" >> ServerInfo.ini
echo -e "Type=0" >> ServerInfo.ini
echo -e "IP(CNC)= 0.0.0.0" >> ServerInfo.ini
echo -e "Port(CNC)=1000" >> ServerInfo.ini
echo -e "IP(CTC)=0.0.0.0" >> ServerInfo.ini
echo -e "Port(CTC)=0" >> ServerInfo.ini
echo -e "IP(EDU)= 0.0.0.0" >> ServerInfo.ini
echo -e "Port(EDU)=1000" >> ServerInfo.ini
echo -e "HumanSMKey=1001" >> ServerInfo.ini
echo -e "PlayShopSMKey=4001" >> ServerInfo.ini
echo -e "ItemSerialKey=7001" >> ServerInfo.ini
echo -e "CommisionShopKey=6001" >> ServerInfo.ini
echo -e "EnableShareMem=1" >> ServerInfo.ini
echo -e "" >> ServerInfo.ini
echo -e "[Server1]" >> ServerInfo.ini
echo -e "ServerID=2" >> ServerInfo.ini
echo -e "MachineID=0" >> ServerInfo.ini
echo -e "IP0=127.0.0.1" >> ServerInfo.ini
echo -e "Port0=23580" >> ServerInfo.ini
echo -e "IP1=127.0.0.1" >> ServerInfo.ini
echo -e "Port1=8882" >> ServerInfo.ini
echo -e "Type=1" >> ServerInfo.ini
echo -e "IP(CNC)= 0.0.0.0" >> ServerInfo.ini
echo -e "Port(CNC)=1000" >> ServerInfo.ini
echo -e "IP(CTC)=0.0.0.0" >> ServerInfo.ini
echo -e "Port(CTC)=0" >> ServerInfo.ini
echo -e "IP(EDU)= 0.0.0.0" >> ServerInfo.ini
echo -e "Port(EDU)=1000" >> ServerInfo.ini
echo -e "HumanSMKey=1003" >> ServerInfo.ini
echo -e "PlayShopSMKey=4003" >> ServerInfo.ini
echo -e "ItemSerialKey=7003" >> ServerInfo.ini
echo -e "CommisionShopKey=6003" >> ServerInfo.ini
echo -e "EnableShareMem=0" >> ServerInfo.ini