services:
  silverbullet:
    image: zefhemel/silverbullet
    container_name: silverbullet
    restart: unless-stopped
    user: "${docker_user_puid}:${docker_user_pgid}"
    environment:
      - TZ=${docker_timezone}
    volumes:
      - ${docker_config_path}/silverbullet/space:/space:rw
    ports:
      - 5500:3000