# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Concept
해외축구 이적시장의 소식을 높은 수준의 기자들의 X게시물을 통해 수집한다. 기사 등록 속도 기사 정확도 기사의 파급력을 통해 기자의 공신력을 측정하여 순위를 나눈다. 그리고 유럽의 지도를 통해 높은 UI/UX를 사용자에게 제공한다.

## Project Overview

Spring Boot 4.0.5 backend (Java 17) with JPA for database access and Spring Web MVC for REST APIs. Configured with both MySQL and PostgreSQL drivers. Uses Lombok for boilerplate reduction.
빌드/실행은 사용자가 직접한다. Claude는 gradle, npm 등 실행 명령어를 절대 호출하지 않는다.
JPQL 소문자 지켜라
## Commands

```bash
./gradlew bootRun          # Run the application
./gradlew build            # Build with tests
./gradlew assemble         # Build without tests
./gradlew test             # Run all tests
./gradlew test --tests "transfer.be.SomeTestClass"  # Run a single test class
./gradlew clean            # Clean build artifacts
```

## Architecture

**Base package**: `transfer.be`

**레이어 구조:**
```
Controller (@RestController)
    ↓ DTO (Request/Response)
Service (@Service, Interface + Impl 분리)
    ↓
Repository (Spring Data JPA, JPQL 소문자)
    ↓
Model (@Entity) ← model 패키지 사용 (entity 아님)
```

**주요 패키지:**
- `transfer.be.controller` — HTTP 요청 처리
- `transfer.be.service` / `service.Impl` — 비즈니스 로직
- `transfer.be.repository` — JPA 레포지토리
- `transfer.be.model` — JPA 엔티티 (entity 패키지 아님)
- `transfer.be.dto` — 요청/응답 DTO
- `transfer.be.scheduler` — 스케줄러 (X API 수집 등)
- `transfer.be.client` — 외부 API 클라이언트 (X API)

**데이터 흐름 (X 게시물 수집):**
```
XCollectorScheduler (15분마다)
    → PostServiceImpl.collectAndSave()
    → XApiClient (X API v2, userId 기반)
    → Post 저장
```

**Entry point**: `BeApplication.java`

## Domain Rules

**Season 인코딩** — `TransferNews.season` 및 `CredibilityMetric.season` 필드에 적용:
- 방식: 시즌을 구성하는 두 연도의 끝 두 자리 합산
- 24/25 시즌 → `49` (24 + 25)
- 25/26 시즌 → `51` (25 + 26)
- 항상 홀수, 1씩 증가

**TransferWindow** — `SUMMER` (6~9월) / `WINTER` (1~2월)

**TransferNews.Status** — `INTEREST` → `RUMOR` → `CONFIRMED` / `DENIED` / `LOAN`

**Player.ContractStatus** — `FREE_AGENT` / `CONTRACTED` / `LOANED`

## Key Dependencies

- `spring-boot-starter-webmvc` — REST controllers
- `spring-boot-starter-data-jpa` — JPA repositories and ORM
- `mysql-connector-j` + `postgresql` — database drivers (configure one via `application.properties`)
- `lombok` — annotation processor; use `@Getter`, `@Setter`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor` on entities and DTOs
- Test: `spring-boot-starter-data-jpa-test` + `spring-boot-starter-webmvc-test` (JUnit 5)