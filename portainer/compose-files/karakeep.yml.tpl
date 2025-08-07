services:
  karakeep-app:
    image: ghcr.io/karakeep-app/karakeep:release
    container_name: karakeep-app
    restart: unless-stopped
    ports:
      - 5125:3000
    volumes:
      - ${docker_config_path}/karakeep/data:/data
    environment:
      - MEILI_ADDR=http://karakeep-meilisearch:7700
      - BROWSER_WEB_URL=http://karakeep-chrome:9222
      - NEXTAUTH_SECRET=${karakeep_nextauth_secret}
      - MEILI_MASTER_KEY=${karakeep_meilisearch_master_key}
      - NEXTAUTH_URL=${karakeep_nextauth_url}
      - DATA_DIR=/data
      - CRAWLER_STORE_SCREENSHOT=true
      - CRAWLER_FULL_PAGE_SCREENSHOT=true
      - CRAWLER_ENABLE_ADBLOCKER=true
      - DISABLE_SIGNUPS=true #set to true to disable signups after initial setup.
      - OPENAI_BASE_URL=https://generativelanguage.googleapis.com/v1beta
      - OPENAI_API_KEY=${gemini_api_key}
      - INFERENCE_TEXT_MODEL=gemini-2.5-flash
      - INFERENCE_IMAGE_MODEL=gemini-2.5-flash
  karakeep-chrome:
    image: gcr.io/zenika-hub/alpine-chrome:123
    container_name: karakeep-chrome
    restart: unless-stopped
    command:
      - --no-sandbox
      - --disable-gpu
      - --disable-dev-shm-usage
      - --remote-debugging-address=0.0.0.0
      - --remote-debugging-port=9222
      - --hide-scrollbars
  karakeep-meilisearch:
    image: getmeili/meilisearch:v1.13.3
    container_name: karakeep-meilisearch
    restart: unless-stopped
    environment:
      - MEILI_NO_ANALYTICS=true
      - MEILI_MASTER_KEY=${karakeep_meilisearch_master_key}
    volumes:
      - ${docker_config_path}/karakeep/meilisearch:/meili_data  
  karakeep-homedash:
    image: ghcr.io/codejawn/karakeep-homedash:latest
    container_name: karakeep-homedash
    ports:
      - "8595:8595"
    volumes:
      # Update path to your KaraKeep database
      - ${docker_config_path}/karakeep/data/db.db:/app/db.db:ro
      # Config directory for persistence
      - ${docker_config_path}/karakeep/homedash:/app/config
    restart: unless-stopped