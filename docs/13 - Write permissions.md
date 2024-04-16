The error message indicates that you don't have the necessary permissions to write to the file `/home/ohroot/Desktop/tools/wp-manager/html/index.html`. 

You can change the ownership and permissions of the `html` directory on your host machine using the `chown` and `chmod` commands. 

Here's how you can do it:

```bash
# Change ownership
sudo chown $USER:$USER /home/ohroot/Desktop/tools/wp-manager/html -R

# Change permissions
sudo chmod 755 /home/ohroot/Desktop/tools/wp-manager/html -R
```

These commands will give your user ownership of the `html` directory and its contents, and set the permissions so that the owner can read, write, and execute files in the directory, while others can only read and execute them. 

Please replace `$USER` with your actual username if it's not set as an environment variable.
