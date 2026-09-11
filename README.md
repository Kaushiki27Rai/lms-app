# LMS Intelligence

An enterprise-style learning management system built by extending the original Java Servlet/JSP LMS. It combines course delivery, submissions and quizzes with measurable learning analytics and an explainable student-risk workflow.

## What it demonstrates

- **Students:** authentication, course enrollment, modules, assignments, secure file submissions, quizzes, notifications, progress, and database-backed analytics.
- **Instructors:** course creation and role-aware dashboard workflows; the API exposes student analytics, risk signals and interventions for an AI insights view.
- **Engineering:** layered controller/service/DAO flow, prepared SQL, BCrypt password hashing, session authorization, DTO-shaped JSON responses, aggregate queries, indexes, Docker Compose, and a separately deployable ML API.

## Architecture

```text
JSP web client / future mobile client
              | session REST/JSON
Java Servlets -> Services -> DAO/JDBC -> MySQL
              | HTTP
          FastAPI -> Random Forest risk model
```

## Run locally

1. Create MySQL database and load `schema.sql`.
2. Copy `.env.example` values into your shell (do not commit credentials): `export DB_PASSWORD='...' ML_SERVICE_URL=http://localhost:8001`.
3. Start ML service: `cd ml-service && python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt && python model/train_model.py && uvicorn app:app --port 8001`.
4. In another terminal: `mvn jetty:run` and open `http://localhost:8080`.

Or use `docker compose up --build`. Seed password hashes use BCrypt; create your own account through signup for local use. Replace all demonstration users in a real deployment.

## AI risk prediction

The FastAPI service accepts attendance, quiz score, assignment submission rate/score, completion, missed assignments, attempts, weekly hours and recent activity. It returns LOW/MEDIUM/HIGH risk, confidence and transparent contributing factors. Java obtains the features with SQL aggregation, calls `/predict`, and falls back to transparent rule-based advice only if the ML service is unavailable. The starter model trains on explicitly synthetic data; its printed precision/recall/F1/confusion matrix are demonstration diagnostics, not production accuracy. Real use needs consented historical labels, bias checks, monitoring, and human review.

## Key endpoints

See [docs/API.md](docs/API.md). Core examples: `/api/auth/login`, `/api/courses`, `/api/students/{id}/dashboard`, `/api/ai/risk/{id}`, and `/api/ai/recommendations/{id}`.

## Interview talking points

1. Preserved a servlet/JSP product while adding mobile-ready REST boundaries.
2. Kept business logic in services and database access in DAOs.
3. Used SQL aggregates and composite indexes for dashboard-scale queries.
4. Enforced server-side ownership checks rather than trusting URL IDs.
5. Migrated password security with BCrypt while retaining legacy-row compatibility.
6. Stored uploaded files using generated names and allow-listed extensions.
7. Chose an interpretable, independently deployable Random Forest service.
8. Made ML failure non-fatal with clearly labelled data-derived fallback advice.
9. Kept prediction features derived from activity data and retained an audit-table design.
10. Containerized MySQL, Java, and Python services for repeatable deployment.

## Known limits

The current ML model is synthetic and should not drive automated academic decisions. The REST layer is session-based (a mobile production deployment should add short-lived tokens/CSRF protection), instructor risk cohort UI needs further product work, and legacy JSP output should be migrated to JSTL escaping for complete XSS hardening.
