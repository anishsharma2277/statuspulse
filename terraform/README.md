# Terraform

This Terraform configuration provides an infrastructure simulation for the StatusPulse assessment.

Oracle Cloud Free Tier was attempted but unavailable during implementation, so the deployment was completed on a local Ubuntu machine using Docker, Docker Compose, Nginx, Cloudflare Tunnel, and Uptime Kuma.

## Usage

```bash
cd terraform
terraform init
terraform plan
terraform apply
