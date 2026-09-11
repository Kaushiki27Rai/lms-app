# LMS Intelligence API

All responses use `{ "success": boolean, "message": string, "data": object|null }`. Protected endpoints use the authenticated servlet session; mobile clients can exchange this for a token-based gateway later without changing resource paths.

| Method | Endpoint | Auth | Purpose |
|---|---|---|---|
| POST | `/api/auth/login` | No | Creates a session from JSON `{ "email", "password" }` |
| GET | `/api/courses` | No | Lists public course summaries |
| POST | `/api/courses/{id}/enroll` | Student | Enrolls the current student only |
| GET | `/api/students/{id}/dashboard` | Self/instructor/admin | Aggregate student metrics |
| GET | `/api/analytics/student/{id}` | Self/instructor/admin | Same analytics resource for API clients |
| GET | `/api/ai/risk/{id}` | Self/instructor/admin | ML-backed risk prediction with safe fallback |
| GET | `/api/ai/recommendations/{id}` | Self/instructor/admin | Data-derived interventions |

`401` means no session, `403` means the session lacks ownership, `404` is an unknown endpoint, and `400` is invalid input. Example prediction: `GET /api/ai/risk/2` returns `riskLevel`, `riskScore`, `confidence`, `keyFactors`, and its source.
