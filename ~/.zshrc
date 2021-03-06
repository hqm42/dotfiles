# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/robert/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias bundleretry='until bundle; do echo "RETRY!"; done'
alias be='bundle exec'
alias rr='make -f <(echo -e "show: tmp/make_routes\n\tless tmp/make_routes\n\ntmp/make_routes: config/routes.rb\n\t bundle exec rake routes 2>/dev/null > tmp/make_routes")'
alias enc='sudo vim /etc/nixos/configuration.nix'
alias today='date --iso-8601'

#avocadostore aliases
alias bers='nix-shell ruby.nix --run "bundle exec puma -p 3000"'
alias berc='nix-shell ruby.nix --run "bundle exec rails c"'
alias bercs='nix-shell ruby.nix --run "bundle exec rails c --sandbox"'
alias bes='nix-shell ruby.nix --run "bundle exec sidekiq"'
alias bess='nix-shell ruby.nix --run "bundle exec sidekiq -C config/sidekiq_slow_job.yml"'

# vte

vte_path=`nix-env -q --out-path vte | sed -e "s/^vte[^ ]*\s*//"`
if [ $? -eq 0 ]; then
  source $vte_path'/etc/profile.d/vte.sh'
else
  echo 'please install vte: nix-env -i vte'
fi

eval `keychain --eval --quiet --agents ssh id_rsa id_rsa_new`

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export DISABLE_SPRING=true
