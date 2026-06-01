FROM ghcr.io/cirruslabs/flutter:latest AS flutter_build

WORKDIR /app

COPY . .

WORKDIR /app/book_cover_designer_flutter

RUN flutter pub get

RUN dart run build_runner build

RUN flutter build web \
    --base-href / \
    --release

FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=flutter_build /app/book_cover_designer_flutter/build/web /usr/share/nginx/html

EXPOSE 80