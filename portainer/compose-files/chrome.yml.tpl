services:
  chrome:
    image: lscr.io/linuxserver/chrome:latest
    container_name: chrome
    security_opt:
      - seccomp:unconfined #optional
    environment:
      - PUID=${docker_user_puid}
      - PGID=${docker_user_pgid}
      - TZ=${docker_timezone}
    ports:
      - 3000:3000
      - 3001:3001
    shm_size: "1gb"
    restart: always
    volumes:
      - ${docker_config_path}/chrome:/config