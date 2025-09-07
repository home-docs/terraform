services:
  openwebui:
    image: ghcr.io/open-webui/open-webui:main
    ports:
      - "3333:8080"
    environment:
      - PUID= ${docker_user_puid}
      - PGID= ${docker_user_pgid}
      - TZ= ${docker_timezone}
      - OLLAMA_BASE_URL=https://ollama.ketwork.in
    volumes:
      - ${docker_config_path}/open-webui/data:/app/backend/data