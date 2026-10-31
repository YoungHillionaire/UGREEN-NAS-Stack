# Sonarr Anime Setup

A dedicated Sonarr instance for anime, with its own configuration, quality profiles, and library. It shares the same data mount as the main Sonarr and Radarr instances so hardlinks remain possible.

## Folder Structure

```
/volume1/data/
├── torrents/
│   └── anime/           ← qBittorrent category: sonarr-anime
└── media/
    └── anime/           ← Sonarr Anime library
```

Inside the containers, these paths are `/data/torrents/anime` and `/data/media/anime`.

## Create the Folders

From the repository directory, after configuring `.env`:

```bash
sudo make setup
```

Or create the folders manually using the values of `DATA_ROOT` and `CONFIG_ROOT` in `.env`.

## qBittorrent Category

In qBittorrent, add a category:

- Name: `sonarr-anime`
- Save path: `/data/torrents/anime`

See [qBittorrent Setup](qbittorrent.md) for the other categories and path checks.

## Sonarr Anime Setup

Open `http://NAS_IP:8990`.

### Authentication
Under **Settings → General → Authentication**, configure authentication.

### Root Folder
Under **Settings → Media Management → Root Folders**, add:

`/data/media/anime`

### Connect qBittorrent

Under **Settings → Download Clients → + Add → qBittorrent**:

| Field | Value |
|---|---|
| Host | NAS IP or reachable qBittorrent hostname |
| Port | `8080` |
| Username | Your qBittorrent username |
| Password | Your qBittorrent password |
| Category | `sonarr-anime` |

Test and save. Use the same category name as qBittorrent.

### Anime Naming and Quality

Choose naming and quality settings that match your release sources and library. Absolute episode numbering and season/episode numbering are not interchangeable for every anime series; verify the series type and episode mapping before enabling automatic renaming.

The example quality profile in older versions of this guide is only a starting point. Review current quality definitions and custom formats rather than assuming a profile fits every anime release group.

## Connect to Prowlarr

In Prowlarr, go to **Settings → Apps → + Add Application → Sonarr**.

| Field | Value |
|---|---|
| Name | Sonarr Anime |
| Prowlarr URL | `http://prowlarr:9696` |
| Sonarr URL | `http://sonarr-anime:8989` |
| API Key | Sonarr Anime → Settings → General |

Test and save. Add only indexers you are entitled to use and that are appropriate for your content.

## Plex or Jellyfin Library

Add a TV Shows library named `Anime` and point it to:

`/data/media/anime`

The media-server container sees the same path because Compose mounts `${DATA_ROOT}/media` at `/data/media`.
