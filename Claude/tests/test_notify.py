"""notify.py の純粋関数に対するユニットテスト。

外部依存（terminal-notifier / Anthropic API / Keychain / ファイルシステム）
は mock または tmp_path で隔離する。
"""

from __future__ import annotations

import json
import os
import subprocess
from pathlib import Path
from unittest.mock import patch

import pytest

import notify


class TestGetProjectTitle:
    def test_returns_worktree_name_when_path_contains_worktrees(self) -> None:
        assert (
            notify.get_project_title("/Users/foo/proj/.claude/worktrees/feature-x")
            == "feature-x"
        )

    def test_returns_basename_when_no_worktrees_segment(self) -> None:
        assert notify.get_project_title("/Users/foo/my-app") == "my-app"

    def test_returns_default_for_root_path(self) -> None:
        assert notify.get_project_title("/") == "Claude Code"

    def test_returns_default_for_empty_path(self) -> None:
        assert notify.get_project_title("") == "Claude Code"

    def test_handles_trailing_worktrees_with_no_child(self) -> None:
        # worktrees が末尾にあり子セグメントが無い場合は basename にフォールバック
        assert notify.get_project_title("/some/worktrees") == "worktrees"


class TestCwdToProjectFolder:
    def test_replaces_slashes_with_dashes(self) -> None:
        assert notify.cwd_to_project_folder("/Users/foo/proj") == "-Users-foo-proj"

    def test_replaces_dots_and_special_chars(self) -> None:
        assert (
            notify.cwd_to_project_folder("/Users/a.b/.claude/worktrees/c_d")
            == "-Users-a-b--claude-worktrees-c-d"
        )

    def test_preserves_alphanumerics_and_hyphens(self) -> None:
        assert notify.cwd_to_project_folder("/abc-123/XYZ") == "-abc-123-XYZ"

    def test_handles_empty_string(self) -> None:
        assert notify.cwd_to_project_folder("") == ""

    def test_handles_unicode_chars(self) -> None:
        # 英数字・ハイフン以外は全て - に置換される（マルチバイト含む）
        # / + 日 + 本 + 語 + / = 5 文字すべて - に変換される
        assert notify.cwd_to_project_folder("/日本語/abc") == "-----abc"


