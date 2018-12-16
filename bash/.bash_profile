# Highlight man page 
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}

# for __git_ps1
if [ -d $(brew --prefix)/etc/bash_completion.d ]; then
    source $(brew --prefix)/etc/bash_completion.d/git-completion.bash
    source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
fi

# -ANSI-COLOR-CODES- #
Color_Off="\033[0m"
###-Regular-###
Red="\033[0;31m"
Green="\033[0;32m"
Yellow="\033[0;33m"
####-Bold-####

# prompt
#export PS1="\u@\h:\W$ "
function __stat() {
    local fail=$?
    if [ $fail -eq 0 ]; then
        echo -en "$Green ✔$Color_Off "
    else
        echo -en "$Red ✘-$fail$Color_Off "
    fi
}
PS1='$(__stat)'

# import kubectl completion bash
source <(kubectl completion bash)

# function for k8s
ks() {
  context=$(kubectl config view -o go-template='{{range .contexts}}{{- printf "%s\n" .name -}}{{end}}' | fzf -x -m -e +s --reverse --bind=left:page-up,right:page-down --no-mouse)
  kubectl config use-context $context
}

kps() {
  kubectl get pod --all-namespaces | fzf -x -m -e +s --reverse --bind=left:page-up,right:page-down --no-mouse
}

klog() {
  kubectl logs $2 -n $1 -f
}

function __kubernetes() {
  echo -en "$(kubectl config current-context)"
}

GIT_PS1_SHOWDIRTYSTATE=true
if [[ "${OUT}" == "" ]]; then
  PS1='$(__stat):\[\033[01;34m\]\w\[\033[00m\]\[\033[01;35m\]$(__git_ps1)\[\033[00m\] \[\033[01;36m\]$(__os_auth_url)\[\033[00m\] \[\033[01;33m\]$(__kubernetes)\[\033[00m\]
\$ '
else
  PS1='$(__stat):\[\033[01;34m\]\w\[\033[00m\]\[\033[01;35m\]$(__git_ps1)\[\033[00m\]
\$ '
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

set -o vi

# alias
alias ls='ls -GFhl'
alias ll='ls -GFhla'
alias kc='$(which kubectl) $@'

# vi style
set -o vi
