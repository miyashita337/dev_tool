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

---

## APIキーのセキュリティ設定

### リスク順位

| 方法 | リスク | 推奨 |
|---|---|---|
| `~/.zshrc` に直接記載 | 高（dotfiles誤公開・全セッション露出） | ❌ 禁止 |
| `.env` ファイル | 中（git混入リスク） | ⚠️ 非推奨 |
| macOS Keychain | 低（ファイル不在・ACL保護） | ✅ 推奨 |

### Keychain への登録（初回のみ）

```bash
security add-generic-password \
  -a "$USER" \
  -s "anthropic-api-key" \
  -w "sk-ant-xxxx"   # 実際のキーを入力
```

### スクリプトからの読み取り

**bash**:
```bash
ANTHROPIC_API_KEY=$(security find-generic-password \
  -a "$USER" -s "anthropic-api-key" -w 2>/dev/null)
```

**Python**:
```python
import subprocess, os

result = subprocess.run(
    ["security", "find-generic-password",
     "-a", os.environ["USER"], "-s", "anthropic-api-key", "-w"],
    capture_output=True, text=True
)
api_key = result.stdout.strip() or os.environ.get("ANTHROPIC_API_KEY", "")
```

> Keychain優先、なければ環境変数フォールバック（CI/CD環境対応）
