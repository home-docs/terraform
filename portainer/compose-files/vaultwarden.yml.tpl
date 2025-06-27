version: "3"
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    environment:
      - PUID=${docker_user_puid}
      - PGID=${docker_user_pgid}
      - TZ=${docker_timezone}
      - DOMAIN:"https://vaultwarden.ketwork.in"
      - SIGNUPS_ALLOWED=false
    volumes:
      - ${docker_config_path}/vaultwarden/config:/data/
    ports:
      - "8833:80"
    restart: always