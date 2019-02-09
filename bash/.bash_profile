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
    . $(brew --prefix)/etc/bash_completion
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

# import kubectl completion bash
source <(kubectl completion bash)


# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# alias
alias ls='ls -GFhl'
alias ll='ls -GFhla'
alias kc='$(which kubectl) $@'

# vi style
set -o vi

# history ignore
export HISTIGNORE="pwd:ls:cd"
