#
# Applications Config
#

eval "$(zoxide init zsh --cmd o)"
eval $(opam env)

#
# User Config
#

alias nvim="~/app/nvim/bin/nvim"
alias bat="batcat"
alias loc="scc --no-hborder"
alias lg="~/app/lazygit/lazygit"
alias yt="~/app/yt/yt"
alias zj="zellij --layout compact"

alias src="source ~/.zshrc"
alias erc="nvim ~/.zshrc"
alias get="sudo apt install"
alias del="sudo apt remove"
alias red="redshift -x && redshift -O 3400 -b 0.8"
alias off="shutdown"
alias ice="shutdown -h now"

# alias no="~/work/code/no/nox/_build/default/bin/main.exe"
# alias no="~/work/code/no/nox/zig-out/bin/no"
# alias no="~/work/code/no/nox/build/no"
alias no="~/work/code/no/nox/no"

alias b="cd build"
alias e="nvim"
alias w="emacs -nw"
alias v="clear"
alias c="cat"
alias u="cd .."
alias uu="cd ../.."
alias m="make"
alias mc="make clean"
alias p="clear && make pretty"
alias f="make && clear && make run"
alias t="make && clear && make test"
alias g="make && clear && make bench"
alias y="yazi"

alias gs="git status"

alias todo="less ~/work/todo.txt"
alias etodo="nvim ~/work/todo.txt"

xssh() {
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/oxcrow
}

xperf() {
    sudo sysctl -w kernel.perf_event_paranoid=1
    sudo sysctl -w kernel.kptr_restrict=0
}

unalias gg
gg() {
    dir=$(cat .ignore.git-add.txt)
    git add $dir
    git commit -m "x"
}

ff() {
    dir=$(cat .ignore.git-add.txt)
    git add $dir
}
