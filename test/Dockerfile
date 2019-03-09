FROM xtrasimplicity/nginx-proxy:latest

RUN apt-get update && \ 
    apt-get install -y autoconf make gcc ruby-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

WORKDIR /tests

ADD Gemfile* /tests/

RUN gem install bundler
RUN echo "install: --no-rdoc --no-ri" > ~/.gemrc
RUN bundle install

ADD . /tests

CMD ["cucumber"]