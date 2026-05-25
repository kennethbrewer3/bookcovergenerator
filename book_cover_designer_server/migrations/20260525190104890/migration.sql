BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cover_size" (
    "id" bigserial PRIMARY KEY,
    "label" text NOT NULL,
    "width" bigint NOT NULL,
    "height" bigint NOT NULL,
    "sortOrder" bigint NOT NULL,
    "isActive" boolean NOT NULL
);

INSERT INTO "cover_size" ("label", "width", "height", "sortOrder", "isActive")
VALUES
    ('Amazon KDP Max — 6250 x 10000', 6250, 10000, 0, true),
    ('Amazon KDP Recommended — 1600 x 2560', 1600, 2560, 1, true),
    ('Amazon KDP Minimum — 625 x 1000', 625, 1000, 2, true),
    ('3:4 — 1800 x 2400', 1800, 2400, 3, true),
    ('3:4 — 1500 x 2000', 1500, 2000, 4, true),
    ('3:4 — 900 x 1200', 900, 1200, 5, true),
    ('3:4 — 768 x 1024', 768, 1024, 6, true),
    ('3:4 — 600 x 800', 600, 800, 7, true);


--
-- MIGRATION VERSION FOR book_cover_designer
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('book_cover_designer', '20260525190104890', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260525190104890', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
