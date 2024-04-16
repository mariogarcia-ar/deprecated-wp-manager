`mkcert` is a simple zero-config tool to make locally trusted development certificates. Here's how you can install and use it on Ubuntu:

1. First, install `libnss3-tools`. `mkcert` uses this package to install the local CA in the system trust store:

```bash
sudo apt update
sudo apt install libnss3-tools -y
```

2. Download and install `mkcert`:

```bash
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
mv mkcert-v1.4.3-linux-amd64 mkcert
chmod +x mkcert
sudo mv mkcert /usr/local/bin/
```

3. Set up the local Certificate Authority:

```bash
mkcert -install
```

4. Now you can create a locally-trusted certificate for your domain:

```bash
mkcert wpdocker.local "*.wpdocker.local"
```

This will create two files: `wpdocker.local+1.pem` and `wpdocker.local+1-key.pem`. The first file is your locally-trusted certificate, and the second one is your private key.

5. Finally, configure your web server to use the certificate and key. The exact steps depend on your web server. For Nginx, you would add these lines to your server block:

```properties
ssl_certificate /path/to/wpdocker.local+1.pem;
ssl_certificate_key /path/to/wpdocker.local+1-key.pem;
```

Replace `/path/to/` with the actual path to your certificate and key.

6. Restart your web server to apply the changes.
