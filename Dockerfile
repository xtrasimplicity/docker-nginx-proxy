FROM nginx:latest

VOLUME /etc/ssl/private

RUN apt-get update && \
    apt-get install -y openssl ruby --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

ADD artifacts/nginx.template /templates/
ADD artifacts/vhosts.yml /templates/

ADD artifacts/bin/start_proxy /usr/sbin/
RUN chmod +x /usr/sbin/start_proxy

CMD /usr/sbin/start_proxy