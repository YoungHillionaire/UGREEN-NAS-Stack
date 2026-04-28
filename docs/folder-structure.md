# Folder Structure

## Why It Matters

Sonarr and Radarr can **hardlink** files instead of copying them.
A hardlink is a second directory entry pointing to the same data on disk — instant, zero extra space used.

This only works if both the source (`torrents/`) and destination (`media/`) are on the **same filesystem**.
That's why everything lives under one `/volume1/data` root.

## The Layout

```
/volume1/
├── docker/
│   └── config/               ← app configs (back this up!)
│       ├── qbittorrent/
│       ├── prowlarr/
│       ├── sonarr/
│       ├── radarr/
│       ├── plex/
│       └── pihole/
└── data/
    ├── torrents/
    │   ├── movies/           ← qBittorrent saves here
    │   └── tv/               ← qBittorrent saves here
    └── media/
        ├── movies/           ← Radarr hardlinks here → Plex reads this
        └── tv/               ← Sonarr hardlinks here → Plex reads this
```

## How the Flow Works

```
Request → Radarr/Sonarr → Prowlarr finds release → qBittorrent downloads to /data/torrents/
       → Radarr/Sonarr hardlinks to /data/media/ → Plex sees it immediately
```

qBittorrent keeps seeding from `/data/torrents/`.
Plex serves from `/data/media/`.
Same file. Zero wasted space.

## Verifying Hardlinks Work

After your first download completes and gets imported, check in Radarr/Sonarr:
- **Activity → History** — should say **Hardlinked** not **Copied**

Or via SSH:
```bash
ls -la /volume1/data/torrents/movies/
# Link count should be 2 (one in torrents, one in media)
```
