FROM ghcr.io/cirruslabs/flutter:3.32.0 AS flutter_build
WORKDIR /app

COPY . .

RUN cd book_cover_designer_flutter && flutter pub get

RUN cd book_cover_designer_flutter && \
    flutter build web \
      --base-href /app/ \
      --wasm \
      --output ../book_cover_designer_server/web/app

FROM ghcr.io/cirruslabs/flutter:3.32.0 AS server_build
WORKDIR /app

COPY . .

COPY --from=flutter_build /app/book_cover_designer_server/web/app book_cover_designer_server/web/app

WORKDIR /app/book_cover_designer_server

RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

FROM dart:3.8.0

ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

WORKDIR /app

COPY --from=server_build /app/book_cover_designer_server/bin/server ./server
COPY --from=server_build /app/book_cover_designer_server/config ./config
COPY --from=server_build /app/book_cover_designer_server/web ./web
COPY --from=server_build /app/book_cover_designer_server/migrations ./migrations
COPY --from=server_build /app/book_cover_designer_server/lib/src/generated/protocol.yaml ./lib/src/generated/protocol.yaml

RUN chmod +x ./server

EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

ENTRYPOINT ["./server"]
CMD ["--mode=production", "--server-id=default", "--logging=normal", "--role=monolith"]