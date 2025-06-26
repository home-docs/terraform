services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    environment:
      - PUID=${docker_user_puid}
      - PGID=${docker_user_pgid}
      - TZ=${docker_timezone}
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_INCLUDE_STOPPED=true
      - WATCHTOWER_REVIVE_STOPPED=false
      - WATCHTOWER_SCHEDULE=0 0 6 * * *
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    network_mode: host
    restart: always