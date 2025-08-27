services:
  obsidian:
    image: lscr.io/linuxserver/obsidian:latest
    container_name: obsidian
    environment:
      - PUID=${docker_user_puid}
      - PGID=${docker_user_pgid}
      - TZ=${docker_timezone}
      - CUSTOM_USER=${obsidian_web_user}
      - PASSWORD=${obsidian_web_password}
    volumes:
      - ${docker_config_path}/obsidian:/config
    ports:
      - 9876:3000    # HTTP (for proxying only)
      - 9877:3001    # HTTPS
    devices:
      - /dev/dri:/dev/dri # if GPU acceleration is required
    shm_size: "2gb"
    restart: unless-stopped
    security_opt:
      - seccomp=unconfined

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
