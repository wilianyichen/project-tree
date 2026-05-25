#!/usr/bin/env bash
# project-tree — one-command installer
# Usage: ./install.sh [--prefix ~/.local]

set -euo pipefail

PREFIX="${PREFIX:-$HOME}"
BIN_DIR="$PREFIX/bin"
CONFIG_DIR="$PREFIX/.config/project-tree"
CACHE_DIR="$PREFIX/.cache"
SKILL_DIR="$PREFIX/.claude/skills/project-tree"
PKG_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== project-tree installer ==="
echo "  Prefix:  $PREFIX"

# 1. Create directories
mkdir -p "$BIN_DIR" "$CONFIG_DIR" "$CACHE_DIR" "$SKILL_DIR"

# 2. Link CLI
ln -sf "$PKG_DIR/bin/project-tree" "$BIN_DIR/project-tree"
echo "  CLI  → $BIN_DIR/project-tree"

# 3. Copy configs (never overwrite existing user configs)
for f in themes.json descriptions.json corrections.json; do
    if [ ! -f "$CONFIG_DIR/$f" ]; then
        cp "$PKG_DIR/share/$f" "$CONFIG_DIR/$f"
        echo "  Config → $CONFIG_DIR/$f"
    else
        echo "  Config → $CONFIG_DIR/$f (exists, skipped)"
    fi
done

# 4. Copy skill
cp "$PKG_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "  Skill → $SKILL_DIR/SKILL.md"

# 5. Add pt() shell function if not present
if [ -f "$HOME/.bashrc" ] && ! grep -q "pt()" "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" << 'SHELLFN'

# project-tree TUI with cd-on-exit (press e on a directory)
pt() {
    project-tree "$@"
    local last_cd="$HOME/.cache/project-tree-last-cd"
    if [ -f "$last_cd" ]; then
        local dir
        dir="$(cat "$last_cd")"
        rm -f "$last_cd"
        cd "$dir" || return
    fi
}
SHELLFN
    echo "  Shell  → pt() added to ~/.bashrc"
fi

# 6. Run first scan
echo ""
echo "--- Running first scan ---"
"$BIN_DIR/project-tree" update --no-size 2>&1 | tail -3

echo ""
echo "=== Done ==="
echo "  project-tree       — launch TUI"
echo "  pt                 — TUI + auto-cd"
echo "  project-tree -h    — all commands"
echo ""
echo "For Claude Code: the skill is auto-discovered from ~/.claude/skills/project-tree/"
