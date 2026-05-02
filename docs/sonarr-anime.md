# Sonarr Anime Setup

A dedicated Sonarr instance just for anime — separate library, separate quality
profiles, same hardlink setup.

---

## Why a Separate Instance?

- Anime has different naming conventions (e.g. absolute episode numbers)
- Different quality preferences (1080p WEB vs Blu-ray)
- Keeps your anime completely separate from regular TV in Plex
- Both instances share the same `/data` mount so hardlinks still work

---

## Folder Structure

```
/volume1/data/
├── torrents/
│   └── anime/           ← qBittorrent downloads here (category: sonarr-anime)
└── media/
    └── anime/           ← Sonarr Anime hardlinks here → Plex reads this
```

---

## Create the Folders

```bash
mkdir -p /volume1/data/torrents/anime
mkdir -p /volume1/data/media/anime
mkdir -p /volume1/docker/config/sonarr-anime
```

Or just run `sudo make setup` — it handles all of this.

---

## qBittorrent — Add Anime Category

1. Open qBittorrent `http://NAS_IP:8080`
2. Left sidebar → right-click **Categories → Add Category**
3. Name: `sonarr-anime`
4. Save Path: `/data/torrents/anime`
5. Hit OK

---

## Sonarr Anime Setup

Open `http://NAS_IP:8990`

### Authentication
**Settings → General → Authentication** — set username and password

### Root Folder
**Settings → Media Management → Root Folders → Add**
Path: `/data/media/anime`

### Connect qBittorrent
**Settings → Download Clients → + Add → qBittorrent**

| Field | Value |
|---|---|
| Host | NAS IP |
| Port | `8080` |
| Username | `admin` |
| Password | your qBittorrent password |
| Category | `sonarr-anime` |

Test → Save

### Anime-Specific Settings
**Settings → Media Management**
- Series Folder Format: `{Series TitleYear} [imdbid-{ImdbId}]`
- Enable **Rename Episodes**
- Standard Episode Format: `{Series Title} - S{season:00}E{episode:00} - {Episode Title}`

### Quality Profile
For anime, a good starting profile:
1. **Settings → Profiles → Add**
2. Name: `Anime-1080p`
3. Enable: `Bluray-1080p`, `WEBRip-1080p`, `WEBDL-1080p`
4. Save

---

## Connect to Prowlarr

In Prowlarr → **Settings → Apps → + Add Application → Sonarr**

| Field | Value |
|---|---|
| Name | Sonarr Anime |
| Prowlarr Server | `http://prowlarr:9696` |
| Sonarr Server | `http://sonarr-anime:8989` |
| API Key | From Sonarr Anime → Settings → General |

Test → Save

Add anime-specific indexers in Prowlarr (e.g. **Nyaa**, **AniDex**) — these will
sync to Sonarr Anime automatically.

---

## Plex — Add Anime Library

1. Plex → **Settings → Libraries → Add Library**
2. Choose **TV Shows**
3. Name it `Anime`
4. Add folder: `/data/media/anime`
5. Save

Plex will keep anime completely separate from your regular TV library.
