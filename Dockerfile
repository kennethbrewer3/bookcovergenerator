# syntax=docker/dockerfile:1

FROM ghcr.io/cirruslabs/flutter:3.32.8 AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
COPY book_cover_designer_flutter/ book_cover_designer_flutter/

RUN flutter pub get

WORKDIR /app/book_cover_designer_flutter
RUN flutter build web --release

FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/book_cover_designer_flutter/build/web /usr/share/nginx/html

EXPOSE 80
