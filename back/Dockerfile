FROM ruby:2.5

ENV LANG=C.UTF-8 \
  TZ=Asia/Tokyo

WORKDIR /app

RUN apt-get update -qq && \
  apt-get install -y nodejs default-mysql-client

COPY app/Gemfile /app/Gemfile
COPY app/Gemfile.lock /app/Gemfile.lock
RUN bundle install
