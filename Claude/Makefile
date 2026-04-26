.PHONY: install check test test-unit coverage

# ~/.claude/ に notify.sh と notify.py をインストール
install: check
	@echo "Installing notify.sh and notify.py to ~/.claude/ ..."
	@mkdir -p ~/.claude
	@cp notify.sh ~/.claude/notify.sh
	@chmod +x ~/.claude/notify.sh
	@cp notify.py ~/.claude/notify.py
	@chmod +x ~/.claude/notify.py
	@echo "Done!"

# 依存チェック
check:
	@which terminal-notifier > /dev/null 2>&1 || \
		(echo "Error: terminal-notifier が見つかりません。以下を実行してください:" && \
		 echo "  brew install terminal-notifier" && exit 1)
	@which python3 > /dev/null 2>&1 || \
		(echo "Error: python3 が見つかりません。" && exit 1)
	@echo "OK: terminal-notifier and python3 found."

# 動作テスト (terminal-notifier 経由の手動確認)
test:
	@echo "Testing notification ..."
	@echo '{"cwd": "$(CURDIR)", "notification_type": "stop"}' | bash ~/.claude/notify.sh
	@echo "Test done."

# pytest によるユニットテスト
test-unit:
	@python3 -m pytest tests/ -q

# カバレッジ計測 (XML 出力は CI で codecov に送る)
coverage:
	@python3 -m pytest tests/ \
		--cov=notify \
		--cov-report=xml \
		--cov-report=term-missing
