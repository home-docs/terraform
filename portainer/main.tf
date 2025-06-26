terraform {
  required_providers {
    portainer = {
      source = "portainer/portainer"
    }
  }
}

provider "portainer" {
  endpoint = var.portainer_url
  api_key  = var.portainer_api_key
}

resource "portainer_stack" "calibre_web" {
  name            = "calibre_web"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.portainer_endpoint_id
  stack_file_content = templatefile("${path.module}/compose-files/calibre-web.yml.tpl", {
    docker_user_puid   = var.docker_user_puid
    docker_user_pgid   = var.docker_user_pgid
    docker_timezone    = var.docker_timezone
    docker_config_path = var.docker_config_path
  })
}

resource "portainer_stack" "kometa" {
  name            = "kometa"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.portainer_endpoint_id
  stack_file_content = templatefile("${path.module}/compose-files/kometa.yml.tpl", {
    docker_user_puid   = var.docker_user_puid
    docker_user_pgid   = var.docker_user_pgid
    docker_timezone    = var.docker_timezone
    docker_config_path = var.docker_config_path
  })
}

resource "portainer_stack" "vaultwarden" {
  name            = "vaultwarden"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.portainer_endpoint_id
  stack_file_content = templatefile("${path.module}/compose-files/vaultwarden.yml.tpl", {
    docker_user_puid   = var.docker_user_puid
    docker_user_pgid   = var.docker_user_pgid
    docker_timezone    = var.docker_timezone
    docker_config_path = var.docker_config_path
  })
}