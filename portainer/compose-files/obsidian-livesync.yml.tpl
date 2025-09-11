services:
  couchdb:
    image: couchdb:latest
    container_name: couchdb-for-ols
    environment:
      - PUID=${docker_user_puid}
      - PGID=${docker_user_pgid}
      - TZ=${docker_timezone}
      - COUCHDB_USER=${couchdb_user}
      - COUCHDB_PASSWORD=${couchdb_password}
    volumes:
      - ${docker_config_path}/couchdb/data:/opt/couchdb/data
      - ${docker_config_path}/couchdb/etc:/opt/couchdb/etc/local.d
    ports:
      - 5984:5984
    restart: unless-stopped

networks:
  default:
    driver: bridge
