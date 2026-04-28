# Radarr Setup

Radarr automatically finds, downloads, and organizes movies.

## Authentication
1. Open `http://NAS_IP:7878`
2. **Settings → General → Authentication** — set username and password
3. Save

## Root Folder
1. **Settings → Media Management → Root Folders → Add**
2. Path: `/data/media/movies`

## Connect qBittorrent
**Settings → Download Clients → + Add → qBittorrent**

| Field | Value |
|---|---|
| Host | NAS IP |
| Port | `8080` |
| Username | `admin` |
| Password | your qBittorrent password |
| Category | `radarr` |

Test → Save

## Indexers
**Settings → Indexers** — should already show indexers synced from Prowlarr.
If empty, go to Prowlarr → **Settings → Apps** → click Radarr → **Sync**.

## Quality Profiles
For 4K movies, create a custom profile:
1. **Settings → Profiles → Add Profile**
2. Name: `4K`
3. Enable: `Bluray-2160p`, `WEBRip-2160p`, `WEBDL-2160p`
4. Save

## Adding Movies
**Movies → Add New** — search, choose quality profile and root folder, add.
Click the movie → **Search** to grab it immediately.
