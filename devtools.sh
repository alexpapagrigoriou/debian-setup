#!/bin/bash

set -e

sudo apt update

sudo apt install -y build-essential fastfetch less feh man-db manpages \
    tree xclip git git-filter-repo zsh curl wget fonts-powerline ripgrep fd-find \
    bc procps coreutils gawk sed grep xss-lock dunst libnotify-bin \
    gcc clang make bear gdb valgrind \
    openjdk-21-jdk maven gradle \
    lua5.1 luarocks \
    python3 python3-pip python3-pynvim python3-venv \
    nodejs npm \
    tmux zip unzip

sudo apt remove -y neovim
bash nvim-update.sh
rm nvim-update.sh
sudo npm install -g neovim

sudo apt install -y pipewire wireplumber pavucontrol pamixer \
    vifm mpv cmus alacritty gimp zathura zathura-pdf-poppler \
    firefox-esr

sudo apt install -y gdisk exfatprogs
sudo mkdir -p /mnt/usb

mkdir -p "$HOME/Code"

rm -rf "$HOME/.oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    dest="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"
    rm -rf "$dest"
    git clone "https://github.com/zsh-users/$plugin" "$dest"
done

cat >"$HOME/.zshrc" <<'EOF'
# Oh My Zsh Setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Environment Variables
export PATH="/usr/sbin:/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"

# Aliases
alias c="clear"

alias vim="nvim"

alias jb="./gradlew build"
alias jc="./gradlew clean"
alias jcb="./gradlew clean build"

alias jbw="./gradlew build --warning-mode=all --rerun-tasks"
alias jcw="./gradlew clean --warning-mode=all --rerun-tasks"
alias jcbw="./gradlew clean build --warning-mode=all --rerun-tasks"

alias mp="./mvnw package"
alias mc="./mvnw clean"
alias mcp="./mvnw clean package"
alias mci="./mvnw clean install"

alias mpw="./mvnw package -X -e"
alias mcw="./mvnw clean -X -e"
alias mcpw="./mvnw clean package -X -e"
alias mciw="./mvnw clean install -X -e"

alias msbr="./mvnw spring-boot:run"

alias py="python3"

# Functions
u() {
    sudo apt update
    sudo apt -y upgrade
}

ja() {
    local dirs=("build/libs" "target" ".")

    local jar
    for dir in "${dirs[@]}"; do
        jar=($dir/*.jar(omN))
        if (( ${#jar[@]} )); then
            java -jar "${jar[1]}" "$@"
            return
        fi
    done

    echo "No JAR file found."
}

pdf() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: pdf <file.pdf>"
        return 1
    fi

    if [[ ! "$1" =~ \.pdf$ ]]; then
        echo "Not a pdf file."
        return 1
    fi

    (zathura "$1" &)
}

# Syntax Highlighting
source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
EOF

sudo chsh -s "$(which zsh)" "$USER"

mkdir -p "$HOME/.config/cmus"
cat >"$HOME/.config/cmus/rc" <<'EOF'
clear
add ~/Music/
EOF

cat >"$HOME/.clang-format" <<'EOF'
Language: C
BasedOnStyle: LLVM

IndentWidth: 4
TabWidth: 4
UseTab: Never

ColumnLimit: 0
EOF

cat >"$HOME/.gdbinit" <<'EOF'
set debuginfod enabled on
EOF

rm -rf "$HOME"/.local/share/nvim/lazy
mkdir -p "$HOME"/.local/share/nvim/lazy
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$HOME"/.local/share/nvim/lazy/lazy.nvim

rm -f "$HOME/.tmux.conf"
cat >"$HOME/.tmux.conf" <<'EOF'
set -ga terminal-overrides ",screen-256color*:Tc"
set-option -g default-terminal "screen-256color"
set -s escape-time 0

unbind C-b
set-option -g prefix C-s
bind-key C-s send-prefix
set -g status-style 'bg=#333333 fg=#5eacd3'

bind r source-file "$HOME/.tmux.conf"
set -g base-index 1

bind -r ^ last-window
bind -r k select-pane -U
bind -r j select-pane -D
bind -r h select-pane -L
bind -r l select-pane -R
EOF

rm -rf "$HOME/.tmux/plugins/tpm"
git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm
