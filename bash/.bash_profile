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

# bash completion ```brew install bash-completion```
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi

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

# for kubernetes
ks() {
  context=$(kubectl config view -o go-template='{{range .contexts}}{{- printf "%s\n" .name -}}{{end}}' | fzf -x -m -e +s --reverse --bind=left:page-up,right:page-down --no-mouse)
  kubectl config use-context $context
}

# history ignore
export HISTCONTROL=ignoredups:erasedups
export HISTIGNORE="pwd:ls:cd"
export HISTSIZE=100000
export HISTFILESIZE=100000
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# fzf
# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.bash"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# alias
alias ls='ls -GFhl'
alias ll='ls -GFhla'
alias k='$(which kubectl) $@'
alias klog='$(which stern) $@'
alias g='git'
alias tg='tig'
alias cssh='tmux-cssh -c $@'

# import kubectl completion bash
source <(kubectl completion bash)
complete -o bashdefault -o default -o dirnames -F __start_kubectl k

# vi style
set -o vi

# to using bash5.0
export SHELL=/usr/local/bin/bash
