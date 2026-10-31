# qBittorrent Setup

qBittorrent is the download client used by Sonarr, Sonarr Anime, and Radarr.

## First Login

On a fresh LinuxServer.io container, check the logs for the temporary WebUI password:

```bash
sudo docker logs qbittorrent
```

Look for the temporary password message, then log in at `http://NAS_IP:8080` with username `admin`.

## Change the Password

In qBittorrent, open **Tools → Options → WebUI** and set a strong password. Store it in your password manager.

## Download Settings

Open **Tools → Options → Downloads**.

| Setting | Suggested value |
|---|---|
| Default Save Path | `/data/torrents` |
| Default Torrent Management Mode | Automatic (recommended starting point) |

The container maps the NAS torrent directory to `/data/torrents`. Do not enter a host path such as `/volume1/data/torrents` inside qBittorrent.

## Create Categories

In the left sidebar, right-click **Categories → Add Category**. Create these categories and paths:

| Category | Save path inside qBittorrent |
|---|---|
| `radarr` | `/data/torrents/movies` |
| `sonarr` | `/data/torrents/tv` |
| `sonarr-anime` | `/data/torrents/anime` |

Use the matching category in the corresponding app's qBittorrent download-client settings. Category save paths and torrent-management mode interact; test with one non-critical download before changing an established setup.

## Connection Port

Under **Tools → Options → Connection**, use listening port `6881` if it matches the Compose mapping. The container publishes TCP and UDP port 6881.

## Verify the Paths

After creating a test download, check that it appears in the expected category and folder in qBittorrent. Then confirm that the same path is visible to the relevant *arr container under `/data`.

> **Existing installations:** Do not change the default save path or category paths just to match this guide if your downloads are already working. First compare your current Compose volume mounts with qBittorrent's actual save paths. A path must exist inside the container, not merely on the NAS.
