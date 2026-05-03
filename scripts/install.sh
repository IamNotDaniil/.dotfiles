#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CLEAN_ONLY="${1:-}"

source "${DOTFILES_DIR}/scripts/detect-os.sh"

log() { printf '[dotfiles] %s\n' "$1"; }
warn() { printf '[dotfiles][warn] %s\n' "$1"; }

check_required() {
    local missing=0
    for cmd in git curl make; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            warn "Missing required dependency: $cmd"
            missing=1
        fi
    done
    if (( missing )); then
        exit 1
    fi
}

safe_link() {
    local src="$1" target="$2"
    mkdir -p "$(dirname "$target")"
    if [[ -L "$target" ]]; then
        rm -f "$target"
    elif [[ -e "$target" ]]; then
        log "Existing file detected at $target"
        read -r -p "Create backup before replacing? (y/N): " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            bash "${DOTFILES_DIR}/scripts/backup.sh"
            rm -rf "$target"
        else
            warn "Skipped $target"
            return
        fi
    fi
    ln -s "$src" "$target"
    log "Linked $target -> $src"
}

clean_link() {
    local target="$1"
    if [[ -L "$target" ]]; then
        rm -f "$target"
        log "Removed symlink: $target"
    fi
}

manage_links() {
    local mode="$1"
    local pairs=(
        "${DOTFILES_DIR}/configs/nvim|${HOME}/.config/nvim"
        "${DOTFILES_DIR}/configs/tmux/tmux.conf|${HOME}/.tmux.conf"
        "${DOTFILES_DIR}/configs/zsh/.zshrc|${HOME}/.zshrc"
        "${DOTFILES_DIR}/configs/zsh/.aliases|${HOME}/.aliases"
        "${DOTFILES_DIR}/configs/zsh/.exports|${HOME}/.exports"
        "${DOTFILES_DIR}/configs/git/.gitconfig|${HOME}/.gitconfig"
        "${DOTFILES_DIR}/configs/git/.gitignore_global|${HOME}/.gitignore_global"
    )

    for pair in "${pairs[@]}"; do
        local src="${pair%%|*}" target="${pair##*|}"
        if [[ "$mode" == "clean" ]]; then
            clean_link "$target"
        else
            safe_link "$src" "$target"
        fi
    done
}

install_plugins() {
    if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
    fi
    if command -v nvim >/dev/null 2>&1; then
        nvim --headless '+Lazy! sync' +qa || warn "Neovim plugin sync failed"
    fi
}

install_optional_tools() {
    local os
    os="$(detect_os)"
    local tools=(ripgrep fd fzf lazygit bat)
    for tool in "${tools[@]}"; do
        read -r -p "Install optional tool ${tool}? (y/N): " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            warn "Please install ${tool} manually for ${os}."
        fi
    done
}

if [[ "$CLEAN_ONLY" == "--clean" ]]; then
    manage_links clean
    exit 0
fi

check_required
manage_links install
install_plugins
install_optional_tools

echo "✅ Dotfiles installed successfully!"
