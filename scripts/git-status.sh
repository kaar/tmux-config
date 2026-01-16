#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Output git-status for a given path. To be used in combination with tmux
#
# (<repo name>) branch status
#
# tmux example:
#   set -g status-right '#[fg=yellow]#(./git-status.sh "#{pane_current_path}")'
#   $1 - path
#
# Output:
# '(<repo name>) branch status'
#
# Status indicators:
# *           - uncommited changes
# +           - staged changes
# ?           - untracked files
# ↑${ahead}   - number of commits ahead of remote
# ↓${behind}" - number of commits behind remote
#
# TODO:
# - Add repository name, either only the name or the full remote github path?
# - Add `--help` printing the status indicator info and some example output
# - Not sure if uncommited changes works
# - Show when in a git worktree by adding either a icon or name of base repo

# Get the current working directory from tmux
# When called from tmux status line, we need to get the pane's current path
if [ -n "$1" ]; then
  cd "$1" 2>/dev/null || exit 0
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo ""
  exit 0
fi

# Get the current branch name
branch=$(
  git symbolic-ref --short HEAD 2>/dev/null ||
    git describe --tags --exact-match 2>/dev/null ||
    git rev-parse --short HEAD 2>/dev/null
)

# Get git status indicators
status=""

# Check for uncommitted changes (modified files)
if [ -n "$(git status --porcelain 2>/dev/null | grep '^ M')" ]; then
  status="${status}*"
fi

# Check for staged changes
if [ -n "$(git status --porcelain 2>/dev/null | grep '^[MADRC]')" ]; then
  status="${status}+"
fi

# Check for untracked files
if [ -n "$(git status --porcelain 2>/dev/null | grep '^??')" ]; then
  status="${status}?"
fi

# Check if we're ahead of remote
ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
if [ "$ahead" -gt 0 ]; then
  status="${status}↑${ahead}"
fi

# Check if we're behind remote
behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
if [ "$behind" -gt 0 ]; then
  status="${status}↓${behind}"
fi

# Output with branch icon
if [ -n "$status" ]; then
  echo "${branch} ${status}"
else
  echo "${branch}"
fi
