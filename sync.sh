#!/usr/bin/env bash
#
# sync.sh — 在 public-skill (GitHub) 和 mos/skills (GitLab) 之间同步 skill 文件
#
# 用法:
#   ./sync.sh push    # public-skill → mos/skills（GitHub 为源，覆盖 mos 副本）
#   ./sync.sh pull    # mos/skills → public-skill（mos 为源，覆盖 GitHub 副本）
#   ./sync.sh diff    # 查看两边差异
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PUBLIC_DIR="$SCRIPT_DIR"
MOS_SKILLS_DIR="$(cd "$SCRIPT_DIR/../mos/skills" && pwd)"

# 需要同步的 skill 列表
SKILLS=(mos-bi mos-core mos-gos mos-tapd)

usage() {
  echo "用法: $0 {push|pull|diff}"
  echo ""
  echo "  push  — public-skill → mos/skills (以 GitHub 为准)"
  echo "  pull  — mos/skills → public-skill (以 mos 为准)"
  echo "  diff  — 显示两边差异"
  exit 1
}

sync_files() {
  local src="$1" dst="$2"
  for skill in "${SKILLS[@]}"; do
    if [[ ! -d "$src/$skill" ]]; then
      echo "⚠ 跳过 $skill: $src/$skill 不存在"
      continue
    fi
    rsync -av --delete "$src/$skill/" "$dst/$skill/"
    echo "✓ $skill 已同步"
  done
}

show_diff() {
  local has_diff=0
  for skill in "${SKILLS[@]}"; do
    local result
    result=$(diff -rq "$PUBLIC_DIR/$skill" "$MOS_SKILLS_DIR/$skill" 2>&1) || true
    if [[ -n "$result" ]]; then
      echo "━━━ $skill ━━━"
      diff -ru "$PUBLIC_DIR/$skill" "$MOS_SKILLS_DIR/$skill" 2>&1 || true
      echo ""
      has_diff=1
    fi
  done
  if [[ $has_diff -eq 0 ]]; then
    echo "✓ 两边完全一致，无需同步"
  fi
}

[[ $# -lt 1 ]] && usage

case "$1" in
  push)
    echo "同步方向: public-skill → mos/skills"
    sync_files "$PUBLIC_DIR" "$MOS_SKILLS_DIR"
    echo ""
    echo "完成。记得在 mos 仓库提交变更。"
    ;;
  pull)
    echo "同步方向: mos/skills → public-skill"
    sync_files "$MOS_SKILLS_DIR" "$PUBLIC_DIR"
    echo ""
    echo "完成。记得在 public-skill 仓库提交并推送到 GitHub。"
    ;;
  diff)
    show_diff
    ;;
  *)
    usage
    ;;
esac
