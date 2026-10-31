# Folder Structure

## Why It Matters

Sonarr and Radarr can create hardlinks instead of copying completed downloads into the media library. A hardlink is another directory entry for the same file data, so it is fast and does not consume a second copy of the file's storage.

Hardlinks require the source and destination to be on the same filesystem. This repository keeps downloads and media under one `DATA_ROOT`.

## Default Layout

```
/volume1/
├── docker/
│   └── config/               ← application configs and databases
│       ├── qbittorrent/
│       ├── prowlarr/
│       ├── sonarr/
│       ├── sonarr-anime/
│       ├── radarr/
│       ├── plex/
│       ├── jellyfin/
│       ├── bazarr/
│       └── pihole/
└── data/
    ├── torrents/
    │   ├── movies/           ← qBittorrent category: radarr
    │   ├── tv/               ← qBittorrent category: sonarr
    │   └── anime/            ← qBittorrent category: sonarr-anime
    └── media/
        ├── movies/           ← Radarr library
        ├── tv/               ← Sonarr library
        └── anime/            ← Sonarr Anime library
```

## Container Paths

The NAS host paths are mapped into containers:

| Host path | Container path | Used by |
|---|---|---|
| `${DATA_ROOT}/torrents` | `/data/torrents` | qBittorrent |
| `${DATA_ROOT}` | `/data` | Sonarr, Sonarr Anime, Radarr |
| `${DATA_ROOT}/media` | `/data/media` | Plex, Jellyfin, Bazarr |

Use container paths in application settings. Do not enter a host path such as `/volume1/data/...` into an app unless that exact path is also mounted inside that container.

## How the Flow Works

```
Request → Sonarr/Radarr → Prowlarr finds release
       → qBittorrent downloads to /data/torrents/
       → Sonarr/Radarr imports to /data/media/
       → Plex/Jellyfin scans the library
```

qBittorrent continues seeding from the torrent directory while the media server reads from the library directory.

## Verify Hardlinks

After an import, check the app's history/event details for a hardlink indication. It may say copied instead if hardlinks were not possible.

On the NAS, compare the link count for the torrent file and imported library file. A link count of at least 2 can indicate a hardlink, but confirm both paths refer to the same inode on the same filesystem.

```bash
ls -li /volume1/data/torrents/movies/
ls -li /volume1/data/media/movies/
```

If the link count remains 1, check that both directories are on the same filesystem, that the *arr container sees both paths through a common mount, and that the download client reports the expected path.
