#!/usr/bin/env bash

# Run this script from /app directory. i.e. sh scripts/create-starter-environment.sh


echo "Initialize the Docker terminal."
eval "$(docker-machine env phpdocker)"

echo "Do you want to install the Host \"phpdocker\" for the first time? (y/n)"
read q4

if [ "$q4" == "y" ]; then
docker-machine create --driver virtualbox phpdocker

echo "Initialize the Docker terminal."
eval "$(docker-machine env phpdocker)"

fi

echo "docker ps"
docker ps


echo "Above is the containers that are currently running on your system. Can we proceed to delete them? (y/n)"
read q2

if [ "$q2" == "y" ]; then

echo "Stopping other app containers (if exists)";
docker stop $(docker ps -a -q)

else
    exit 1;

fi

# Creating the .htaccess file in the public/ directory
cp scripts/.htaccess public/.htaccess;


echo ""
echo "Added/updated(if exists) .htaccess file to public/ directory."

echo "";
echo "Removing app container (if exists)";
docker rm -f -v phpdocker_app
echo "";

echo "Removing redis data structure container (if exists)";
docker rm -f -v phpdocker_redis
echo "";

echo "Removing mysql app container (if exists)";
docker rm -f -v phpdocker_mysql
echo "";

docker build -t phpdocker/app .
echo "Docker image is build"

echo "Removing mail container: 'phpdocker_mail' (if exists)";
docker rm -f -v phpdocker_mail
echo "";

echo "Rebuilding and start mysql app container: 'phpdocker_mysql'";
docker run --name phpdocker_mysql -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -d mysql:5.7

sleep 10;
echo "";
echo "We are listing your docker IP's below, please review before you continue:"
docker-machine ip phpdocker


echo "Can we connect to your phpdocker docker IP '192.168.99.100'? If (y)es please type 'y' else type in your full IP i.e. 192.168.99.101"
read q3

if [ "$q3" == "y" ]; then

docker exec -it phpdocker_mysql mysql -h 192.168.99.100 -uroot -proot -e \
  "CREATE DATABASE phpdocker;" -e \
  "CREATE USER phpdocker@'%' IDENTIFIED BY 'phpdocker';" -e \
  "GRANT FILE ON *.* TO phpdocker@'%';" -e \
  "GRANT ALL PRIVILEGES ON *.* TO phpdocker@'%';"

echo "Create new database and user for phpdocker";
echo "Created table and granted user permissions to phpdocker";


else

docker exec -it phpdocker_mysql mysql -h "$q3" -uroot -proot -e \
  "CREATE DATABASE phpdocker;" -e \
  "CREATE USER phpdocker@'%' IDENTIFIED BY 'phpdocker';" -e \
  "GRANT FILE ON *.* TO phpdocker@'%';" -e \
  "GRANT ALL PRIVILEGES ON *.* TO phpdocker@'%';"

echo "Create new database and user for phpdocker";
echo "Created table and granted user permissions to phpdocker";

fi

echo "";
echo "Rebuilding and start redis data structure container: 'phpdocker_redis'";
docker run --name phpdocker_redis -p 6379:6379 -d redis:3.2.6

echo "";
echo "Rebuilding and start mail container: 'phpdocker_mail'";
docker run -d -p 1025:1025 -p 8025:8025 --name phpdocker_mail mailhog/mailhog

echo "";
echo "Rebuilding and start app container: 'phpdocker_app'";
docker run -d -p 80:80 -p 443:443 --link phpdocker_redis:phpdocker_redis --link phpdocker_mysql:db -e "DB_HOST=db" --name phpdocker_app -v ${PWD}/docker/apache/sites-available:/etc/apache2/sites-available -v ${PWD}:/var/www/web-app phpdocker/app;

mv scripts/.env.sample .env;

echo "";
echo "Showing active docker containers:"
docker ps

echo "";
echo "Waiting for the app container to establish link to the database container...";
sleep 5;

echo "";

# If you have laravel, uncomment the following
#echo "Generating laravel key";
#docker exec -it phpdocker_app php artisan key:generate

#echo "Migrate and Seed"
#docker exec -it phpdocker_app php artisan migrate


#docker exec -it phpdocker_app chmod -R 777 storage/

echo "Bashing into app container"
docker exec -it phpdocker_app bash
