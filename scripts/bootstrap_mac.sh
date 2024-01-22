#!/bin/bash

# exits with non-zero code
# ref: https://gist.github.com/vncsna/64825d5609c146e80de8b1fd623011ca
set -e

ARCH=$(uname -s)

if [[ $ARCH != "Darwin" ]]; then
    # only mac os
    echo "Check your os arch : $ARCH"
    exit 1
fi

function install_kubeutil() {

    # install kubectl
    echo "install kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
    echo "verify a checksum"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | shasum -a 256 --check
    
    echo "copy binary"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    sudo chown root: /usr/local/bin/kubectl
    rm kubectl.sha256

    # install kubectl convert
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl-convert"
    chmod +x ./kubectl-convert
    sudo mv ./kubectl-convert /usr/local/bin/kubectl-convert
    sudo chown root: /usr/local/bin/kubectl-convert

    # install helm 
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

# install oh-my-zsh
if [ -z $(echo $ZSH) ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # zsh plugin
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# install homebrew
[ ! $(which brew) ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install pyenv
[ ! $(which pyenv) ] && brew install pyenv pyenv-virtualenv

# oh-my-zsh theme powerlevel10k
[ ! -f ~/.p10k.zsh ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# install utils
[ ! $(which fzf) ] && brew install fzf
[ ! $(which tmux) ] && brew install tmux 
[ ! $(which tmux-xpanes) ] && brew install tmux-xpanes

# install kubernetes utils
[ ! $(which kubectl) ] && install_kubeutil


echo "You should install golang through link below"
echo "https://go.dev/dl/"