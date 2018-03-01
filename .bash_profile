eval "$(rbenv init -)"

# Aliases
# various ls helpers
alias ls='ls -GF'
alias l.='ls -d .*'
alias ll='ls -lh'
alias l='ls -lh'
alias la='ls -alh'
alias lr='ls -lR'
alias c='clear'
# colorize greps
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
# make less a little more sane
alias less='less -RX'
# time helpers
alias epoch='date +%s'
alias dt='gdate "+%Y-%m-%dT%H:%M:%S.%3N%zZ"'

alias irb="irb --simple-prompt -rrbconfig"

# look up a process quickly
function pg {
    # doing it again afterwards for the coloration
    ps aux | grep -F -i $1 | grep -F -v grep | grep -F -i $1
}

# Check if a URL is up
function chk-url() {
    curl -sL -w "%{http_code} %{url_effective}\\n" "$1" -o /dev/null
}

# HTTP verbs
alias get='curl -s -XGET'
alias post='curl -s -XPOST'
alias put='curl -s -XPUT'
alias delete='curl -s -XDELETE'

# GIT aliases
alias gs='git status'
alias gcf='git commit --fixup='

# Enable git auto-completion
source ~/.git-completion.bash

# bash prompt
# if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
. ~/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export PS1='\[\e[32m\]\u@\h:\w\[\e[0m\]$(__git_ps1 " [%s]")\$ '

# Layout
export CLICOLOR=1

# enable bash 4 goodies
# shopt -s globstar autocd

# bind history completion to arrow keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# specify locale
# export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# emacs specifics
alias e='emacsclient -n'
alias ec='emacsclient -c -n'

export EDITOR='emacsclient -c'

# ruby/rails specifics
alias be='bundle exec'
alias rr="bundle exec rails runner $@"
alias bers="bundle exec foreman start"
alias rc="bundle exec rails console $@"
alias rs="bundle exec rails server --binding 0.0.0.0"

# Docker
alias dockelastic="docker run -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" docker.elastic.co/elasticsearch/elasticsearch:5.3.0"
# https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-dev-mode

# java specifics (os x)
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# Spark
export SPARK_HOME=/opt/apache-spark/spark-2.2.1-bin-hadoop2.7

export PATH=$PATH:$SPARK_HOME/

# add rbenv to path
export PATH="$HOME/.rbenv/bin:$PATH"

export PATH="/usr/local/opt/gnupg@1.4/libexec/gpgbin:$PATH"
