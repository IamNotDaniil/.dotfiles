#!/usr/bin/env bash
set -euo pipefail

required=(git curl make zsh tmux nvim)
missing=0

for cmd in "${required[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        printf 'OK   %s\n' "$cmd"
    else
        printf 'MISS %s\n' "$cmd"
        missing=1
    fi
done

if (( missing )); then
    echo 'Some tools are missing.'
    exit 1
fi

echo 'Environment looks good ✅'
