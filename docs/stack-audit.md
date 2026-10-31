# Stack Audit — Review Notes

This document records issues identified during a repository review. It separates documentation/setup corrections from runtime changes that need the operator to inspect the actual NAS first.

## Changes made on this branch

- README quick start now uses the repository's actual location under `/volume1/docker`, calls out existing-install safety, and validates Compose before startup.
- Makefile setup reads only `CONFIG_ROOT` and `DATA_ROOT` from `.env` rather than parsing every secret as Make syntax; defaults retain the documented `/volume1` layout.
- qBittorrent and wiring guides include the anime category and use container-visible paths.
- Folder structure documentation matches the Compose bind mounts.
- Prowlarr documentation includes the separate Sonarr Anime app and internal Docker service URLs.
- Pi-hole guide documents v6 variable names and warns against blindly disabling UGOS DNS services.
- Cloudflare guide distinguishes named tunnels from temporary Quick Tunnels and removes the invalid assumption that a named tunnel can publish a stable `trycloudflare.com` hostname.
- Tailscale, Plex, Jellyfin, Bazarr, and existing-installation guidance emphasize private access, persistent state, and path consistency.

## Runtime items intentionally not changed

### 1. Pi-hole v6 environment migration — requires NAS review

The Compose file currently contains legacy Pi-hole variables (`WEBPASSWORD`, `PIHOLE_DNS_`, and `DNSMASQ_LISTENING`) alongside `FTLCONF_webserver_port`. Current Pi-hole v6 documentation maps these to the `FTLCONF_...` family. The correct listening mode and effective password must be checked against the actual installation and persisted `/etc/pihole` data before changing the service.

Do not blindly replace variables and recreate Pi-hole on a live network. Back up the Pi-hole config, confirm the running image/version, review current FTL settings, confirm port 53 ownership, and plan a rollback first.

References:
- [Pi-hole Docker configuration](https://docs.pi-hole.net/docker/configuration/)
- [Pi-hole v5 to v6 migration](https://docs.pi-hole.net/docker/upgrading/v5-v6/)

### 2. Host DNS and DHCP

Pi-hole uses `network_mode: host`. The repository cannot safely assume that UGOS's `dnsmasq` service is disposable. Identify the actual listener on port 53 and what depends on it. Do not stop or disable a host service without a tested recovery path. Do not run two DHCP servers on the same LAN.

### 3. Tailscale state path

Compose currently binds host `/var/lib/tailscale` to container `/var/lib/tailscale`. This may be a deliberate existing state location. Changing it to a project-local directory or a named volume without migrating the state could create a new Tailscale node identity. The path is preserved on this branch.

### 4. Download paths and hardlinks

The repository's Compose mounts qBittorrent's host torrent directory at `/data/torrents`, while Sonarr/Radarr mount the full data root at `/data`. The docs now reflect that. Existing app settings may differ; verify the running container mounts and qBittorrent's actual save paths before changing any paths or categories.

### 5. Cloudflare exposure

The Compose file starts a token-based named tunnel if configured. Public hostnames are controlled in Cloudflare's dashboard, not by Compose. Do not expose admin tools or download clients publicly. Test Plex compatibility and authentication before publishing a hostname.

### 6. Image tags and upgrades

Services use floating `:latest` tags. This is convenient but means a later pull can introduce application or configuration changes. Back up config directories, read release notes, and update in a controlled sequence. A successful `docker compose config` validates syntax/interpolation; it does not prove that an application will start or that a migration is safe.

## Suggested pre-deployment checks

Run these from the directory containing the Compose file:

```bash
sudo docker compose config
sudo docker compose ps
sudo docker inspect qbittorrent
sudo ss -tulpn
```

Before runtime changes, save the current `.env` securely, the Compose file, app configuration/database backups, qBittorrent save paths/categories, Pi-hole DNS/DHCP settings, and a Tailscale state recovery plan.

## Scope boundary

This branch does not change `docker-compose.yml`, stop/recreate containers, alter NAS files, or contain credentials. Runtime changes should be proposed separately after the live NAS configuration has been inspected.
