services:
  silverbullet:
    image: zefhemel/silverbullet
    container_name: silverbullet
    restart: unless-stopped
    environment:
      - PUID=${docker_user_puid}
      - PGID=${docker_user_pgid}
      - TZ=${docker_timezone}
    volumes:
      - ${docker_config_path}/silverbullet/space:/space:rw
    ports:
      - 5500:3000