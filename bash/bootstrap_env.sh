#!/bin/bash

# exits with non-zero code
set -e

echo "** prerequisite for custom env **"

base=$(dirname $0)
mygitrepo='MY-GIT-REPO'
python_version='3.6.3'
project_id='' # OPENSTACK project ID
project_name='' # OPENSTACK project Name
os=$(uname -s)
osid=$(cat /etc/*-release | uniq | grep "^ID=" | cut -d'=' -f2 | tr -d '\"')

# select the package manager
if [ ${os} == "Linux" ]; then 
   
elif [ ${os} == "Darwin" ]; then 
  pkmg=$(which brew)
else
  echo "Oops! I cannot recognize your system package, Sorry"
fi

# clone a forked repo
echo "cloning ${mygitrepo}"
[ ! -d ${base}/$(echo ${mygitrepo##*/} | cut -d"." -f1) ] && git clone ${mygitrepo}

# install pkg
[ ! $(which ansible) ] && sudo yum install -y ansible python-pip


# install pyenv
[ ! $(which pyenv) ] && curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

# put into bash settings
if [ $(cat ~/.bash_profile | grep pyenv | wc -l) -eq 0 ]; then
cat <<EOF >> ~/.bash_profile
# This is a Pyenv settings
export PATH="\$HOME/.pyenv/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF
fi

# install virtualenv
if [ $(pyenv versions | grep "${python_version}" | wc -l) -eq 0 ]; then
  pyenv install ${python_version}
fi

# activate
if [ $(pyenv virtualenvs | grep nucleo-env | wc -l) -eq 0 ]; then
  pyenv virtualenv ${python_version} dev-python-3
fi

#pyenv activate nucleo-env

# install openstack pkg
[ ! $(which openstack) ] && sudo pip install python-openstackclient python-designateclient

if [ ! -f ${base}/openrc ]; then
  cat <<EOF >> ${base}/openrc
#!/bin/bash
export OS_PROJECT_DOMAIN_NAME=${project_name}
export OS_USER_DOMAIN_NAME="default"
export OS_PROJECT_NAME=${project_name}
export OS_PROJECT_ID=${project_id}
export OS_USERNAME=""
export OS_AUTH_URL=
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=\$OS_PASSWORD_INPUT
EOF
fi

echo "** prerequisite done**"
echo "You should run follow cmd"
echo "pyenv activate dev-python-3"
echo "source ${base}/openrc"
echo "source ~/.bash_profile"
