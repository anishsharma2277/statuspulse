variable "project_name" {
  description = "Project name"
  type        = string
  default     = "statuspulse"
}

variable "domain_name" {
  description = "Domain or tunnel URL used for public access"
  type        = string
  default     = "trycloudflare.com"
}
