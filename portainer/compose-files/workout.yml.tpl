services:
  workout-cool:
    image: snouzy/workout-cool:latest
    container_name: workout-cool
    ports:
      - "7777:3000"
    environment:
      DATABASE_URL: postgresql://postgres:${workout_cool_postgres_password}@${workout_cool_postgres_user}:5432/workout_cool
      SEED_SAMPLE_DATA: "true"
      PUID: ${docker_user_puid}
      PGID: ${docker_user_pgid}
      TZ: ${docker_timezone}
    depends_on:
      - postgres
    restart: unless-stopped

  postgres:
    image: postgres:15-alpine
    container_name: workout-cool-postgres
    environment:
      POSTGRES_DB: workout_cool
      POSTGRES_USER: ${workout_cool_postgres_user}
      POSTGRES_PASSWORD: ${workout_cool_postgres_password}
    volumes:
      - ${docker_config_path}/workoutcool_pgdata:/var/lib/postgresql/data
    restart: unless-stopped
