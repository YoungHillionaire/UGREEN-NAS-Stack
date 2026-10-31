# Wiring the Stack

This guide connects the services after the containers have been configured. It describes the default paths in this repository; existing installations may use different working paths.

## The Full Flow

```
Sonarr / Sonarr Anime / Radarr
  → Prowlarr supplies indexers
  → the *arr app sends a release to qBittorrent
  → qBittorrent downloads under /data/torrents
  → the *arr app imports or hardlinks into /data/media
  → Plex and Jellyfin scan the media library
```

All containers that need to access downloads and media must see compatible paths. In this Compose file, qBittorrent mounts the torrent directory at `/data/torrents`, while the *arr apps mount the full data root at `/data`.

## Step 1 — qBittorrent

- Change the temporary WebUI password.
- Create categories:
  - `radarr` → `/data/torrents/movies`
  - `sonarr` → `/data/torrents/tv`
  - `sonarr-anime` → `/data/torrents/anime`
- Confirm the save paths exist inside the qBittorrent container.

See [qBittorrent Setup](qbittorrent.md).

## Step 2 — Prowlarr

1. Open Prowlarr at `http://NAS_IP:9696`.
2. Add your indexers.
3. If a supported indexer requires FlareSolverr, configure its application URL as `http://flaresolverr:8191`.
4. Under **Settings → Apps**, add Sonarr, Sonarr Anime, and Radarr as separate applications.

Use the internal Docker service names and container ports for app-to-app communication:

| Application | URL from Prowlarr |
|---|---|
| Sonarr | `http://sonarr:8989` |
| Sonarr Anime | `http://sonarr-anime:8989` |
| Radarr | `http://radarr:7878` |

Enter each application's API key from its **Settings → General** page. Test and save each connection.

See [Prowlarr & FlareSolverr](prowlarr.md).

## Step 3 — Sonarr

- Root folder: `/data/media/tv`
- qBittorrent host: `qbittorrent` (or NAS IP if using the published host port)
- qBittorrent port: `8080`
- Category: `sonarr`

See [Sonarr Setup](sonarr.md).

## Step 4 — Sonarr Anime

- Root folder: `/data/media/anime`
- qBittorrent category: `sonarr-anime`
- Prowlarr application entry: `http://sonarr-anime:8989`

See [Sonarr Anime Setup](sonarr-anime.md).

## Step 5 — Radarr

- Root folder: `/data/media/movies`
- qBittorrent category: `radarr`

See [Radarr Setup](radarr.md).

## Step 6 — Plex and Jellyfin

Add libraries using the paths inside each media-server container:

- Movies: `/data/media/movies`
- TV: `/data/media/tv`
- Anime: `/data/media/anime`

See [Plex](plex.md) and [Jellyfin](jellyfin.md).

## Step 7 — Bazarr

Connect Bazarr to Sonarr and Radarr using their API keys. Add Sonarr Anime as a second Sonarr connection if your Bazarr version supports the additional instance. Keep the paths consistent with the media mounts shown in Compose.

See [Bazarr Setup](bazarr.md).

## Step 8 — Pi-hole and remote access

Pi-hole uses host networking and requires careful port-53 planning. Do not disable UGOS DNS services without confirming what depends on them. For remote access, Tailscale is the private-access option. Treat Cloudflare Tunnel as an optional, explicitly configured public entry point.

See [Pi-hole](pihole.md), [Tailscale](tailscale.md), and [Cloudflare Tunnel](cloudflare-tunnel.md).

## Verify the End-to-End Flow

1. Use one test item in Radarr or Sonarr.
2. Confirm the release is sent to the expected qBittorrent category.
3. Confirm the download completes in the expected torrent directory.
4. Confirm the app imports it into the matching media root.
5. Check the app's history/event details to see whether it hardlinked or copied.
6. Confirm Plex or Jellyfin can see the imported media.

A successful import does not always mean a hardlink was created. If hardlinking matters, confirm both paths are on the same filesystem and inspect the link count on the NAS.
