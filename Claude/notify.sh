#!/bin/bash
# Claude Code 完了通知ラッパー
# notify.py に処理を委譲する

set -euo pipefail

# stdin を notify.py に渡す
cat | python3 ~/.claude/notify.py

# Claude Code hook 準拠
echo '{}'
exit 0
