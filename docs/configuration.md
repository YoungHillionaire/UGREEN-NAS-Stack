# Configuration Guide

All settings live in `.env`. This file is listed in `.gitignore` and will never be committed — your secrets stay local.

```bash
cp .env.example .env
nano .env
```

---

## Variables

### `CONFIG_ROOT`
Where all app configs, databases, and logs are stored.
**Default:** `/volume1/docker/config`

> Back this up regularly. Losing it means reconfiguring everything from scratch.

### `DATA_ROOT`
Root of all media data. Must be a **single filesystem** so hardlinks work between `torrents/` and `media/`.
**Default:** `/volume1/data`

### `PUID` / `PGID`
The Linux user/group ID containers run as. Controls file permissions.

Find yours via SSH:
```bash
id your-username
# uid=1000(hussain) gid=10(admin)
# PUID=1000, PGID=10
```

### `TZ`
IANA timezone for all containers.
Full list: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

Examples: `Asia/Bahrain`, `Europe/London`, `America/New_York`

### `PIHOLE_PASSWORD`
Password for the Pi-hole admin UI at `http://NAS_IP:8053/admin`.

### `PLEX_CLAIM`
One-time token linking Plex to your account.
Get it at https://plex.tv/claim — **expires in 4 minutes**.
Grab it right before running `docker compose up` the first time.
After first launch you can clear this from `.env`.

### `TAILSCALE_AUTHKEY`
Auth key from your Tailscale admin panel:
https://login.tailscale.com/admin/settings/keys

**Use a reusable key** so the container re-authenticates after reboots without needing a new key.
