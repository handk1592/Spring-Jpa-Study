---
name: pr-generator
description: PR 자동 생성 스크립트를 실행하는 스킬
---

사용자가 "pr 생성해줘"라고 하면 다음을 수행한다.

1. .claude/skills/pr-generator/scripts/create-pr.sh 파일이 존재하는지 확인한다.
2. 실행 전 사용자에게 확인한다:
   "PR을 생성하시겠습니까? (y/n)"
3. y일 경우 아래 단계를 순서대로 수행한다:

   a. 변경 내용 수집:
      - `git log main..HEAD --oneline` 으로 커밋 목록 확인
      - `git diff main...HEAD --stat` 으로 변경 파일 목록 확인
      - `git diff main...HEAD` 으로 실제 코드 변경 내용 확인

   b. 수집한 내용을 분석하여 .github/pull_request_template.md 의 각 섹션을 채운다:
      - `## 📌 작업 내용`: 변경된 코드를 분석하여 주요 작업 내용을 bullet point로 작성
      - `## 🔍 변경 이유`: 브랜치명, 커밋 메시지, 코드 변경을 토대로 작업 이유 작성
      - `## ✅ 체크리스트`: 테스트 파일 존재 여부 등을 확인하여 적절히 체크
      - `## 🔗 관련 이슈`: 브랜치명에서 추출한 Jira 티켓 번호 기재 (예: Closes HAN-002)
      - `## 💬 기타 참고 사항`: 리뷰어가 알아야 할 특이사항 작성

   c. 완성된 PR body를 /tmp/pr-body.md 파일로 저장한다.

   d. 스크립트 실행:
      bash .claude/skills/pr-generator/scripts/create-pr.sh --body-file /tmp/pr-body.md

4. 실행 결과를 그대로 사용자에게 보여준다.
5. 스크립트가 실패하면 에러 메시지를 출력한다.