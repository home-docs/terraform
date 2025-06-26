services:
  calibre-web-automated:
    image: crocodilestick/calibre-web-automated:latest
    container_name: calibre-web-automated
    environment:
      - PUID=${docker_user_puid}
      - PGID=${docker_user_pgid}
      - TZ=${docker_timezone}
    volumes:
      - ${docker_config_path}/calibre-web/config:/config
      - ${docker_config_path}/calibre-web/ingest:/cwa-book-ingest
      - ${docker_config_path}/calibre-web/library:/calibre-library
    ports:
      - "8083:8083"
    restart: always