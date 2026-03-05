#!/bin/bash

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

# 7️⃣ PR 템플릿 로드
TEMPLATE_FILE=".github/pull_request_template.md"

if [ -f "$TEMPLATE_FILE" ]; then
  echo "PR 템플릿 적용: $TEMPLATE_FILE"
  TEMPLATE=$(cat "$TEMPLATE_FILE")

  # placeholder 치환
  BODY="${TEMPLATE//\{\{TICKET\}\}/$TICKET}"
  BODY="${BODY//\{\{COMMITS\}\}/$COMMITS}"
  BODY="${BODY//\{\{FILES\}\}/$FILES}"

else
  echo "PR 템플릿이 없습니다. 기본 템플릿 사용"

  BODY=$(cat <<EOF
## 🎫 Ticket
${TICKET}

## ✨ 변경 사항
${COMMITS}

## 📂 변경 파일
${FILES}

## 🧪 테스트
- 로컬 테스트 완료
EOF
)
fi

# 8️⃣ PR 생성
gh pr create \
  --title "$TITLE" \
  --body "$BODY"

echo "PR 생성 완료 🚀"