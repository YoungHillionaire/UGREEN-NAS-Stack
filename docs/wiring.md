# Wiring the Stack

After all containers are up, connect them in this order:

```
qBittorrent → Prowlarr → Sonarr & Radarr → Plex
```

---

## The Full Flow

```
You search in Radarr/Sonarr
  → Prowlarr finds a release on your indexers
    → qBittorrent downloads it to /data/torrents/movies or /data/torrents/tv
      → Radarr/Sonarr hardlinks it to /data/media/movies or /data/media/tv
        → Plex sees it and adds it to your library
```

---

## Step 1 — qBittorrent
- Change default password
- Create categories: `radarr` → `/data/torrents/movies`, `sonarr` → `/data/torrents/tv`
- Enable **Use Category paths in Manual Mode**

See [qBittorrent Setup](qbittorrent.md)

---

## Step 2 — Prowlarr
- Add FlareSolverr at `http://flaresolverr:8191`
- Add your indexers
- Connect to Sonarr and Radarr using their API keys

See [Prowlarr & FlareSolverr](prowlarr.md)

---

## Step 3 — Sonarr
- Set root folder: `/data/media/tv`
- Add qBittorrent as download client with category `sonarr`
- Verify indexers synced from Prowlarr

See [Sonarr Setup](sonarr.md)

---

## Step 4 — Radarr
- Set root folder: `/data/media/movies`
- Add qBittorrent as download client with category `radarr`
- Verify indexers synced from Prowlarr

See [Radarr Setup](radarr.md)

---

## Step 5 — Plex
- Add libraries pointing to `/data/media/movies` and `/data/media/tv`
- Enable hardware transcoding

See [Plex Setup](plex.md)

---

## Step 6 — Pi-hole
- Disable NAS built-in DNS first
- Set router DNS to NAS IP

See [Pi-hole Setup](pihole.md)

---

## Verify Everything Works

1. Go to Radarr → search for a movie → Add → Search
2. Watch **Activity → Queue** — should show downloading
3. Check qBittorrent — torrent should appear under `radarr` category in `/data/torrents/movies`
4. When complete, check Radarr **Activity → History** — should say **Hardlinked**
5. Check Plex — movie should appear in your Movies library
