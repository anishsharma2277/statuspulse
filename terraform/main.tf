terraform {
  required_version = ">= 1.5.0"
}

resource "null_resource" "statuspulse_local_setup" {
  provisioner "local-exec" {
    command = "echo StatusPulse infrastructure simulation completed"
  }
}

output "deployment_note" {
  value = "Local infrastructure simulation for StatusPulse using Docker, Nginx, Cloudflare Tunnel, and Uptime Kuma"
}