class TestGetApiKey:
    def test_returns_keychain_value_when_security_succeeds(self) -> None:
        fake_result = subprocess.CompletedProcess(
            args=[], returncode=0, stdout="sk-keychain\n", stderr=""
        )
        with patch.object(notify.subprocess, "run", return_value=fake_result):
            assert notify.get_api_key() == "sk-keychain"

    def test_falls_back_to_env_when_security_fails(
        self, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        fake_result = subprocess.CompletedProcess(
            args=[], returncode=1, stdout="", stderr="not found"
        )
        monkeypatch.setenv("ANTHROPIC_API_KEY", "sk-env")
        with patch.object(notify.subprocess, "run", return_value=fake_result):
            assert notify.get_api_key() == "sk-env"

    def test_falls_back_to_env_when_security_raises(
        self, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        monkeypatch.setenv("ANTHROPIC_API_KEY", "sk-env-after-exc")
        with patch.object(notify.subprocess, "run", side_effect=FileNotFoundError):
            assert notify.get_api_key() == "sk-env-after-exc"

    def test_returns_empty_when_neither_source_has_value(
        self, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        fake_result = subprocess.CompletedProcess(
            args=[], returncode=1, stdout="", stderr=""
        )
        monkeypatch.delenv("ANTHROPIC_API_KEY", raising=False)
        with patch.object(notify.subprocess, "run", return_value=fake_result):
            assert notify.get_api_key() == ""

    def test_returns_empty_when_security_returns_blank(
        self, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        # exit 0 だが stdout が空白のみの場合は env にフォールバック
        fake_result = subprocess.CompletedProcess(
            args=[], returncode=0, stdout="   \n", stderr=""
        )
        monkeypatch.delenv("ANTHROPIC_API_KEY", raising=False)
        with patch.object(notify.subprocess, "run", return_value=fake_result):
            assert notify.get_api_key() == ""


class TestReadTranscript:
    def test_returns_empty_for_missing_path(self) -> None:
        assert notify.read_transcript("") == ""

    def test_returns_empty_for_nonexistent_file(self, tmp_path: Path) -> None:
        assert notify.read_transcript(str(tmp_path / "nope.jsonl")) == ""

    def test_extracts_user_and_assistant_text(self, tmp_path: Path) -> None:
        path = tmp_path / "t.jsonl"
        path.write_text(
            json.dumps(
                {
                    "type": "user",
                    "message": {"content": [{"type": "text", "text": "hello"}]},
                }
            )
            + "\n"
            + json.dumps(
                {
                    "type": "assistant",
                    "message": {"content": [{"type": "text", "text": "world"}]},
                }
            )
            + "\n",
            encoding="utf-8",
        )
        result = notify.read_transcript(str(path))
        assert "user: hello" in result
        assert "assistant: world" in result

    def test_skips_non_user_assistant_types(self, tmp_path: Path) -> None:
        path = tmp_path / "t.jsonl"
        path.write_text(
            json.dumps(
                {
                    "type": "system",
                    "message": {"content": [{"type": "text", "text": "sys"}]},
                }
            )
            + "\n"
            + json.dumps(
                {
                    "type": "user",
                    "message": {"content": [{"type": "text", "text": "u"}]},
                }
            )
            + "\n",
            encoding="utf-8",
        )
        result = notify.read_transcript(str(path))
        assert "sys" not in result
        assert "user: u" in result

    def test_handles_string_message_content(self, tmp_path: Path) -> None:
        path = tmp_path / "t.jsonl"
        path.write_text(
            json.dumps({"type": "user", "message": "plain text"}) + "\n",
            encoding="utf-8",
        )
        assert "user: plain text" in notify.read_transcript(str(path))

    def test_skips_invalid_json_lines(self, tmp_path: Path) -> None:
        path = tmp_path / "t.jsonl"
        path.write_text(
            "not valid json\n"
            + json.dumps(
                {
                    "type": "user",
                    "message": {"content": [{"type": "text", "text": "valid"}]},
                }
            )
            + "\n",
            encoding="utf-8",
        )
        assert "user: valid" in notify.read_transcript(str(path))

    def test_skips_empty_lines(self, tmp_path: Path) -> None:
        path = tmp_path / "t.jsonl"
        path.write_text(
            "\n\n"
            + json.dumps(
                {
                    "type": "user",
                    "message": {"content": [{"type": "text", "text": "x"}]},
                }
            )
            + "\n\n",
            encoding="utf-8",
        )
        assert "user: x" in notify.read_transcript(str(path))

    def test_keeps_only_last_15_lines(self, tmp_path: Path) -> None:
        path = tmp_path / "t.jsonl"
        rows = [
            json.dumps(
                {
                    "type": "user",
                    "message": {"content": [{"type": "text", "text": f"msg{i}"}]},
                }
            )
            for i in range(20)
        ]
        path.write_text("\n".join(rows) + "\n", encoding="utf-8")
        result = notify.read_transcript(str(path))
        assert "msg0" not in result
        assert "msg19" in result

    def test_truncates_to_max_chars(self, tmp_path: Path) -> None:
        path = tmp_path / "t.jsonl"
        big = "x" * 500
        path.write_text(
            json.dumps(
                {
                    "type": "user",
                    "message": {"content": [{"type": "text", "text": big}]},
                }
            )
            + "\n",
            encoding="utf-8",
        )
        result = notify.read_transcript(str(path), max_chars=100)
        assert len(result) == 100


class TestFindLatestTranscript:
    def test_returns_empty_when_projects_dir_missing(
        self, tmp_path: Path, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        monkeypatch.setattr(notify.Path, "home", classmethod(lambda cls: tmp_path))
        # tmp_path/.claude/projects は存在しない
        assert notify.find_latest_transcript("/anything") == ""

    def test_returns_empty_when_no_jsonl_present(
        self, tmp_path: Path, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        monkeypatch.setattr(notify.Path, "home", classmethod(lambda cls: tmp_path))
        cwd = "/Users/foo/proj"
        folder = notify.cwd_to_project_folder(cwd)
        (tmp_path / ".claude" / "projects" / folder).mkdir(parents=True)
        assert notify.find_latest_transcript(cwd) == ""

    def test_returns_latest_jsonl_in_exact_match_dir(
        self, tmp_path: Path, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        monkeypatch.setattr(notify.Path, "home", classmethod(lambda cls: tmp_path))
        cwd = "/Users/foo/proj"
        folder = notify.cwd_to_project_folder(cwd)
        proj_dir = tmp_path / ".claude" / "projects" / folder
        proj_dir.mkdir(parents=True)
        old = proj_dir / "old.jsonl"
        new = proj_dir / "new.jsonl"
        old.write_text("{}\n", encoding="utf-8")
        new.write_text("{}\n", encoding="utf-8")
        # mtime を確実に差を付ける

        os.utime(old, (1_000_000, 1_000_000))
        os.utime(new, (2_000_000, 2_000_000))
        assert notify.find_latest_transcript(cwd) == str(new)

    def test_ignores_jsonl_in_subdirectories(
        self, tmp_path: Path, monkeypatch: pytest.MonkeyPatch
    ) -> None:
        # subagents 配下の jsonl は対象外
        monkeypatch.setattr(notify.Path, "home", classmethod(lambda cls: tmp_path))
        cwd = "/Users/foo/proj"
        folder = notify.cwd_to_project_folder(cwd)
        proj_dir = tmp_path / ".claude" / "projects" / folder
        sub_dir = proj_dir / "subagents"
        sub_dir.mkdir(parents=True)
        (sub_dir / "child.jsonl").write_text("{}\n", encoding="utf-8")
        assert notify.find_latest_transcript(cwd) == ""


class TestSounds:
    def test_sounds_list_is_non_empty_and_strings(self) -> None:
        assert len(notify.SOUNDS) > 0
        assert all(isinstance(s, str) and s for s in notify.SOUNDS)

    def test_default_sound_glass_is_present(self) -> None:
        # main() のフォールバックで使う "Glass" が登録されている
        assert "Glass" in notify.SOUNDS
