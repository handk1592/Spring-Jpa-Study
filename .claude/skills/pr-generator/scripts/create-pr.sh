#!/bin/bash

# 0️⃣ 인자 파싱
BODY_FILE=""
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --body-file) BODY_FILE="$2"; shift ;;
    *) echo "알 수 없는 옵션: $1"; exit 1 ;;
  esac
  shift
done

# 1️⃣ 현재 브랜치
BRANCH=$(git branch --show-current)

if [ -z "$BRANCH" ]; then
  echo "브랜치를 찾을 수 없습니다."
  exit 1
fi

echo "현재 브랜치: $BRANCH"

# 2️⃣ 티켓 번호 추출 (Jira/Linear 공통)
TICKET=$(echo "$BRANCH" | grep -oE '[A-Z]+-[0-9]+')

# 3️⃣ 브랜치 타입 추출
TYPE=$(echo "$BRANCH" | cut -d'/' -f1)

# 4️⃣ 커밋 요약
COMMITS=$(git log main..HEAD --oneline)

# 5️⃣ 변경 파일 목록
FILES=$(git diff --name-only main...HEAD)

# 6️⃣ PR 제목 생성
TITLE=""

if [ -n "$TICKET" ]; then
  TITLE="[$TICKET] "
fi

case "$TYPE" in
  feat)
    TITLE="${TITLE}[Feat] ${BRANCH#*/}"
    ;;
  fix)
    TITLE="${TITLE}[Fix] ${BRANCH#*/}"
    ;;
  refactor)
    TITLE="${TITLE}[Refactor] ${BRANCH#*/}"
    ;;
  *)
    TITLE="${TITLE}${BRANCH}"
    ;;
esac

echo "PR 제목: $TITLE"

# 7️⃣ PR body 결정
if [ -n "$BODY_FILE" ] && [ -f "$BODY_FILE" ]; then
  echo "PR 본문 적용: $BODY_FILE"
  BODY=$(cat "$BODY_FILE")
else
  TEMPLATE_FILE=".github/pull_request_template.md"
  if [ -f "$TEMPLATE_FILE" ]; then
    echo "PR 템플릿 적용 (미분석): $TEMPLATE_FILE"
    BODY=$(cat "$TEMPLATE_FILE")
  else
    echo "PR 템플릿이 없습니다. 기본 템플릿 사용"
    BODY=$(cat <<EOF
## ✨ 변경 사항
${COMMITS}

## 📂 변경 파일
${FILES}
EOF
)
  fi
fi

# 8️⃣ PR 생성
gh pr create \
  --title "$TITLE" \
  --body "$BODY"

echo "PR 생성 완료 🚀"