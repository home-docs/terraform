version: "3"
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    environment:
      - TZ=${docker_timezone}
      - DOMAIN:"https://vaultwarden.ketwork.in"
      - SIGNUPS_ALLOWED=false
    volumes:
      - ${docker_config_path}/vaultwarden/data:/data/
    ports:
      - "8833:80"
    restart: on-failure

  vaultwarden-backup:
    image: bruceforce/vaultwarden-backup:latest
    container_name: vaultwarden-backup
    init: true
    depends_on:
      - vaultwarden
    environment:
      - ENCRYPTION_PASSWORD=${vaultwarden_encryption_password}
      - CRON_TIME=0 */6 * * *
      - TZ=${docker_timezone}
      - BACKUP_ADD_DATABASE=true
      - BACKUP_ADD_ATTACHMENTS=true
      - BACKUP_ADD_CONFIG_JSON=true
      - BACKUP_ADD_RSA_KEY=true
      - BACKUP_ADD_SENDS=true
      - BACKUP_ON_STARTUP=true
    volumes:
      - ${docker_config_path}/vaultwarden/data:/data/
      - ${docker_config_path}/vaultwarden/backup:/backup/
    restart: on-failure