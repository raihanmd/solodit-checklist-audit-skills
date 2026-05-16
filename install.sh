#!/usr/bin/env bash
#
# Solodit Checklist Audit Skills - Installer
# Auto-detects AI platforms and installs the skill.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/raihanmd/solodit-checklist-audit-skills/main/install.sh | bash
#
set -euo pipefail

REPO_URL="https://github.com/raihanmd/solodit-checklist-audit-skills.git"
INSTALL_DIR="$HOME/.solodit-checklist-audit"
SKILL_SOURCE="$INSTALL_DIR"
INSTALLED=false

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[solodit-checklist-audit]${NC} $1"; }
warn()    { echo -e "${YELLOW}[solodit-checklist-audit]${NC} $1"; }
error()   { echo -e "${RED}[solodit-checklist-audit]${NC} $1"; }

if [ -d "$INSTALL_DIR/.git" ]; then
    info "Updating existing installation..."
    cd "$INSTALL_DIR" && git pull
else
    info "Cloning solodit-checklist-audit-skills..."
    git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
fi

detect_platforms() {
    local platforms=()

    [ -d "$HOME/.claude" ] || command -v claude &>/dev/null && platforms+=("claude-code")
    [ -d "$HOME/.config/opencode" ] || command -v opencode &>/dev/null && platforms+=("opencode")
    [ -d "$HOME/.cursor" ] || command -v cursor &>/dev/null && platforms+=("cursor")
    [ -d "$HOME/.codex" ] || command -v codex &>/dev/null && platforms+=("codex")
    [ -d "$HOME/.codeium/windsurf" ] || command -v windsurf &>/dev/null && platforms+=("windsurf")

    echo "${platforms[@]}"
}

install_skill() {
    local platform="$1"
    local target_dir=""

    case "$platform" in
        claude-code)    target_dir="$HOME/.claude/skills/solodit-checklist-audit" ;;
        opencode)       target_dir="$HOME/.config/opencode/skills/solodit-checklist-audit" ;;
        cursor)         target_dir="$HOME/.cursor/skills/solodit-checklist-audit" ;;
        codex)          target_dir="$HOME/.codex/skills/solodit-checklist-audit" ;;
        windsurf)       target_dir="$HOME/.codeium/windsurf/skills/solodit-checklist-audit" ;;
    esac

    if [ -n "$target_dir" ]; then
        mkdir -p "$target_dir"
        cp -r "$SKILL_SOURCE"/{SKILL.md,VERSION,references} "$target_dir/"
        info "Installed to $target_dir"
        INSTALLED=true
    fi
}

PLATFORMS=$(detect_platforms)

if [ -z "$PLATFORMS" ]; then
    warn "No AI platforms detected. Installing to all supported platforms..."
    for p in claude-code opencode cursor codex windsurf; do
        install_skill "$p"
    done
else
    for platform in $PLATFORMS; do
        install_skill "$platform"
    done
fi

if [ "$INSTALLED" = true ]; then
    echo ""
    info "Installation complete!"
    echo ""
    info "Usage:"
    echo "  Open your AI assistant in a Solidity project and run:"
    echo "    solodit audit on the codebase"
    echo ""
else
    error "No platforms could be installed to."
    echo ""
    warn "Manual installation:"
    echo "  1. Clone: git clone $REPO_URL $INSTALL_DIR"
    echo "  2. Copy to your agent's skills directory:"
    echo "     Claude Code: ~/.claude/skills/solodit-checklist-audit/"
    echo "     OpenCode:    ~/.config/opencode/skills/solodit-checklist-audit/"
    echo "     Cursor:      ~/.cursor/skills/solodit-checklist-audit/"
    echo "     Codex CLI:   ~/.codex/skills/solodit-checklist-audit/"
    echo "     Windsurf:    ~/.codeium/windsurf/skills/solodit-checklist-audit/"
    echo ""
fi
