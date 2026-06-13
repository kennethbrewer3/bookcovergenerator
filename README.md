# Book Cover Designer

A Flutter web application for designing ebook covers. Compose rich-text titles, author names, subtitles, taglines, series titles, edition lines, and corner badges on a configurable canvas. Customize colors, layout, background images, and export the finished cover as a PNG.

## Features

- **Rich text editor** (Quill) for each text layer — bold, italic, font size, sub/superscript
- **Multiple cover layouts** — Modern (big centred title), Top/Bottom, Top/Centre
- **Background images** — pick an image, control scale, alignment, blend mode, and opacity
- **Per-element colour pickers** — text, box fill, and border colours for every layer
- **Corner badge** — configurable position (top-left, top-right, bottom-left, bottom-right)
- **Cover size presets** — Amazon KDP and common ebook ratios
- **UI themes** — Light, Dark, Military Light, Military Dark (persisted across sessions)
- **Internationalisation** — English, Spanish, and French (persisted across sessions)
- **PNG export** — save the generated cover directly from the browser

---

## Running with Docker Compose

The app is published as a pre-built container image. You do **not** need Flutter installed locally.

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed

### Pull and run

The repository includes a `docker-compose.yaml` that pulls the latest image from GitHub Container Registry:

```bash
git clone https://github.com/kennethbrewer3/bookcovergenerator.git
cd bookcovergenerator
docker compose pull
docker compose up -d
```

The app will be available at **http://localhost:53589**.

### Stop the container

```bash
docker compose down
```

### Minimal compose file (without cloning the repo)

```yaml
services:
  book-cover-designer:
    image: ghcr.io/kennethbrewer3/bookcovergenerator:latest
    ports:
      - "53589:80"
    restart: unless-stopped
```

Save as `docker-compose.yaml`, then run `docker compose up -d`.

> **Note:** The GHCR package must be **public** for anonymous pulls. In GitHub, open **Packages → bookcovergenerator → Package settings → Change visibility → Public**.

---

## Publishing the Docker image (maintainers)

Pushes to `main` (and version tags like `v1.0.0`) trigger the [Publish Docker image](.github/workflows/docker-publish.yml) workflow, which builds the Flutter web app inside Docker and pushes to:

`ghcr.io/kennethbrewer3/bookcovergenerator:latest`

### Build locally

```bash
docker build -t ghcr.io/kennethbrewer3/bookcovergenerator:local .
docker run --rm -p 53589:80 ghcr.io/kennethbrewer3/bookcovergenerator:local
```

Or use the build override compose file:

```bash
docker compose -f docker-compose.yaml -f docker-compose.build.yaml up -d --build
```

---

## Building the web assets (without Docker)

You need the [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel) with web support enabled.

```bash
# Enable web if you haven't already
flutter config --enable-web

# Install dependencies
cd book_cover_designer_flutter
flutter pub get

# Build a release web bundle
flutter build web --release
```

The output lands in `book_cover_designer_flutter/build/web/`, which is what the Dockerfile copies into the nginx image.

---

## Running locally (without Docker)

```bash
cd book_cover_designer_flutter
flutter pub get
flutter run -d chrome
```

To persist UI settings (theme and language) across debug sessions, use the fixed Chrome profile flag:

```bash
flutter run -d chrome --web-browser-flag "--user-data-dir=/tmp/flutter-chrome-dev-profile"
```

This is pre-configured in `.vscode/launch.json` if you use VS Code.

---

## Project structure

```
book_cover_designer/
├── book_cover_designer_flutter/   # Flutter web application
│   ├── lib/
│   │   ├── l10n/                  # ARB translation files (en, es, fr)
│   │   ├── models/                # Data models (Freezed)
│   │   ├── screens/home/          # Main UI view, viewmodel, and widgets
│   │   ├── services/              # Cover generation, theme, and locale services
│   │   └── ui/theme/              # AppTheme, colour palettes, text styles
│   └── assets/                    # Config and bundled fonts
│   └── build/web/                 # Generated web output (local dev; built in Docker for releases)
├── Dockerfile                     # Multi-stage build (Flutter web + nginx)
├── docker-compose.yaml            # Pull pre-built image (port 53589)
├── docker-compose.build.yaml      # Optional local build override
└── nginx.conf                     # nginx site config with Flutter web routing
```

---

## Tech stack

| Layer | Technology |
|---|---|
| UI framework | Flutter (web) |
| State management | Stacked (MVVM) |
| Rich text | flutter_quill |
| Theming | Material 3 / custom palettes |
| Localisation | Flutter gen-l10n (ARB) |
| Persistence | shared_preferences |
| Image export | Custom Canvas / dart:ui |
| Web server | nginx 1.27 (Alpine) |
| Container | Docker Compose |
