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

The simplest way to run the app is to pull the pre-built web assets and serve them via the included nginx container.

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed
- Flutter web build output already present at `book_cover_designer_flutter/build/web/`
  (see [Building the web assets](#building-the-web-assets) below if you need to build first)

### Start the container

```bash
docker compose up -d
```

The app will be available at **http://localhost:53589**.

### Stop the container

```bash
docker compose down
```

### Rebuild after a code change

```bash
# 1. Build fresh web assets (see below)
# 2. Rebuild the Docker image and restart
docker compose up -d --build
```

---

## Building the web assets

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
│   └── build/web/                 # Generated web output (git-ignored except for Docker)
├── Dockerfile                     # nginx image serving the web build
├── docker-compose.yaml            # Single-service compose config (port 53589)
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
