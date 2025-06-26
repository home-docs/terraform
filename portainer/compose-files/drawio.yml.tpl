services:
  drawio:
    image: jgraph/drawio:latest
    container_name: drawio
    environment:
      - TZ=${docker_timezone}
    ports:
      - "8008:8080" # Host port 8008 -> Container port 8080
    restart: always