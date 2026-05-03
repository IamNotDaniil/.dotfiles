#!/usr/bin/env bash
set -euo pipefail

detect_os() {
    if [[ "${OSTYPE:-}" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version 2>/dev/null; then
            echo "wsl"
        elif grep -qi "ubuntu\|debian" /etc/os-release 2>/dev/null; then
            echo "ubuntu"
        elif grep -qi "arch" /etc/os-release 2>/dev/null; then
            echo "arch"
        else
            echo "linux"
        fi
    elif [[ "${OSTYPE:-}" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}
