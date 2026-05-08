# StatusPulse

A containerized FastAPI service with PostgreSQL and Redis integration.

## Features

- FastAPI backend
- PostgreSQL database
- Redis cache
- Dockerized setup
- Docker Compose orchestration
- GitHub Actions CI/CD
- Healthcheck endpoint
- Integration testing
- GHCR image publishing

---

## Tech Stack

- Python 3.11
- FastAPI
- PostgreSQL
- Redis
- Docker
- GitHub Actions

---

## Run Locally

Clone repository:

```bash
git clone https://github.com/anishsharma2277/statuspulse.git
cd statuspulse
cp .env.example .env
make build
make up
```

Health check:

```bash
curl http://localhost:8000/health
```

---

## Production Deployment

The application is deployed using Docker Compose with Nginx as a reverse proxy.

### Public URLs

#### Main Application
https://breaks-resorts-arranged-count.trycloudflare.com/

#### Health Endpoint
https://breaks-resorts-arranged-count.trycloudflare.com/health

#### Swagger Documentation
https://breaks-resorts-arranged-count.trycloudflare.com/docs

#### Uptime Kuma Monitoring
https://cream-appraisal-jewish-joyce.trycloudflare.com/dashboard/1

---

## Domain & HTTPS Setup

A DuckDNS domain was configured for deployment:

http://statuspulse-anish.duckdns.org/

Nginx is configured as the reverse proxy with:
- Rate limiting
- Security headers
- Proxy forwarding
- Production-ready virtual host configuration

Cloudflare Tunnel is used to securely expose the local deployment over HTTPS because the deployment is hosted on a local Ubuntu machine instead of a public cloud VM.

### Certbot Support

The Nginx configuration is fully compatible with Certbot and Let's Encrypt SSL certificates.

On a public VM, HTTPS can be enabled using:

```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d statuspulse-anish.duckdns.org
```

This automatically:
- Generates free SSL certificates
- Configures HTTPS
- Redirects HTTP → HTTPS
- Enables automatic renewal

---

## Infrastructure as Code

Terraform files are included in the `terraform/` directory.

Included files:
- `main.tf`
- `variables.tf`
- `README.md`

The Terraform configuration demonstrates:
- Variable-driven infrastructure setup
- Reusable deployment structure
- Security group/firewall concepts
- Docker deployment workflow concepts

---

## Monitoring & Alerting

Monitoring is implemented using Uptime Kuma.

Configured monitors:
- StatusPulse `/health`
- PostgreSQL TCP
- Redis TCP
- TLS monitoring

Additional scripts:
- `scripts/health-monitor.sh`
- `scripts/backup.sh`

---

## Security Features

Implemented hardening includes:
- Non-root Docker containers
- Multi-stage builds
- Health checks
- Security headers
- Rate limiting
- Environment-based secrets
- GitHub Actions CI/CD

---

## CI/CD Pipeline

GitHub Actions workflows:
- `.github/workflows/ci.yml`
- `.github/workflows/deploy.yml`

Pipeline includes:
- Ruff linting
- Hadolint scanning
- Docker image builds
- Integration testing
- Deployment workflow
- Health verification
- Rollback logic
