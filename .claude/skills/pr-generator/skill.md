---
name: pr-generator
description: GitHub PR 템플릿을 참고하여 Pull Request 본문을 생성하는 스킬
---

사용자가 "pr 생성해줘"라고 입력하면 다음을 수행한다:

1. `.github/pull_request_template.md` 파일이 존재하면 내용을 읽는다.
2. 현재 브랜치와 main 브랜치의 diff를 확인한다.
    - `git diff main...HEAD`
3. 변경된 파일 목록을 요약한다.
4. 변경 내용을 분석하여:
    - 주요 변경사항
    - 추가된 기능
    - 수정된 버그
    - 테스트 여부
      를 정리한다.
5. PR 템플릿 구조에 맞춰 내용을 채워 완성된 PR 본문을 출력한다.
6. 현재 브랜치 이름을 확인한다.
    - `git branch --show-current`
7. 브랜치 이름에서 Jira 티켓 번호를 추출한다.
    - 정규식 패턴: `[A-Z]+-[0-9]+` (예: `ABC-123`, `PROJ-456`)
    - 브랜치 예시: `feat/ABC-123-login-feature` → 티켓 번호: `ABC-123`
    - 티켓 번호가 존재하면 PR 제목 맨 앞에 `[티켓번호] ` 형식으로 추가한다.
    - 티켓 번호가 없으면 그냥 PR 제목만 사용한다.
8. 브랜치 네이밍 규칙이
    - feat/
    - fix/
    - refactor/
      인 경우 이를 기반으로 PR 제목을 생성한다.
    - 최종 PR 제목 형식 (티켓 있을 때): `[ABC-123] feat: <설명>`
    - 최종 PR 제목 형식 (티켓 없을 때): `feat: <설명>`
9. 최근 커밋 메시지 5개를 읽는다.
    - `git log --oneline -5`
10. 이를 기반으로 PR 변경 이유를 보강한다.
11. 완성된 PR 본문을 기반으로 GitHub CLI를 사용해 PR을 생성한다.
    - `gh pr create --title "<title>" --body "<body>"`
출력 형식은 markdown으로 한다.