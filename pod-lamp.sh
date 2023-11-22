#!/bin/bash

# Define variables
POD_NAME="lamp"
DATABASE="db_test"
USERNAME=${USER}

# Create the database folder path
DATABASE_PATH="/home/$USERNAME/Projects/$POD_NAME/$DATABASE"
PHPMYADMIN_PATH="/home/$USERNAME/Projects/$POD_NAME/phpmyadmin"

# Check if the database and phpmyadmin folder exists
if [ ! -d "$DATABASE_PATH" ]; then
   mkdir -p "$DATABASE_PATH"
   echo "Database folder created: $DATABASE_PATH"
fi

if [ ! -d "$PHPMYADMIN_PATH" ]; then
   mkdir -p "$PHPMYADMIN_PATH"
   echo "phpmyadmin folder created: $PHPMYADMIN_PATH"
fi

# Create a new pod
podman pod create --name $POD_NAME -p 8090:80 -p 3306:3306

# Run MariaDB service in detached mode
podman run -dt --pod $POD_NAME --name mariadb-service \
   -v "$DATABASE_PATH:/var/lib/mysql/data:Z" \
   -e MYSQL_USER=admin \
   -e MYSQL_PASSWORD=1234 \
   -e MYSQL_ROOT_PASSWORD=root \
   mariadb

# Run phpMyAdmin service in detached mode
podman run -dt --pod $POD_NAME --name phpmyadmin \
   -v "$PHPMYADMIN_PATH:/etc/phpmyadmin/config.user.inc.php:Z" \
   -e PMA_HOST=127.0.0.1 \
   -e PMA_PORT=3306 \
   phpmyadmin/phpmyadmin
