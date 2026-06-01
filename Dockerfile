FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY book_cover_designer_flutter/build/web /usr/share/nginx/html

EXPOSE 80