# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# vte

vte_path=`nix-env -q --out-path vte | sed -e "s/^vte[^ ]*\s*//"`
if [ $? -eq 0 ]; then
  source $vte_path'/etc/profile.d/vte.sh'
else
  echo 'please install vte: nix-env -i vte'
fi

eval `keychain --eval --quiet --agents ssh id_rsa id_rsa_new`

# local alias
export DEFAULT_ALIASES=`alias`
PROMPT_COMMAND="unalias -a; eval \"\$DEFAULT_ALIASES\"; if [[ -e .aliases ]]; then source .aliases; fi;$PROMPT_COMMAND"

# reproduce actual exit status
PROMPT_COMMAND="LAST_EXIT=\$?; function last_exit () {
  local status=\$LAST_EXIT
  LAST_EXIT=
  unset -f last_exit
  return \$status
};$PROMPT_COMMAND;last_exit"

source ~/.bash/.bash-powerline.sh

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gti=git

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ruby stuff

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export DISABLE_SPRING=true

# aliases
alias bundleretry='until bundle; do echo "RETRY!"; done'
alias be='bundle exec'
alias rr='make -f <(echo -e "show: tmp/make_routes\n\tless tmp/make_routes\n\ntmp/make_routes: config/routes.rb\n\t bundle exec rake routes 2>/dev/null > tmp/make_routes")'
