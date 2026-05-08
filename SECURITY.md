# Security

## Container Security

- The application runs as a non-root user inside the Docker container.
- The Dockerfile uses a multi-stage build to reduce unnecessary build tools in the final runtime image.
- `.dockerignore` prevents local files, Git metadata, screenshots, and secrets from entering the Docker build context.

## Secret Management

- Secrets are not stored in application code, Dockerfile, or Compose files.
- `.env` is excluded from Git using `.gitignore`.
- `.env.example` contains only placeholder values.
- GitHub Actions uses repository secrets for server deployment variables.

## Reverse Proxy Security

Nginx is configured with:

- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `X-XSS-Protection: 1; mode=block`
- Rate limiting: `100 requests/minute` per IP

## Image Scanning

Image scanning can be performed using:

```bash
trivy image statuspulse:local
