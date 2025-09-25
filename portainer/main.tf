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

# resource "portainer_stack" "calibre_web" {
#   name            = "calibre_web"
#   deployment_type = "standalone"
#   method          = "string"
#   endpoint_id     = var.portainer_endpoint_id
#   stack_file_content = templatefile("${path.module}/compose-files/calibre-web.yml.tpl", {
#     docker_user_puid   = var.docker_user_puid
#     docker_user_pgid   = var.docker_user_pgid
#     docker_timezone    = var.docker_timezone
#     docker_config_path = var.docker_config_path
#   })
# }

# resource "portainer_stack" "chrome" {
#   name            = "chrome"
#   deployment_type = "standalone"
#   method          = "string"
#   endpoint_id     = var.portainer_endpoint_id
#   stack_file_content = templatefile("${path.module}/compose-files/chrome.yml.tpl", {
#     docker_user_puid   = var.docker_user_puid
#     docker_user_pgid   = var.docker_user_pgid
#     docker_timezone    = var.docker_timezone
#     docker_config_path = var.docker_config_path
#   })
# }

# resource "portainer_stack" "drawio" {
#   name            = "drawio"
#   deployment_type = "standalone"
#   method          = "string"
#   endpoint_id     = var.portainer_endpoint_id
#   stack_file_content = templatefile("${path.module}/compose-files/drawio.yml.tpl", {
#     docker_user_puid   = var.docker_user_puid
#     docker_user_pgid   = var.docker_user_pgid
#     docker_timezone    = var.docker_timezone
#     docker_config_path = var.docker_config_path
#   })
# }

resource "portainer_stack" "gluetun" {
  name            = "gluetun"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.portainer_endpoint_id
  stack_file_content = templatefile("${path.module}/compose-files/gluetun.yml.tpl", {
    docker_user_puid   = var.docker_user_puid
    docker_user_pgid   = var.docker_user_pgid
    docker_timezone    = var.docker_timezone
    docker_config_path = var.docker_config_path
    docker_data_path   = var.docker_data_path
  })
}

resource "portainer_stack" "karakeep" {
  name            = "karakeep"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.portainer_endpoint_id
  stack_file_content = templatefile("${path.module}/compose-files/karakeep.yml.tpl", {
    docker_config_path              = var.docker_config_path
    karakeep_meilisearch_master_key = var.karakeep_meilisearch_master_key
    karakeep_nextauth_secret        = var.karakeep_nextauth_secret
    karakeep_nextauth_url           = var.karakeep_nextauth_url
    gemini_api_key                  = var.gemini_api_key
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

# resource "portainer_stack" "vaultwarden" {
#   name            = "vaultwarden"
#   deployment_type = "standalone"
#   method          = "string"
#   endpoint_id     = var.portainer_endpoint_id
#   stack_file_content = templatefile("${path.module}/compose-files/vaultwarden.yml.tpl", {
#     docker_user_puid                = var.docker_user_puid
#     docker_user_pgid                = var.docker_user_pgid
#     docker_timezone                 = var.docker_timezone
#     docker_config_path              = var.docker_config_path
#     vaultwarden_encryption_password = var.vaultwarden_encryption_password
#   })
# }

# resource "portainer_stack" "semaphore" {
#   name            = "semaphore"
#   deployment_type = "standalone"
#   method          = "string"
#   endpoint_id     = var.portainer_endpoint_id
#   stack_file_content = templatefile("${path.module}/compose-files/semaphore.yml.tpl", {
#     docker_user_puid         = var.docker_user_puid
#     docker_user_pgid         = var.docker_user_pgid
#     docker_timezone          = var.docker_timezone
#     docker_config_path       = var.docker_config_path
#     semaphore_admin_password = var.semaphore_admin_password
#     semaphore_admin_email    = var.semaphore_admin_email
#   })
# }

resource "portainer_stack" "obsidian_livesync" {
  name            = "obsidian_livesync"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.portainer_endpoint_id
  stack_file_content = templatefile("${path.module}/compose-files/obsidian-livesync.yml.tpl", {
    docker_user_puid   = var.docker_user_puid
    docker_user_pgid   = var.docker_user_pgid
    docker_timezone    = var.docker_timezone
    docker_config_path = var.docker_config_path
    couchdb_user       = var.couchdb_user
    couchdb_password   = var.couchdb_password
  })
}

# resource "portainer_stack" "workout_cool" {
#   name            = "workout_cool"
#   deployment_type = "standalone"
#   method          = "string"
#   endpoint_id     = var.portainer_endpoint_id
#   stack_file_content = templatefile("${path.module}/compose-files/workout.yml.tpl", {
#     docker_user_puid               = var.docker_user_puid
#     docker_user_pgid               = var.docker_user_pgid
#     docker_timezone                = var.docker_timezone
#     docker_config_path             = var.docker_config_path
#     workout_cool_postgres_user     = var.workout_cool_postgres_user
#     workout_cool_postgres_password = var.workout_cool_postgres_password
#   })
# }

resource "portainer_stack" "open_webui" {
  name            = "open_webui"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.portainer_endpoint_id
  stack_file_content = templatefile("${path.module}/compose-files/open-webui.yml.tpl", {
    docker_user_puid   = var.docker_user_puid
    docker_user_pgid   = var.docker_user_pgid
    docker_timezone    = var.docker_timezone
    docker_config_path = var.docker_config_path
  })
}

# resource "portainer_stack" "silverbullet" {
#   name            = "silverbullet"
#   deployment_type = "standalone"
#   method          = "string"
#   endpoint_id     = var.portainer_endpoint_id
#   stack_file_content = templatefile("${path.module}/compose-files/silverbullet.yml.tpl", {
#     docker_user_puid   = var.docker_user_puid
#     docker_user_pgid   = var.docker_user_pgid
#     docker_timezone    = var.docker_timezone
#     docker_config_path = var.docker_config_path
#   })
# }

resource "portainer_stack" "watchtower" {
  name            = "watchtower"
  deployment_type = "standalone"
  method          = "string"
  endpoint_id     = var.portainer_endpoint_id
  stack_file_content = templatefile("${path.module}/compose-files/watchtower.yml.tpl", {
    docker_user_puid   = var.docker_user_puid
    docker_user_pgid   = var.docker_user_pgid
    docker_timezone    = var.docker_timezone
    docker_config_path = var.docker_config_path
  })
}