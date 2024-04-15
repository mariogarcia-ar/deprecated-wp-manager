# Docker

## Steps for using Docker for WordPress:

1. Install Docker on your machine if you haven't already. You can download Docker from the official website: [https://www.docker.com/get-started](https://www.docker.com/get-started).

2. Create a new directory for your WordPress project. Open a terminal and navigate to the desired location. Run the following command to create a new directory:
    ```bash
    mkdir my-wordpress-project
    ```

3. Navigate to the newly created directory:
    ```bash
    cd my-wordpress-project
    ```

4. Create a `docker-compose.yml` file in the project directory. This file will define the services and configurations for your WordPress environment. Open a text editor and add the following content to the `docker-compose.yml` file:
    ```yaml
    version: '3'
    services:
      wordpress:
         image: wordpress
         ports:
            - 8080:80
         environment:
            WORDPRESS_DB_PASSWORD: example
         volumes:
            - ./wp-content:/var/www/html/wp-content
      mysql:
         image: mysql:5.7
         environment:
            MYSQL_ROOT_PASSWORD: example
         volumes:
            - ./db-data:/var/lib/mysql
    ```

5. Save the `docker-compose.yml` file.

6. Start the Docker containers by running the following command in the terminal:
    ```bash
    docker-compose up -d
    ```

7. Wait for Docker to download the necessary images and start the containers. Once the containers are up and running, you can access your WordPress site by opening a web browser and navigating to [http://localhost:8080](http://localhost:8080).

8. Follow the WordPress installation wizard to set up your site.

That's it! You now have a Dockerized WordPress environment up and running.