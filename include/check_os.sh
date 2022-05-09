if [ -e "/usr/bin/yum" ]; then
  PM=yum
  if [ -e /etc/yum.repos.d/CentOS-Base.repo ] && grep -Eqi "release 6." /etc/redhat-release; then
    sed -i "s@centos/\$releasever@centos-vault/6.10@g" /etc/yum.repos.d/CentOS-Base.repo
    sed -i 's@centos/RPM-GPG@centos-vault/RPM-GPG@g' /etc/yum.repos.d/CentOS-Base.repo
    [ -e /etc/yum.repos.d/epel.repo ] && rm -f /etc/yum.repos.d/epel.repo
  fi

  if ! command -v lsb_release >/dev/null 2>&1; then
    if [ -e "/etc/euleros-release" ]; then
      yum -y install euleros-lsb
    elif [ -e "/etc/openEuler-release" -o -e "/etc/openeuler-release" ]; then
      if [ -n "$(grep -w '"20.03"' /etc/os-release)" ]; then
        rpm -Uvh https://repo.openeuler.org/openEuler-20.03-LTS-SP1/everything/aarch64/Packages/openeuler-lsb-5.0-1.oe1.aarch64.rpm
      else
        yum -y install openeuler-lsb
      fi
    elif [ -e "/etc/redhat-release" ]; then
      # 表示是centos Stream 9
      PM=dnf
      dnf -y update && sudo dnf upgrade --refresh -y &&
        sudo dnf config-manager --set-enabled crb

      sudo dnf install \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
        https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm

    else
      yum -y install redhat-lsb-core
    fi
    clear
  fi
fi

if [ -e "/usr/bin/apt-get" ]; then
  PM=apt-get
  command -v lsb_release >/dev/null 2>&1 || {
    apt-get -y update >/dev/null
    apt-get -y install lsb-release
    clear
  }
fi

if command -v lsb_release >/dev/null 2>&1; then
  # Get OS Version
  OS=$(lsb_release -is)
  if [[ "${OS}" =~ ^CentOS$|^RedHat$|^Rocky$|^Fedora$|^Amazon$|^Alibaba$|^Aliyun$|^EulerOS$|^openEuler$|^CentOSStream$ ]]; then
    CentOS_ver=$(lsb_release -rs | awk -F. '{print $1}' | awk '{print $1}')
    [[ "${OS}" =~ ^Fedora$ ]] && [ ${CentOS_ver} -ge 19 ] >/dev/null 2>&1 && {
      CentOS_ver=7
      Fedora_ver=$(lsb_release -rs)
    }
    [[ "${OS}" =~ ^Amazon$|^Alibaba$|^Aliyun$|^EulerOS$|^openEuler$ ]] && CentOS_ver=7
  elif [[ "${OS}" =~ ^Debian$|^Deepin$|^Uos$|^Kali$ ]]; then
    Debian_ver=$(lsb_release -rs | awk -F. '{print $1}' | awk '{print $1}')
    [[ "${OS}" =~ ^Deepin$|^Uos$ ]] && [[ "${Debian_ver}" =~ ^20$ ]] && Debian_ver=10
    [[ "${OS}" =~ ^Kali$ ]] && [[ "${Debian_ver}" =~ ^202 ]] && Debian_ver=10
  elif [[ "${OS}" =~ ^Ubuntu$|^LinuxMint$|^elementary$ ]]; then
    Ubuntu_ver=$(lsb_release -rs | awk -F. '{print $1}' | awk '{print $1}')
    if [[ "${OS}" =~ ^LinuxMint$ ]]; then
      [[ "${Ubuntu_ver}" =~ ^18$ ]] && Ubuntu_ver=16
      [[ "${Ubuntu_ver}" =~ ^19$ ]] && Ubuntu_ver=18
      [[ "${Ubuntu_ver}" =~ ^20$ ]] && Ubuntu_ver=20
    fi
    if [[ "${OS}" =~ ^elementary$ ]]; then
      [[ "${Ubuntu_ver}" =~ ^5$ ]] && Ubuntu_ver=18
      [[ "${Ubuntu_ver}" =~ ^6$ ]] && Ubuntu_ver=20
    fi
  fi

  # Check OS Version
  if [ ${CentOS_ver} -lt 6 ] >/dev/null 2>&1 || [ ${Debian_ver} -lt 8 ] >/dev/null 2>&1 || [ ${Ubuntu_ver} -lt 14 ] >/dev/null 2>&1; then
    echo "${CFAILURE}不支持此系统, 请安装 CentOS 7+,Debian 10+,Ubuntu 18+ ${CEND}"
    kill -9 $$
  fi
else
  # centos stream 9
  if [ -e "/etc/redhat-release" ]; then
    OS=$(cat /etc/redhat-release)
    if [ ${OS} == 'CentOS Stream release 9' ]; then
      CentOS_ver=9
      PM=dnf
    fi
  else
    echo "${CFAILURE}${PM} source failed! ${CEND}"
    kill -9 $$
  fi
fi
