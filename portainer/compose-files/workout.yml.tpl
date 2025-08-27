services:
  workout-cool:
    image: snouzy/workout-cool:latest
    container_name: workout-cool
    ports:
      - "7777:3000"
    environment:
      # Update these according to your preferences
      DATABASE_URL: postgresql://postgres:password@postgres:5432/workout_cool
      SEED_SAMPLE_DATA: "true"
    depends_on:
      - postgres
    restart: unless-stopped

  postgres:
    image: postgres:15-alpine
    container_name: workout-cool-postgres
    environment:
      POSTGRES_DB: workout_cool
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    volumes:
      - ${docker_config_path}/workoutcool_pgdata:/var/lib/postgresql/data
    restart: unless-stopped
