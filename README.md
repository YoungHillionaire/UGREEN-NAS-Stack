<div align="center">

# 🖥️ UGREEN NAS DXP2800 — Home Media Stack

**A fully automated self-hosted media server stack built on Docker Compose.**  
**Runs on UGREEN NAS DXP2800 with Intel QuickSync hardware transcoding.**

[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![TRaSH Guides](https://img.shields.io/badge/TRaSH-Guides-orange)](https://trash-guides.info)

</div>

---

## 📦 Stack

| Service | Purpose | Port |
|---|---|---|
| [Plex](https://plex.tv) | Media server | `32400` |
| [Sonarr](https://sonarr.tv) | TV show automation | `8989` |
| [Sonarr Anime](https://sonarr.tv) | Anime automation | `8990` |
| [Radarr](https://radarr.video) | Movie automation | `7878` |
| [Prowlarr](https://github.com/Prowlarr/Prowlarr) | Indexer manager | `9696` |
| [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr) | Cloudflare bypass | `8191` |
| [qBittorrent](https://www.qbittorrent.org) | Download client | `8080` |
| [Pi-hole](https://pi-hole.net) | Network-wide ad-blocker & DNS | `8053` |
| [Tailscale](https://tailscale.com) | Secure remote access VPN | — |

---

## 🗂️ Folder Structure

Built around the **TRaSH Guides hardlink-compatible layout**.
Everything lives under one `/data` root so Sonarr/Radarr can hardlink finished
downloads instantly — zero extra disk space, qBittorrent keeps seeding, Plex serves the file.

```
/volume1/
├── docker/
│   └── config/               ← All app configs & databases — BACK THIS UP
│       ├── qbittorrent/
│       ├── prowlarr/
│       ├── sonarr/
│       ├── radarr/
│       ├── plex/
│       └── pihole/
│           ├── etc-pihole/
│           └── etc-dnsmasq.d/
└── data/                     ← One volume = hardlinks work
    ├── torrents/
    │   ├── movies/           ← qBittorrent downloads here (category: radarr)
    │   ├── tv/               ← qBittorrent downloads here (category: sonarr)
│   └── anime/            ← qBittorrent downloads here (category: sonarr-anime)
    └── media/
        ├── movies/           ← Radarr hardlinks here → Plex reads this
        └── tv/               ← Sonarr hardlinks here → Plex reads this
```

---

## 🚀 Quick Start

### 1. Prerequisites
- UGREEN NAS DXP2800 running UGOS Pro
- Docker installed via UGOS App Center
- SSH access enabled
- A [Plex account](https://plex.tv)
- A [Tailscale account](https://tailscale.com) (free tier is fine)

### 2. Prepare Pi-hole — free port 53
```bash
sudo systemctl stop dnsmasq
sudo systemctl disable dnsmasq
```

### 3. Create shared folders in UGOS
In UGOS File Manager create two shared folders: `data` and `docker`

### 4. Clone the repo onto your NAS
```bash
ssh your-user@NAS_IP
cd /volume1
git clone https://github.com/YOUR_USERNAME/ugreen-nas-stack
cd ugreen-nas-stack
```

### 5. Create the folder structure
```bash
sudo make setup
```

### 6. Configure your environment
```bash
cp .env.example .env
nano .env
```

Fill in:
- `PUID` / `PGID` — run `id your-username`
- `PIHOLE_PASSWORD` — anything you want
- `TAILSCALE_AUTHKEY` — from [tailscale.com/admin/settings/keys](https://login.tailscale.com/admin/settings/keys)
- `PLEX_CLAIM` — from [plex.tv/claim](https://plex.tv/claim) right before launch

### 7. Launch
```bash
sudo docker compose up -d
sudo docker compose ps
```

---

## 🔗 Service URLs

| Service | URL |
|---|---|
| qBittorrent | `http://NAS_IP:8080` |
| Prowlarr | `http://NAS_IP:9696` |
| Sonarr | `http://NAS_IP:8989` |
| Sonarr Anime | `http://NAS_IP:8990` |
| Radarr | `http://NAS_IP:7878` |
| Plex | `http://NAS_IP:32400/web` |
| Pi-hole | `http://NAS_IP:8053/admin` |

> Once Tailscale is running, replace `NAS_IP` with your Tailscale IP to access everything remotely.

---

## 📚 Documentation

- [Configuration](docs/configuration.md) — all `.env` variables explained
- [Folder Structure](docs/folder-structure.md) — why hardlinks need one volume
- [Wiring the Stack](docs/wiring.md) — connecting all services together
- [qBittorrent Setup](docs/qbittorrent.md) — categories, paths, settings
- [Prowlarr & FlareSolverr](docs/prowlarr.md) — indexers and Cloudflare bypass
- [Sonarr Setup](docs/sonarr.md) — TV automation
- [Sonarr Anime Setup](docs/sonarr-anime.md) — Anime automation (separate instance)
- [Radarr Setup](docs/radarr.md) — movie automation
- [Plex Setup](docs/plex.md) — libraries and hardware transcoding
- [Pi-hole Setup](docs/pihole.md) — network ad-blocking and DHCP
- [Tailscale Setup](docs/tailscale.md) — secure remote access

---

## ⚙️ Useful Commands

```bash
sudo docker compose up -d            # start all containers
sudo docker compose down             # stop all containers
sudo docker compose ps               # check status
sudo docker compose logs -f          # live logs
sudo make pull                       # update all images + restart
```

---

## 📄 License

MIT
