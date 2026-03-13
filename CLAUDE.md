# CLAUDE.md

이 파일은 Claude Code(claude.ai/code)가 이 저장소에서 작업할 때 참고하는 가이드입니다.

## 빌드 및 실행 명령어

```bash
./gradlew build          # 프로젝트 빌드
./gradlew bootRun        # 애플리케이션 실행
./gradlew test           # 전체 테스트 실행
./gradlew clean build    # 클린 후 재빌드

# 특정 테스트 클래스만 실행
./gradlew test --tests "com.jpa.study.repository.MemberJpaRepositoryTest"

# 상세 로그와 함께 테스트 실행
./gradlew test -i
```

애플리케이션 실행 중 H2 콘솔은 `http://localhost:8080/h2-console`에서 접근 가능합니다. (JDBC URL: `jdbc:h2:mem:example`, 사용자: `sa`, 비밀번호 없음)

## 아키텍처

JPA 기초 학습을 위한 단일 모듈 Spring Boot 2.7.5 / Java 11 프로젝트입니다. 메인 패키지는 `com.jpa.study`입니다.

**핵심 설계 방침:** 리포지토리 계층은 `JpaRepository`를 상속하는 Spring Data JPA 인터페이스를 사용합니다. 회원가입 등 실용적인 기능 개발에 집중합니다.

**레이어 구조:**
- `controller/` — REST 컨트롤러 (Spring MVC)
- `entity/` — H2 인메모리 테이블에 매핑된 JPA 엔티티
- `repository/` — `EntityManager`를 직접 사용하는 리포지토리
- `common/` — 공용 enum (예: `RoleType`)

## Git 규칙

- **커밋 및 푸시는 사용자가 직접 수행합니다.** Claude는 `git commit`, `git push` 등의 명령을 실행하지 않습니다.

## 설정 주의사항

- **DDL:** `spring.jpa.hibernate.ddl-auto: create` — 애플리케이션 시작 시마다 스키마가 삭제 후 재생성됩니다 (개발 전용 설정)
- **로깅:** Hibernate SQL 및 바인딩 파라미터가 기본적으로 DEBUG/TRACE 레벨로 출력됩니다 (`application.yml` 참고)
- **데이터베이스:** H2 인메모리(`jdbc:h2:mem:example`) 사용으로 별도 외부 DB 설치 불필요