# README

## Dependencies

In order to run the application locally the following software is required:

- Ruby 2.2.2
- Bundler 1.10
- PostgreSQL 9.4.4

## Installation

1. Install dependencies
2. Go to the project directory
3. Run `bundler install`
4. Run `rake db:setup`
5. Run `rails server`
6. Open `http://localhost:3000` in the browser

## Deployment

### 1. Install Docker

Please reference these links.

https://phoenixnap.com/kb/how-to-install-docker-on-ubuntu-18-04

https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04

### 2. Install docker compose

https://phoenixnap.com/kb/install-docker-compose-ubuntu

### 3. Clone the project

### 4. Run docker compose

> cd ips-app
> 
> docker-compose up -d

To check the log, you can run `docker-compose up`.

### 5. Restore database

Copy db dump file to the instance.

        sudo scp -i test.pem backup.sql root@instance_ip:~

Connect your instance with ssh and copy db dump file to the db container.

        docker cp backup.sql db_container_id:/
        
Connect the db container and restore db.

        docker exec -it db_container_id bash -l

        psql -U postgres -d ips -f backup.sql

To get the db_container_id, please run `docker ps`.

### 6. Connect domain to your instance ip.

That's all :)
