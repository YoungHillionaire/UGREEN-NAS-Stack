# Configuration Guide

All local settings live in `.env`. This file is ignored by Git and must remain private.

For a new installation:

```bash
cp .env.example .env
nano .env
```

Review every path and secret before starting containers.

## Variables

### `CONFIG_ROOT`

Where application configs, databases, and logs are stored.

**Default:** `/volume1/docker/config`

Back this directory up regularly. Losing it may mean losing application databases, settings, API keys, and server identities.

### `DATA_ROOT`

Root of all media data.

**Default:** `/volume1/data`

The torrent and media directories should be on the same filesystem if you want Sonarr/Radarr hardlinks rather than copies.

### `PUID` / `PGID`

The Linux user/group IDs used by LinuxServer.io containers for file access.

Find them over SSH:

```bash
id your-username
```

Use the numeric UID and GID for the account that should own/manage the media files. Do not assume the example values match your NAS.

### `TZ`

IANA timezone used by the containers.

Example: `Asia/Bahrain`.

### `PIHOLE_PASSWORD`

Pi-hole web interface password for a new configuration. The current Compose file uses a legacy Pi-hole variable name; see [Pi-hole v6 notes](pihole.md#2-pi-hole-v6-environment-variables) before relying on this value with Pi-hole v6.

### `PLEX_CLAIM`

One-time token used when initially claiming a Plex server. Get it from [plex.tv/claim](https://plex.tv/claim) immediately before first launch. It expires quickly. After the server is claimed, remove the token from the local `.env` file.

### `TAILSCALE_AUTHKEY`

Auth key from the [Tailscale admin console](https://login.tailscale.com/admin/settings/keys). Treat it as a secret. Use a key with the minimum required permissions and an expiry policy appropriate to your setup.

### `CLOUDFLARE_TUNNEL_TOKEN`

Token for the named Cloudflare Tunnel configured in the dashboard. Keep it private. If you do not use Cloudflare Tunnel, do not configure or start that service.

---

## Existing Installations and Safety Checks

If the stack is already running, do not treat the quick-start instructions as an upgrade procedure.

1. **Back up first.** Back up `CONFIG_ROOT`, `.env`, and any custom scripts. Keep secrets in a secure location.
2. **Record current paths.** Check the actual Compose bind mounts and each app's configured root/download paths. Do not change paths just to match this repository's examples.
3. **Protect download state.** Do not move or rename torrent directories while qBittorrent is seeding. A path change can make torrents appear missing.
4. **Protect Tailscale identity.** The current Compose file stores state at `/var/lib/tailscale` on the host. Do not change this mount casually; a new or empty state directory may cause the NAS to register as a different Tailscale device.
5. **Pi-hole needs a separate review.** Its current environment variables include legacy names. Review the Pi-hole version, persisted settings, and port-53 ownership before changing Compose. See [Pi-hole Setup](pihole.md).
6. **Validate before applying.** Run `sudo docker compose config` and inspect the rendered paths and environment. Then update one service at a time where practical.
7. **Do not blindly update all images.** Several services use `:latest`. Read release notes and back up app configuration before pulling and recreating containers.

### Useful inspection commands

```bash
sudo docker compose config
sudo docker compose ps
sudo docker compose logs --tail=100 SERVICE_NAME
sudo docker inspect qbittorrent
sudo ss -tulpn
```

These commands inspect configuration and runtime state. Avoid posting their full output publicly because it may contain internal addresses, tokens, or other sensitive values.
