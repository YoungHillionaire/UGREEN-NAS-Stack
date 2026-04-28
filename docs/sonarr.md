# Sonarr Setup

Sonarr automatically finds, downloads, and organizes TV shows.

## Authentication
1. Open `http://NAS_IP:8989`
2. **Settings → General → Authentication** — set username and password
3. Save

## Root Folder
1. **Settings → Media Management → Root Folders → Add**
2. Path: `/data/media/tv`

## Connect qBittorrent
**Settings → Download Clients → + Add → qBittorrent**

| Field | Value |
|---|---|
| Host | NAS IP |
| Port | `8080` |
| Username | `admin` |
| Password | your qBittorrent password |
| Category | `sonarr` |

Test → Save

## Indexers
**Settings → Indexers** — should already show indexers synced from Prowlarr.
If empty, go to Prowlarr → **Settings → Apps** → click Sonarr → **Sync**.

## Adding Shows
**Series → Add New** — search, set quality profile and root folder, add.
Sonarr will monitor and automatically grab new episodes as they air.
