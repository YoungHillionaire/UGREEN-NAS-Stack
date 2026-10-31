<div align="center">

# 🖥️ UGREEN NAS DXP2800 — Home Media Stack

**A self-hosted media server stack built on Docker Compose.**  
**Designed for UGREEN NAS DXP2800 with Intel QuickSync hardware transcoding.**

[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![TRaSH Guides](https://img.shields.io/badge/TRaSH-Guides-orange)](https://trash-guides.info)

</div>

---

## 📦 Stack

| Service | Purpose | Port |
|---|---|---|
| [Plex](https://plex.tv) | Media server | `32400` (host network) |
| [Jellyfin](https://jellyfin.org) | Free open-source media server | `8096` |
| [Sonarr](https://sonarr.tv) | TV show automation | `8989` |
| [Sonarr Anime](https://sonarr.tv) | Separate anime automation instance | `8990` |
| [Radarr](https://radarr.video) | Movie automation | `7878` |
| [Prowlarr](https://github.com/Prowlarr/Prowlarr) | Indexer manager | `9696` |
| [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr) | Browser challenge helper for supported indexers | `8191` |
| [qBittorrent](https://www.qbittorrent.org) | Download client | `8080` |
| [Pi-hole](https://pi-hole.net) | Network-wide ad blocker and DNS | `8053` |
| [Bazarr](https://bazarr.media) | Subtitle manager | `6767` |
| [Cloudflare Tunnel](https://cloudflare.com) | Optional public access through an outbound tunnel | — |
| [Tailscale](https://tailscale.com) | Private remote access VPN | — |

---

## 🗂️ Folder Structure

The stack uses a single data root for downloads and media. Keeping both on the same filesystem allows Sonarr and Radarr to create hardlinks instead of copying files.

```
/volume1/
├── docker/
│   └── config/               ← App configs and databases — BACK THIS UP
│       ├── qbittorrent/
│       ├── prowlarr/
│       ├── sonarr/
│       ├── sonarr-anime/
│       ├── radarr/
│       ├── plex/
│       ├── jellyfin/
│       ├── bazarr/
│       └── pihole/
└── data/                     ← Keep torrents and media on one filesystem
    ├── torrents/
    │   ├── movies/           ← qBittorrent category: radarr
    │   ├── tv/               ← qBittorrent category: sonarr
    │   └── anime/            ← qBittorrent category: sonarr-anime
    └── media/
        ├── movies/           ← Radarr library
        ├── tv/               ← Sonarr library
        └── anime/            ← Sonarr Anime library
```

Container paths are deliberately consistent: qBittorrent sees downloads under `/data/torrents`; the *arr apps see the shared data root under `/data`.

---

## 🚀 Quick Start

> **For a new installation only.** If this stack is already running, do not overwrite your existing Compose file, app databases, download paths, or Tailscale state. Read [Existing installations and safety checks](docs/configuration.md#existing-installations-and-safety-checks) first.

### 1. Prerequisites
- UGREEN NAS DXP2800 running UGOS Pro
- Docker / Docker Compose installed through UGOS
- SSH access enabled
- A [Plex account](https://plex.tv)
- A [Tailscale account](https://tailscale.com) if you want private remote access

### 2. Create shared folders in UGOS
Create the `docker` and `data` shared folders. Confirm that they are on the intended storage volume.

### 3. Clone the repository
SSH into the NAS and clone the repository into the Docker shared folder:

```bash
ssh your-user@NAS_IP
cd /volume1/docker
git clone https://github.com/YoungHillionaire/UGREEN-NAS-Stack.git
cd UGREEN-NAS-Stack
```

If your shared folder is on a different volume, adjust the paths in the next step and in `.env`.

### 4. Configure the environment
```bash
cp .env.example .env
nano .env
```

Set at least:
- `CONFIG_ROOT` and `DATA_ROOT` to the actual shared-folder paths
- `PUID` and `PGID` from `id your-username`
- `PIHOLE_PASSWORD` to a strong password
- `TAILSCALE_AUTHKEY` if using Tailscale
- `CLOUDFLARE_TUNNEL_TOKEN` if using a named Cloudflare Tunnel
- `PLEX_CLAIM` immediately before first launch, if needed

Keep `.env` private. Never commit it or paste its secrets into issues or screenshots.

### 5. Create the folders
```bash
sudo make setup
```

The Makefile reads `.env` and uses `CONFIG_ROOT` and `DATA_ROOT`. Review those paths before running it.

### 6. Review host networking before starting Pi-hole
Pi-hole uses host networking and needs port 53. Do **not** blindly stop or disable UGOS services such as `dnsmasq`. First identify what is listening on port 53 and confirm that disabling it will not affect NAS name resolution, DHCP, or other UGOS features. See [Pi-hole setup](docs/pihole.md).

### 7. Review and launch
```bash
sudo docker compose config
sudo docker compose up -d
sudo docker compose ps
```

Inspect the rendered configuration for missing variables and unexpected paths before launching. Start with the services you have configured; do not expose admin interfaces publicly by default.

---

## 🔗 Local Service URLs

| Service | URL |
|---|---|
| qBittorrent | `http://NAS_IP:8080` |
| Prowlarr | `http://NAS_IP:9696` |
| Sonarr | `http://NAS_IP:8989` |
| Sonarr Anime | `http://NAS_IP:8990` |
| Radarr | `http://NAS_IP:7878` |
| Plex | `http://NAS_IP:32400/web` |
| Jellyfin | `http://NAS_IP:8096` |
| Pi-hole | `http://NAS_IP:8053/admin` |
| Bazarr | `http://NAS_IP:6767` |

Use your NAS LAN address locally. For remote access, prefer Tailscale; see its guide. A public tunnel is optional and should be limited to the services and users you actually intend to expose.

---

## 📚 Documentation

- [Configuration](docs/configuration.md) — environment variables and existing-install safety
- [Folder Structure](docs/folder-structure.md) — hardlinks and paths
- [Wiring the Stack](docs/wiring.md) — service connections and test flow
- [qBittorrent Setup](docs/qbittorrent.md) — categories, paths, and settings
- [Prowlarr & FlareSolverr](docs/prowlarr.md) — indexers and app connections
- [Sonarr Setup](docs/sonarr.md) — TV automation
- [Sonarr Anime Setup](docs/sonarr-anime.md) — separate anime instance
- [Radarr Setup](docs/radarr.md) — movie automation
- [Plex Setup](docs/plex.md)
- [Jellyfin Setup](docs/jellyfin.md)
- [Bazarr Setup](docs/bazarr.md)
- [Pi-hole Setup](docs/pihole.md) — DNS, host networking, and port 53 precautions
- [Tailscale Setup](docs/tailscale.md) — private remote access
- [Cloudflare Tunnel](docs/cloudflare-tunnel.md) — named tunnels and temporary quick tunnels

---

## ⚙️ Useful Commands

Run these from the directory containing `docker-compose.yml`:

```bash
sudo docker compose config           # validate and render configuration
sudo docker compose up -d            # start or recreate configured containers
sudo docker compose ps               # check status
sudo docker compose logs -f          # follow logs
sudo docker compose pull             # download newer images only
sudo docker compose up -d            # apply pulled images (review first)
sudo docker compose down             # stop and remove containers; data volumes remain
```

Updating images can change application behaviour, especially when an image uses the `:latest` tag. Back up app configuration and review release notes before applying updates.

---

## 📄 License

MIT
