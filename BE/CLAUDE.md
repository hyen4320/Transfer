# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Concept
해외축구 이적시장의 소식을 높은 수준의 기자들의 X게시물을 통해 수집한다. 기사 등록 속도 기사 정확도 기사의 파급력을 통해 기자의 공신력을 측정하여 순위를 나눈다. 그리고 유럽의 지도를 통해 높은 UI/UX를 사용자에게 제공한다.

## Project Overview

Spring Boot 4.0.5 backend (Java 17) with JPA for database access and Spring Web MVC for REST APIs. Configured with both MySQL and PostgreSQL drivers. Uses Lombok for boilerplate reduction.

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

**Typical layered structure to follow** (not yet implemented — this is a fresh scaffold):
- `transfer.be.controller` — `@RestController` classes handling HTTP requests
- `transfer.be.service` — Business logic (`@Service`)
- `transfer.be.repository` — Spring Data JPA repositories (`@Repository`)
- `transfer.be.entity` — JPA entity classes (`@Entity`)
- `transfer.be.dto` — Request/Response DTOs

**Entry point**: `BeApplication.java` — standard `@SpringBootApplication` bootstrap.

**Configuration**: `src/main/resources/application.properties` — currently only sets `spring.application.name=BE`. Database datasource, JPA settings, and port config go here.

## Key Dependencies

- `spring-boot-starter-webmvc` — REST controllers
- `spring-boot-starter-data-jpa` — JPA repositories and ORM
- `mysql-connector-j` + `postgresql` — database drivers (configure one via `application.properties`)
- `lombok` — annotation processor; use `@Getter`, `@Setter`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor` on entities and DTOs
- Test: `spring-boot-starter-data-jpa-test` + `spring-boot-starter-webmvc-test` (JUnit 5)