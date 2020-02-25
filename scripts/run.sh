#!/bin/bash

# check os
# if os is Darwin - install brew
# else os is Linux
#  check distribute
#  if distribution id is ubuntu - apt update
#  else distribution id centos - yum update
#
# install package : git, tig, tmux, bash-completion pyenv tmux-cssh, kubectl, kubectx, kubens
# copy .tmux.conf, .bash_profile
# add alias
# addons - proxy, etc..

OS=x$(lsb_release -i | cut -d":" -f2 | tr -d "\t" | tr '[:upper:]' '[:lower:]')

if [[ ${OS} == 'xubuntu' ]]; then
  pkgmgr='apt-get'
  run='install'
  opt='--no-install-recommends -y'
else if [[ ${OS} == 'xcentos' ]]; then
  pkgmgr='yum'
  run='install'
  opt=''
else
  echo "${OS} is not supported"
fi

pkgs='ca-certificates git make jq nmap curl curl uuid-runtime br'

sudo ${pkgmgr} update
sudo ${pkgmgr} install ${opt} ${pkgs}

