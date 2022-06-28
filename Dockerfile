# Dockerfile.rails
FROM ruby:2.6.10

ENV BUNDLER_VERSION=2.3.16

RUN apk add --update --no-cache \
    binutils-gold \
    build-base \
    curl \
    file \
    g++ \
    gcc \
    git \
    less \
    libstdc++ \
    libffi-dev \
    libc-dev \ 
    linux-headers \
    libxml2-dev \
    libxslt-dev \
    libgcrypt-dev \
    make \
    netcat-openbsd \
    nodejs \
    openssl \
    pkgconfig \
    postgresql-dev \
    python \
    tzdata \
    yarn 

RUN gem install bundler -v 2.3.16

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY . ./ 

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]