#!/bin/bash
# Claude Code 完了通知スクリプト
# 複数プロジェクト共通グローバルハンドラ (~/.claude/notify.sh)
#
# 対応環境: iTerm2, VS Code (macOS)
# 依存: terminal-notifier (brew install terminal-notifier)
#
# インストール: make install

set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Log the notification
log_file="$HOME/.claude/notifications.log"
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
mkdir -p "$(dirname "$log_file")"
echo "[$timestamp] $input" >> "$log_file"

# Parse notification type
notification_type=$(echo "$input" | grep -o '"notification_type"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4 || echo "unknown")

case "$notification_type" in
  "stop")
    cwd=$(echo "$input" | grep -o '"cwd"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4 || echo "unknown")
    echo "[$timestamp] Stop notification from: $cwd" >> "$log_file"
    # macOS通知バナー＋音（iTerm・VS Code共通）
    terminal-notifier -title "Claude Code" -message "作業完了しました" -sound Glass &
    ;;
  *)
    echo "[$timestamp] Generic notification: $notification_type" >> "$log_file"
    ;;
esac

# Claude Code hook準拠
echo '{}'
exit 0
