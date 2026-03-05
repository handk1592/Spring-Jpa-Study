---
name: pr-generator
description: GitHub PR 템플릿을 참고하여 Pull Request 본문을 생성하는 스킬
---

사용자가 "pr 생성해줘"라고 입력하면 다음을 수행한다:

1. 실행 전 사용자에게 확인한다:
   "PR을 생성하시겠습니까? (y/n)"

2. y일 경우 아래 단계를 순서대로 수행한다:

   a. 정보 수집:
      - `git branch --show-current` 으로 현재 브랜치 확인
      - `git log main..HEAD --oneline` 으로 커밋 목록 확인
      - `git diff main...HEAD --stat` 으로 변경 파일 목록 확인
      - `git diff main...HEAD` 으로 실제 코드 변경 내용 확인
      - `.github/pull_request_template.md` 파일이 존재하면 내용을 읽는다

   b. PR 제목 생성:
      - 브랜치명에서 Jira 티켓 번호 추출 (정규식: `[A-Z]+-[0-9]+`)
      - 브랜치 prefix(feat/fix/refactor)를 기반으로 제목 생성
      - 최종 형식 (티켓 있을 때): `[HAN-002] [Feat] <브랜치명>`
      - 최종 형식 (티켓 없을 때): `[Feat] <브랜치명>`

   c. PR 템플릿 각 섹션을 실제 내용으로 채운다:
      - `## 📌 작업 내용`: git diff를 분석하여 주요 작업 내용을 bullet point로 작성
      - `## 🔍 변경 이유`: 브랜치명, 커밋 메시지, 코드 변경을 토대로 작업 이유 작성
      - `## ✅ 체크리스트`: 테스트 파일 존재 여부 확인 후 적절히 체크 표시
      - `## 🔗 관련 이슈`: 티켓 번호 기재 (예: `Closes HAN-002`), 없으면 생략
      - `## 💬 기타 참고 사항`: 리뷰어가 알아야 할 특이사항 작성, 없으면 생략
      - `## 📷 스크린샷` 섹션은 UI 변경이 없으면 제거

   d. GitHub CLI로 PR 생성:
      - `gh pr create --title "<title>" --body "<body>"`