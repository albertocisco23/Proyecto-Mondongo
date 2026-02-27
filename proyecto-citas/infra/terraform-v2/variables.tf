variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-south-2"
}

variable "project_name" {
  type        = string
  description = "Project base name"
  default     = "portal-citas"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "demo"
}

variable "owner_tag" {
  type        = string
  description = "Owner tag for resources"
  default     = "equipo"
}

# App
variable "container_port" {
  type    = number
  default = 8000
}

variable "image_uri" {
  type        = string
  description = "ECR image URI (with tag), e.g. 3163.../portal-citas-api:1.0"
}

variable "admin_token" {
  type        = string
  description = "Admin token for demo endpoints (GET/DELETE)"
  default     = "admin123"
  sensitive   = true
}

# RDS
variable "db_name" {
  type    = string
  default = "appointments"
}

variable "db_username" {
  type    = string
  default = "postgres"
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

# ECS
variable "ecs_desired_count" {
  type    = number
  default = 1
}

variable "ecs_cpu" {
  type    = number
  default = 256
}

variable "ecs_memory" {
  type    = number
  default = 512
}

variable "env" {
  type        = string
  description = "Environment tag (demo/prod)"
  default     = "demo"
}

variable "project" {
  type        = string
  description = "Project tag"
  default     = "portal-citas"
}

variable "owner" {
  type        = string
  description = "Owner tag"
  default     = "equipo"
}