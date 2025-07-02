services:
    semaphore:
        ports:
            - 5225:3000
        image: semaphoreui/semaphore:v2.15.0
        environment:
            PUID: ${docker_user_puid}
            PGID: ${docker_user_pgid}
            TZ: ${docker_timezone}
            SEMAPHORE_DB_DIALECT: bolt
            SEMAPHORE_ADMIN: admin
            SEMAPHORE_ADMIN_PASSWORD: ${semaphore_admin_password}
            SEMAPHORE_ADMIN_NAME: admin
            SEMAPHORE_ADMIN_EMAIL: ${semaphore_admin_email}
        volumes:
            - ${docker_config_path}/semaphore/data:/var/lib/semaphore
            - ${docker_config_path}/semaphore/config:/etc/semaphore
            - ${docker_config_path}/semaphore/config/tmp:/tmp/semaphore
