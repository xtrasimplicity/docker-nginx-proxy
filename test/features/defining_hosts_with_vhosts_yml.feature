Feature: Defining virtual hosts with a `vhosts.yml` file

  Scenario: Defining custom NGinx directives.
    Given a file named "/config/vhosts.yml" with:
    """
    ---
    vhosts:
      - server_name: localhost.127.0.0.1.xip.io
        proxied_app_url: http:/app
        nginx_directives:
          proxy_set_header: X-Custom-Header "myValue"
    """
    When I start the proxy server
    Then the file "/etc/nginx/conf.d/localhost.127.0.0.1.xip.io.conf" should contain:
    """
    proxy_set_header X-Custom-Header "myValue";
    """

  Scenario: Defining multiple NGinx directives with the same keyword.
    Given a file named "/config/vhosts.yml" with:
    """
    ---
    vhosts:
      - server_name: localhost.127.0.0.1.xip.io
        proxied_app_url: http:/app
        nginx_directives:
          proxy_set_header: ['X-Custom-Header-A "valueA"', 'X-Custom-Header-B "valueB"']
    """
    When I start the proxy server
    Then the file "/etc/nginx/conf.d/localhost.127.0.0.1.xip.io.conf" should contain:
    """
    proxy_set_header X-Custom-Header-A "valueA";
    proxy_set_header X-Custom-Header-B "valueB";
    """

  Scenario: Excluding headers from the resulting NGinx config.
    Given a file named "/config/vhosts.yml" with:
    """
    ---
    vhosts:
      - server_name: localhost.127.0.0.1.xip.io
        proxied_app_url: http:/app
        headers_to_exclude:
          - X-Frame-Options
          - X-XSS-Protection
    """
    When I start the proxy server
    Then the file "/etc/nginx/conf.d/localhost.127.0.0.1.xip.io.conf" should not contain:
    """
    add_header X-Frame-Options
    """
    And the file "/etc/nginx/conf.d/localhost.127.0.0.1.xip.io.conf" should not contain:
    """
    add_header X-XSS-Protection
    """

  Scenario: Binding a single virtual host to multiple ports
    Given a file named "/config/vhosts.yml" with:
    """
    ---
    vhosts:
      - server_name: localhost.127.0.0.1.xip.io
        proxied_app_url: http://app
        additional_ports:
          - 8000
          - 8001
    """
    When I start the proxy server
    Then the file "/etc/nginx/conf.d/localhost.127.0.0.1.xip.io.conf" should contain the following lines:
    """
    listen 8000;
    listen [::]:8000;
    listen 8001;
    listen [::]:8001;
    """