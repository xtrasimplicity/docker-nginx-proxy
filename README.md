# Secure NGinx Reverse Proxy for Docker

A NGinx docker image to handle automatic HTTP to HTTPS redirection, and reverse proxying.

This image exposes an NGinx reverse proxy that is **only** accessible over SSL. HTTP traffic that reaches NGinx will be automatically redirected to the secure equivalent.

## Usage
### Preparation

In order to use this image, you will need to have a Diffie Hellman parameter file (named `dhparam.pem`) and an SSL certificate and private key in X509 format. If you don't have these, you can generate them using the following `openssl` commands, on Linux (and possibly Mac OS X).

1. #### Diffie Hellman parameters
```bash
openssl dhparam -out ssl_files/dhparam.pem 4096
```

Please note that your DH parameters file *_must_* be named `dhparam.pem`.

2. #### SSL certificate + private key in X509 format
    i. **Self-signed**
     ```bash
      openssl req -x509 -newkey rsa:4096 -keyout ssl_files/key.pem -out ssl_files/cert.pem -days 365 -nodes
     ```
    ii. **Signed by a trusted CA**
    
      If you have an SSL certificate signed by a trusted CA, you _may_ need to combine the CA's certificate with your site's certificate. You can do this using `cat`, e.g:

      ```bash
      cat ca.pem intermediate.pem > combined.pem
      ```

Once you have your DH parameter file, your combined SSL certs and private key (all in X509 format), you will need to store them all in the same directory, and mount this directory to `/etc/ssl/private` in the docker container.

If you have named your certificate and private key anything other than `cert.pem` and `key.pem`, respectively, you will need to specify the `SSL_CERT_FILENAME` and `SSL_CERT_KEY_FILENAME` environment variables when running this image.

### Docker-compose

If you're using docker-compose, simply add an additional service to your `docker-compose.yml` file that uses the `xtrasimplicity/nginx-proxy` image, defines the required environment variables, exposes HTTP and HTTPS ports, and depends on your application. e.g.

```yaml
version: '3'

services:
   myapp:
     image: myapp:latest
  
   proxy:
     image: xtrasimplicity/nginx-proxy:latest
     depends_on:
      - myapp
     environment:
      HTTP_PORT: # (Optional) The port on which to bind the proxy server's HTTP daemon,, within the container. Defaults to 80
      HTTPS_PORT: # (Optional) The port on which to bind the proxy server's HTTPS daemon, within the container. Defaults to 443
      SERVER_NAME: # (Required) The name of the virtual host (i.e. your site's FQDN). Required
      PROXIED_APP_URL: # (Required) The URL to the application that will be proxied. This is usually the name of your dependent application, prefixed by the scheme. e.g. http://myapp. A unix socket can also be used here. This will be passed to NGinx's `proxy_pass` directive.
      SSL_CERT_FILENAME: # (Optional) The filename of the SSL certificate. Defaults to `cert.pem`.
      SSL_CERT_KEY_FILENAME: # (Optional) The filename of the SSL certificate's private key. Defaults to `key.pem`.
      
     volumes:
      - ./data/ssl_files:/etc/ssl/private # (Required) The volume, or local directory, that contains the Diffie-hellman parameter file (`dhparam.pem`) and both SSL certificates.
     ports:
       - 80:80
       - 443:443
```

### Defining multiple virtual hosts
If you would like to define multiple virtual hosts, you will need to create a YML file and mount it to `/config/vhosts.yml`. Please note: If you do this, *ALL* vhost-related environment variables will be ignored.

```yaml
---
vhosts:
  - server_name: my-first-app.com
    proxied_app_url: http://app1
    ssl_cert_filename: app1-cert.pem
    ssl_cert_key_filename: app1-key.pem
    http_port: # Optional, Defaults to 80
    https_port: # Optional, Defaults to 443
    nginx_directives: # Optional, additional NGinx directives, in `Key: value` format.
      client_max_body_size: 0
    headers_to_exclude: # Optional, an array of headers to be excluded from the generated NGinx config file. Note: Headers added using `nginx_directives` are not excluded.
 
  - server_name: my-second-app.com
    proxied_app_url: http://app2
    ssl_cert_filename: app2-cert.pem
    ssl_cert_key_filename: app2-key.pem
    http_port: # Optional, Defaults to 80
    https_port: # Optional, Defaults to 443
    nginx_directives: # Optional, additional NGinx directives, in `Key: value` format.
      client_max_body_size: 0
```

## License

The image is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
