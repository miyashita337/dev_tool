.PHONY: install check test

# ~/.claude/notify.sh にインストール
install: check
	@echo "Installing notify.sh to ~/.claude/notify.sh ..."
	@mkdir -p ~/.claude
	@cp notify.sh ~/.claude/notify.sh
	@chmod +x ~/.claude/notify.sh
	@echo "Done! ~/.claude/notify.sh updated."

# 依存チェック
check:
	@which terminal-notifier > /dev/null 2>&1 || \
		(echo "Error: terminal-notifier が見つかりません。以下を実行してください:" && \
		 echo "  brew install terminal-notifier" && exit 1)
	@echo "OK: terminal-notifier found."

# 動作テスト
test:
	@echo "Testing notification ..."
	@echo '{"cwd": "$(CURDIR)", "notification_type": "stop"}' | bash ~/.claude/notify.sh
	@echo "Test done."
