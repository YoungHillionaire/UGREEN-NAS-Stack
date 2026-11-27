# Unraid — Six-Service Media Stack

A separate Unraid deployment for this repository. It contains only Plex, Sonarr, Radarr, Prowlarr, Seerr and qBittorrent. The root UGREEN NAS Compose configuration is left unchanged.

## Folder layout

Create Unraid user shares named appdata and data. The Compose defaults are:

    /mnt/user/appdata/{plex,prowlarr,qbittorrent,radarr,seerr,sonarr}
    /mnt/user/data/torrents/{movies,tv}
    /mnt/user/data/media/{movies,tv}

Keep downloads and the media library under the same /data mount so imports can use hardlinks, provided the underlying filesystem/share supports them.

## Configure

Copy .env.example to .env in this directory and adjust APPDATA_ROOT, DATA_ROOT, PUID, PGID and TZ. PUID=99 and PGID=100 are common Unraid defaults; verify that they have read/write access to both shares. PLEX_CLAIM is optional and can be generated at https://plex.tv/claim immediately before first launch.

Do not commit your real .env file or Plex claim token.

## Deploy

In Unraid, use Docker Compose Manager to create a project from this directory's docker-compose.yml and .env, then start it. Alternatively, from a terminal:

    cd /path/to/UGREEN-NAS-Stack/unraid
    cp .env.example .env
    # Edit .env
    docker compose up -d
    docker compose ps

## Web interfaces

| App | URL |
|---|---|
| qBittorrent | http://UNRAID_IP:8080 |
| Prowlarr | http://UNRAID_IP:9696 |
| Sonarr | http://UNRAID_IP:8989 |
| Radarr | http://UNRAID_IP:7878 |
| Seerr | http://UNRAID_IP:5055 |
| Plex | http://UNRAID_IP:32400/web |

Replace UNRAID_IP with the server's LAN IP.

## Connect the apps

- Sonarr/Radarr to qBittorrent: host qbittorrent, port 8080.
- Sonarr download category: tv, path /data/torrents/tv; root folder /data/media/tv.
- Radarr download category: movies, path /data/torrents/movies; root folder /data/media/movies.
- Prowlarr connects to Sonarr at sonarr:8989 and Radarr at radarr:7878.
- Seerr connects to Plex, Sonarr and Radarr using their Compose service names and internal ports.
- All containers that handle downloads or media share the same /data paths. Remote Path Mappings should not be needed when paths match.

## Plex hardware transcoding

The /dev/dri mapping is commented out so the stack can start on Unraid systems without an exposed GPU device. If /dev/dri exists on your server, uncomment the mapping under Plex and enable hardware transcoding in Plex settings.

## Notes

- Review share permissions, port conflicts and paths before deployment.
- Keep qBittorrent Web UI private to your LAN; do not expose it directly to the public internet.
- Images use latest tags to match the parent repository style. Pin versions after validating the deployment.