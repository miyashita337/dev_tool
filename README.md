# dev_tool
Environment for using the terminal

## Claude/

Claude Code 関連ツール集。

### notify.sh - Claude Code 完了通知

iTerm2・VS Code 共通で Claude Code の実行完了を macOS 通知バナー＋音で知らせるスクリプト。

**依存**

```bash
brew install terminal-notifier
```

**インストール**

```bash
cd ~/dev_tool/Claude
make install   # ~/.claude/notify.sh にコピー
```

**テスト**

```bash
make test
```
