# 기술 스택

## 개요

| 계층 | 기술 |
|------|------|
| Backend | Spring Boot 4.0.5 (Java 17) |
| Primary DB | PostgreSQL |
| Cache | Redis |
| Build | Gradle 9.4.1 |

---

## Backend — Spring Boot 4.0.5

### Core
| 라이브러리 | 용도 |
|-----------|------|
| `spring-boot-starter-webmvc` | REST API 엔드포인트 |
| `spring-boot-starter-data-jpa` | ORM, Repository 패턴 |
| `spring-boot-starter-data-redis` | Redis 캐시 연동 |
| `lombok` | 보일러플레이트 제거 (`@Getter`, `@Builder` 등) |
| `spring-boot-devtools` | 개발 환경 핫 리로드 |

### 의존성 추가 필요 (build.gradle)
```groovy
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-webmvc'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-data-redis'
    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'
    developmentOnly 'org.springframework.boot:spring-boot-devtools'
    runtimeOnly 'org.postgresql:postgresql'
    testImplementation 'org.springframework.boot:spring-boot-starter-data-jpa-test'
    testImplementation 'org.springframework.boot:spring-boot-starter-webmvc-test'
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
}
```
> `mysql-connector-j` 제거 — PostgreSQL 단일 사용

---

## Primary DB — PostgreSQL

### 선택 이유
| 기능 | 활용처 |
|------|--------|
| **PostGIS** | `CLUB.latitude/longitude` 기반 지도 범위 쿼리, 구단 간 거리 계산 |
| **Window Function** | `RANK() OVER (ORDER BY credibility_score DESC)` 기자 순위 산출 |
| **Full-text Search** | 이적 뉴스 본문 검색 (별도 검색 엔진 불필요) |
| **JSONB** | X API 원본 응답 저장 |

### application.properties
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/transfer
spring.datasource.username=
spring.datasource.password=
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=validate
```

---

## Cache — Redis

### 용도
| 캐시 키 | 내용 | TTL |
|---------|------|-----|
| `journalist:ranking` | 기자 공신력 순위 리스트 | 30분 |
| `news:feed:latest` | 최신 이적 뉴스 피드 | 10분 |
| `journalist:{id}:score` | 기자별 공신력 점수 | 1시간 |
| `x-api:rate-limit` | X API 수집 주기 제어 카운터 | 15분 |

### application.properties
```properties
spring.data.redis.host=localhost
spring.data.redis.port=6379
```

---

## 채택하지 않은 기술

| 기술 | 이유 |
|------|------|
| MySQL | PostGIS·Window Function·JSONB에서 PostgreSQL이 우위 |
| Elasticsearch | PostgreSQL Full-text Search로 현 규모에서 충분 |
| Kafka | X 수집 파이프라인 단순 → Redis Pub/Sub 또는 Spring Batch로 대체 |

---

## 로컬 개발 환경 (Docker Compose 예시)

```yaml
services:
  postgres:
    image: postgis/postgis:16-3.4
    environment:
      POSTGRES_DB: transfer
      POSTGRES_USER: transfer
      POSTGRES_PASSWORD: transfer
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
```