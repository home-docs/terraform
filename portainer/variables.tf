variable "portainer_url" {
  description = "The portainer URL. This is the URL of your Portainer instance."
  type        = string
}

variable "portainer_api_key" {
  description = "The Portainer API key. This is used to authenticate with the Portainer API."
  type        = string
  sensitive   = true
}

variable "portainer_endpoint_id" {
  description = "The ID of the Portainer endpoint where the stack will be deployed."
  type        = number
}

variable "docker_user_puid" {
  description = "The PUID for the Docker user."
  type        = string
}

variable "docker_user_pgid" {
  description = "The PGID for the Docker user."
  type        = string
}

variable "docker_timezone" {
  description = "The timezone for the Docker container."
  type        = string
}

variable "docker_config_path" {
  description = "The path for Docker configurations."
  type        = string
}

variable "docker_data_path" {
  description = "The path for Docker data."
  type        = string
}

variable "vaultwarden_encryption_password" {
  description = "The encryption password for Vaultwarden."
  type        = string
  sensitive   = true
}

variable "semaphore_admin_password" {
  description = "The database password for Semaphore."
  type        = string
  sensitive   = true
}

variable "semaphore_admin_email" {
  description = "The admin email for Semaphore."
  type        = string
}