# common aliases
alias cat="bat"
alias ls="lsd --almost-all --group-directories-first"
alias vi="nvim"
alias vim="nvim"
alias ..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# git
alias gc="git add .; git commit -m"

# rails
alias setup="./bin/setup"

# GitLab
alias gitlabstg="tsh ssh rails-ro@console-ro-01-sv-gstg"
alias cdotstg="tsh ssh cdot-rails@customers-01-inf-stgsub"

# overmind
alias server="op run --env-file='.env' -- overmind start -f Procfile &"
alias ok="overmind kill"
alias ok!="rm ./.overmind.sock"

# navigation
alias cdot="cd ~/Documents/work/cdot/primary"
alias gitlab="cd ~/gdk/gitlab"
alias ggdk="cd ~/gdk"
alias handbook="cd ~/Documents/work/handbook"
alias omnibus="cd ~/Documents/work/omnibus-gitlab/"
alias gitlabcom="cd ~/Documents/work/www-gitlab-com/"
alias zsim="cd ~/Documents/work/zsim/"
alias zdot="cd ~/Documents/work/zdot/"

alias lg="lazygit"
