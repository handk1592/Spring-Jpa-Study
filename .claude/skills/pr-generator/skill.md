---
name: pr-generator
description: PR 자동 생성 스크립트를 실행하는 스킬
---

사용자가 "pr 생성해줘"라고 하면 다음을 수행한다.

1. 프로젝트 루트의 scripts/create-pr.sh 파일이 존재하는지 확인한다.
2. 실행 전 사용자에게 확인한다:
   "PR을 생성하시겠습니까? (y/n)"
3. y일 경우에만 실행:
   bash scripts/create-pr.sh
4. 실행 결과를 그대로 사용자에게 보여준다.
5. 스크립트가 실패하면 에러 메시지를 출력한다.