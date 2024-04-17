# WP-cli 

To install WordPress using WP-CLI, follow these steps:

1. Open your terminal or command prompt.

2. Navigate to the directory where you want to install WordPress. For example, if you want to install it in `/var/www/html`, you can use the following command:
    ```
    cd /var/www/html
    ```

3. Run the following command to download the latest version of WordPress:
    ```
    wp core download
    ```

4. Create a new MySQL database for your WordPress installation. You can use the following command to create a database named `my_wp_db`:
    ```
    wp db create my_wp_db
    ```

5. Generate the `wp-config.php` file by running the following command:
    ```
    wp config create --dbname=my_wp_db --dbuser=root --dbpass=your_password
    ```

    Replace `my_wp_db` with the name of your database, `root` with your MySQL username, and `your_password` with your MySQL password.

6. Run the following command to install WordPress:
    ```
    wp core install --url=your_domain --title="Your Site Title" --admin_user=admin --admin_password=admin_password --admin_email=admin@example.com
    ```

    Replace `your_domain` with the URL where you want to access your WordPress site, `Your Site Title` with the title of your site, `admin` with your desired admin username, `admin_password` with your desired admin password, and `admin@example.com` with your desired admin email.

7. That's it! You have successfully installed WordPress using WP-CLI.

Remember to replace the placeholders with your own values. Feel free to explore more WP-CLI commands to manage your WordPress installation.
