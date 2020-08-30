FROM node:12.5.0-alpine

ENV LANG=C.UTF-8 \
  TZ=Asia/Tokyo

WORKDIR /app

RUN apk update && \
  apk upgrade && \
  npm install -g npm && \
  npm install -g @vue/cli && \
  npm install -g create-nuxt-app

ENV HOST 0.0.0.0
EXPOSE 3000
