services:
  rwmarkable:
    image: ghcr.io/fccview/rwmarkable:latest
    container_name: rwmarkable
    restart: unless-stopped
    ports:
      - 5230:3000
    volumes:
      - ${docker_config_path}/rwmarkable/data:/app/data
      - ${docker_config_path}/rwmarkable/config:/app/config:ro
      - ${docker_config_path}/rwmarkable/cache:/app/.next/cache
    environment:
      - NODE_ENV=production
      - PUID=${docker_user_puid}
      - PGID=${docker_user_pgid}
      - TZ=${docker_timezone}
