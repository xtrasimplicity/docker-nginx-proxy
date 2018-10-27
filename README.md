# Secure NGinx Reverse Proxy for Docker

A NGinx docker image to handle automatic HTTP to HTTPS redirection, and reverse proxying.

This image exposes an NGinx reverse proxy that is **only** accessible over SSL. HTTP traffic that reaches NGinx will be automatically redirected to the secure equivalent.

## Usage

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
      - ssl_files:/etc/ssl/private # (Required) The volume, or local directory, that contains the Diffie-hellman parameter file and both SSL certificates.
     ports:
       - 80:80
       - 443:443
```

## License

The image is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).