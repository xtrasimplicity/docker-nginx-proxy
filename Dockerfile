FROM nginx:latest

VOLUME /etc/ssl/private

RUN apt-get update && \
    apt-get install -y openssl

ADD artifacts/nginx.template /etc/nginx/conf.d/nginx.template

ADD artifacts/bin/start_proxy /usr/sbin/
RUN chmod +x /usr/sbin/start_proxy

CMD /usr/sbin/start_proxy