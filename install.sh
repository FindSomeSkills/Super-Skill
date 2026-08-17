#!/usr/bin/env bash
# Install super-skill into a skills directory.
#
# Usage:
#   bash install.sh                    # installs into ~/.claude/skills
#   bash install.sh ~/.dsh/skills      # installs into a custom skills dir
#   bash install.sh "$env:USERPROFILE\.claude\skills"   # Windows (PowerShell)
#
# The script only downloads and copies files. It runs no code from the
# repository and requires no root. Review it before running if you prefer.
set -euo pipefail

SRC_REPO="https://github.com/FindSomeSkills/Super-Skill"
DEFAULT_TARGET="$HOME/.claude/skills"
TARGET="${1:-$DEFAULT_TARGET}"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Downloading super-skill from $SRC_REPO ..."
if command -v git >/dev/null 2>&1; then
  git clone --depth 1 -q "$SRC_REPO" "$TMP/repo"
else
  curl -fsSL "$SRC_REPO/archive/refs/heads/main.tar.gz" -o "$TMP/dl.tar.gz"
  mkdir -p "$TMP/repo"
  tar -xzf "$TMP/dl.tar.gz" -C "$TMP/repo" --strip-components=1
fi

mkdir -p "$TARGET"
rm -rf "$TARGET/super-skill"
cp -R "$TMP/repo/super-skill" "$TARGET/super-skill"
echo "Installed to $TARGET/super-skill"
echo "Restart your agent session so it picks up the new skill."
