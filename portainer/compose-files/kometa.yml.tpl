services:
  kometa:
    image: kometateam/kometa:latest
    container_name: kometa
    volumes:
      - ${docker_config_path}/kometa/config:/config
    environment:
      - PUID=${docker_user_puid}
      - PGID=${docker_user_pgid}
      - TZ=${docker_timezone}
      - KOMETA_RUN=true
      - KOMETA_SCHEDULE=0 */6 * * *
    restart: unless-stopped