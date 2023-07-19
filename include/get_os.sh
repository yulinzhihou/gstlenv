#!/bin/bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2023-07-19
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+

# 获取发行版本和版本ID
get_distribution() {
  LSB_DIST=""
  LSB_DIST_VERSION=""
  if [ -r /etc/os-release ]; then
    local TEMP="$(. /etc/os-release && echo "$NAME")"
    TEMP=(${TEMP})
    LSB_DIST="${TEMP[0]}"
    LSB_DIST_VERSION="$(. /etc/os-release && echo "$VERSION_ID")"
  fi
  local ID_VERSION_ID=(${LSB_DIST} ${LSB_DIST_VERSION})
  echo "${ID_VERSION_ID[@]}"
}

# 获取当前系统软件包管理工具
get_package_manager() {
  local PM=''
  if [ -e "/usr/bin/dnf" ]; then
    PM=dnf
  elif [ -e "/usr/bin/apt-get" ]; then
    PM=apt-get
  elif [ -e "/usr/bin/yum" ]; then
    PM=yum
  fi
  echo "${PM}"
}

# 获取包管理工具名称
PM=$(get_package_manager)
# 通过 os-release 获取发行版本及ID,通过数组返回数据。[0]为发生版本，[1]为版本号
OS_VERSIONS=($(get_distribution))
OS=${OS_VERSIONS[0]}
OS_VERSION=${OS_VERSIONS[1]}
