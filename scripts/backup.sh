#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${HOME}/.dotfiles.backup"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
MAX_BACKUPS=3
TARGET_DIR="${BACKUP_DIR}/${TIMESTAMP}"

mkdir -p "${TARGET_DIR}"

backup_paths=(
    "${HOME}/.config/nvim"
    "${HOME}/.tmux.conf"
    "${HOME}/.zshrc"
    "${HOME}/.aliases"
    "${HOME}/.exports"
    "${HOME}/.gitconfig"
    "${HOME}/.gitignore_global"
)

for path in "${backup_paths[@]}"; do
    if [[ -e "${path}" ]]; then
        cp -a "${path}" "${TARGET_DIR}/"
    fi
done

mapfile -t backups < <(find "${BACKUP_DIR}" -mindepth 1 -maxdepth 1 -type d | sort -r)
if (( ${#backups[@]} > MAX_BACKUPS )); then
    for old in "${backups[@]:MAX_BACKUPS}"; do
        rm -rf "${old}"
    done
fi

echo "Backup created: ${TARGET_DIR}"
