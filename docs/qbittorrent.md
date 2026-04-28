# qBittorrent Setup

## First Login

Default credentials on first launch — check logs for temporary password:
```bash
sudo docker logs qbittorrent
# Look for: "A temporary password is provided for this session: XXXXXXXX"
```

Login at `http://NAS_IP:8080` with `admin` + the temporary password.

## Change the Password

**Tools → Options → WebUI → Password** — change it immediately.

## Download Settings

**Tools → Options → Downloads → Saving Management**

| Setting | Value |
|---|---|
| Default Torrent Management Mode | Automatic |
| Default Save Path | `/data/torrents` |
| Use Category paths in Manual Mode | ✅ Checked |

> **Important:** "Use Category paths in Manual Mode" must be checked or downloads will ignore category paths and dump everything in `/data/torrents`.

## Create Categories

In the left sidebar, right-click **Categories → Add Category**:

| Category Name | Save Path |
|---|---|
| `radarr` | `/data/torrents/movies` |
| `sonarr` | `/data/torrents/tv` |

## Connection Port

**Tools → Options → Connection**
- Listening port: `6881`

Save everything and you're done.
